<?php
require_once '../subsetAdmin/write.php';
require_once '../config/core.php';
require_once '../operationDB/subsetsOperation.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $notice_id = $data->notice_id;
    $pages = $data->page;

    if (!empty($notice_id) && !empty($pages)) {
        $db = new subsetsOperation();
        $page = (int) $pages;
        $limit = 2;
        $con = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        $total = mysqli_num_rows(mysqli_query($con, "SELECT comments_table.comment_id, comments_table.comment,comments_table.created_at,
        teacher_table.username,teacher_table.image 
        FROM `comments_table` 
        INNER JOIN teacher_table 
        ON comments_table.user_id=teacher_table.user_id 
        WHERE comments_table.notice_id='$notice_id'
        UNION ALL 
        SELECT comments_table.comment_id,comments_table.comment,comments_table.created_at ,
        student_table.username,student_table.image 
        FROM comments_table 
        INNER JOIN student_table 
        ON comments_table.user_id=student_table.user_id 
        WHERE comments_table.notice_id='$notice_id'"));

        $page_limit = (int) ($total / $limit);

        $start = ($page - 1) * $limit;
        //SQL query to fetch data of a range
        $sql = "SELECT comments_table.comment_id, comments_table.comment,comments_table.created_at,
        teacher_table.username,teacher_table.image,teacher_table.user_id 
        FROM `comments_table` 
        INNER JOIN teacher_table 
        ON comments_table.user_id=teacher_table.user_id 
        WHERE comments_table.notice_id='$notice_id'
        UNION ALL 
        SELECT comments_table.comment_id,comments_table.comment,comments_table.created_at ,
        student_table.username,student_table.image,student_table.user_id
        FROM comments_table 
        INNER JOIN student_table 
        ON comments_table.user_id=student_table.user_id 
        WHERE comments_table.notice_id='$notice_id'
        LIMIT $start,$limit";

        $result = mysqli_query($con, $sql);

        //Adding results to an array
        while ($row = mysqli_fetch_array($result)) {
            array_push($response, array(
                'id' => $row['comment_id'],
                'comment' => $row['comment'],
                'time' => $db->time_Ago(strtotime($row['created_at'])),
                'name' => $row['username'],
                'image' => $row['image'],
                'user_id' => $row['user_id']
            ));
        }

        echo json_encode($response);
    }
}
