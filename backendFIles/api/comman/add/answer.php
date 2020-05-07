<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $answer_id = $data->answer_id;
    $answer = $data->answer;
    $user_id = $data->user_id;
    $question_id = $data->question_id;
    $files = $data->files;
    if (!empty($answer_id) && !empty($answer) && !empty($user_id) && !empty($question_id)) {
        $db = new usersOperation();
        $data = $db->addAnswer($answer_id, $answer, $user_id, $question_id, $files);
        if ($data) {
            $response['error'] = false;
            $response['message'] = "Added successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs";
        }
        echo json_encode($response);
    }
}
