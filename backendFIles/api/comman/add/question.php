<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $question_id = $data->question_id;
    $question = $data->question;
    $user_id = $data->user_id;
    $subject_id = $data->subject_id;
    $files = $data->files;
    $class_id = $data->class_id;

    if (!empty($question_id) && !empty($question) && !empty($user_id) && !empty($subject_id) && !empty($class_id)) {
        $db = new usersOperation();
        $data = $db->addQuestion($question_id, $question, $user_id, $subject_id, $files, $class_id);
        if ($data) {
            $response['error'] = false;
            $response['message'] = "Added successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs";
        }
    }
    echo json_encode($response);
}
