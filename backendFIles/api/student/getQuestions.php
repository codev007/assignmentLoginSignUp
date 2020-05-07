<?php
require_once '../config/core.php';
require_once '../operationDB/subsetsOperation.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $class_id = $data->class_id;
    $pages = $data->page;

    if (!empty($class_id)) {
        $db = new subsetsOperation();
        $response = array();
        $page = (int) $pages;
        $limit = 10;
        $con = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        $total = mysqli_num_rows(mysqli_query($con, "SELECT question_table.question_id,
        question_table.question,question_table.created_at,subject_table.subject_name,
        student_table.username,student_table.image,
        (SELECT COUNT(*) FROM answer_table WHERE question_id=question_table.question_id) AS answer_count , 
        (SELECT COUNT(*) FROM question_like WHERE question_id=question_table.question_id AND question_like.value=1) AS like_count,
        (SELECT COUNT(*) FROM question_like WHERE question_id=question_table.question_id AND question_like.value=0) AS dislike_count 
        FROM question_table 
        INNER JOIN student_table 
        ON student_table.user_id=question_table.user_id 
        INNER JOIN subject_table 
        ON question_table.subject_id=subject_table.subject_id 
        WHERE question_table.class_id='$class_id'"));

        $page_limit = (int) ($total / $limit);

        $start = ($page - 1) * $limit;
        //SQL query to fetch data of a range
        $sql = "SELECT question_table.question_id,
        question_table.question,question_table.created_at,subject_table.subject_name,
        student_table.username,student_table.image,
        (SELECT COUNT(*) FROM answer_table WHERE question_id=question_table.question_id) AS answer_count , 
        (SELECT COUNT(*) FROM question_like WHERE question_id=question_table.question_id AND question_like.value=1) AS like_count,
        (SELECT COUNT(*) FROM question_like WHERE question_id=question_table.question_id AND question_like.value=0) AS dislike_count 
        FROM question_table 
        INNER JOIN student_table 
        ON student_table.user_id=question_table.user_id 
        INNER JOIN subject_table 
        ON question_table.subject_id=subject_table.subject_id 
        WHERE question_table.class_id='$class_id'
        ORDER BY question_table.created_at DESC
        LIMIT $start,$limit";

        $result = mysqli_query($con, $sql);

        //Adding results to an array
        while ($row = mysqli_fetch_array($result)) {
            array_push($response, array(
                'id' => $row['question_id'],
                'question' => $row['question'],
                'time' => $db->time_Ago(strtotime($row['created_at'])),
                'subject_name' => $row['subject_name'],
                'image' => $row['image'],
                'name' => $row['username'],
                'answer_count' => $row['answer_count'],
                'like_count' => $row['like_count'],
                'dislike_count' => $row['dislike_count']
            ));
        }
        echo json_encode($response);
    }
}
