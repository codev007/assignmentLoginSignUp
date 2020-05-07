<?php
require_once '../subsetAdmin/write.php';
require_once '../config/core.php';
require_once '../operationDB/subsetsOperation.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $question_id = $data->question_id;
    $pages = $data->page;

    if (!empty($question_id) && !empty($pages)) {
        $db=new subsetsOperation();
        $page = (int) $pages;
        $limit = 10;
        $con = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        $total = mysqli_num_rows(mysqli_query($con, "SELECT answer_table.answer_id,
        answer_table.answer,answer_table.created_at, teacher_table.username,teacher_table.image 
        FROM answer_table 
        INNER JOIN coaching_user_connection_table 
        ON answer_table.user_id=coaching_user_connection_table.user_id 
        INNER JOIN teacher_table 
        ON answer_table.user_id=teacher_table.user_id 
        WHERE coaching_user_connection_table.user_type='T' 
        AND answer_table.question_id='$question_id'
        UNION ALL
        SELECT answer_table.answer_id,answer_table.answer,answer_table.created_at, 
        student_table.username,student_table.image 
        FROM answer_table INNER JOIN coaching_user_connection_table 
        ON answer_table.user_id=coaching_user_connection_table.user_id 
        INNER JOIN student_table ON answer_table.user_id=student_table.user_id 
        WHERE coaching_user_connection_table.user_type='S' 
        AND answer_table.question_id='$question_id'"));

        $page_limit = (int) ($total / $limit);

        $start = ($page - 1) * $limit;
        //SQL query to fetch data of a range
        $sql = "SELECT answer_table.answer_id,
        answer_table.answer,answer_table.created_at, teacher_table.username,teacher_table.image,teacher_table.user_id 
        FROM answer_table 
        INNER JOIN coaching_user_connection_table 
        ON answer_table.user_id=coaching_user_connection_table.user_id 
        INNER JOIN teacher_table 
        ON answer_table.user_id=teacher_table.user_id 
        WHERE coaching_user_connection_table.user_type='T' 
        AND answer_table.question_id='$question_id'
        UNION ALL
        SELECT answer_table.answer_id,answer_table.answer,answer_table.created_at, 
        student_table.username,student_table.image ,student_table.user_id
        FROM answer_table INNER JOIN coaching_user_connection_table 
        ON answer_table.user_id=coaching_user_connection_table.user_id 
        INNER JOIN student_table ON answer_table.user_id=student_table.user_id 
        WHERE coaching_user_connection_table.user_type='S'
        AND answer_table.question_id='$question_id'
        LIMIT $start,$limit";

        $result = mysqli_query($con, $sql);

        //Adding results to an array
        while ($row = mysqli_fetch_array($result)) {
            array_push($response, array(
                'id' => $row['answer_id'],
                'answer' => $row['answer'],
                'time' => $db->time_Ago(strtotime($row['created_at'])),
                'name' => $row['username'],
                'image' => $row['image'],
                'user_id' => $row['user_id'],
                'files' => $db->getAnswerFiles($row['answer_id'])
            ));
        }
        echo json_encode($response);
    }
}


