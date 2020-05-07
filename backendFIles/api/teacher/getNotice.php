<?php
require_once '../subsetAdmin/write.php';
require_once '../config/core.php';
require_once '../operationDB/subsetsOperation.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $user_type = $data->user_type;
    $year_id = $data->year_id;
    $pages = $data->page;

    if (!empty($coaching_id) && !empty($user_type) && !empty($year_id)) {
        $db = new subsetsOperation();
        $page = (int) $pages;
        $limit = 10;
        $con = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        $total = mysqli_num_rows(mysqli_query($con, "SELECT notice_table.notice_id AS id, 
        notice_table.title , notice_table.description,notice_table.created_at,notice_table.type , 
        teacher_table.username,teacher_table.image,teacher_table.token 
        FROM `notice_table` 
        INNER JOIN coaching_user_connection_table 
        ON notice_table.user_uid = coaching_user_connection_table.user_uid 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id 
        WHERE coaching_user_connection_table.user_type= '$user_type' 
        AND coaching_user_connection_table.coaching_id='$coaching_id' 
        AND coaching_user_connection_table.year_id='$year_id'"));

        $page_limit = (int) ($total / $limit);

        $start = ($page - 1) * $limit;
        //SQL query to fetch data of a range
        $sql = "SELECT notice_table.notice_id AS id, 
        notice_table.title , notice_table.description,notice_table.created_at,notice_table.type , 
        teacher_table.username,teacher_table.image,teacher_table.token ,
        (SELECT COUNT(*) FROM comments_table
        WHERE notice_id = notice_table.notice_id) AS comment_count,(SELECT COUNT(*) FROM notice_likes
        WHERE notice_id = notice_table.notice_id AND value ='1') AS like_count,(SELECT COUNT(*) FROM notice_likes
        WHERE notice_id = notice_table.notice_id AND value ='0') AS dislike_count
        FROM `notice_table` 
        INNER JOIN coaching_user_connection_table 
        ON notice_table.user_uid = coaching_user_connection_table.user_uid 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id 
            WHERE coaching_user_connection_table.user_type = '$user_type' 
            AND coaching_user_connection_table.coaching_id = '$coaching_id' 
            AND coaching_user_connection_table.year_id = '$year_id'
            ORDER BY `notice_table`.`created_at` DESC 
            limit $start,$limit";

        $result = mysqli_query($con, $sql);

        //Adding results to an array
        while ($row = mysqli_fetch_array($result)) {
            array_push($response, array(
                'title' => $row['title'],
                'description' => $row['description'],
                'time' => $db->time_Ago(strtotime($row['created_at'])),
                'id' => $row['id'],
                'name' => $row['username'],
                'image' => $row['image'],
                'type' => $row['type'],
                'token' => $row['token'],
                'comment_count' => $row['comment_count'],
                'like_count' => $row['like_count'],
                'dislike_count' => $row['dislike_count']
            ));
        }
        echo json_encode($response);
    }
}
