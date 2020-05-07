<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $answer_id = $data->anser_id;
    $answer = $data->answer;
    if (!empty($answer) && !empty($answer_id)) {
        $db = new usersOperation();
        $getData = $db->updateAnswer($answer, $answer_id);
        if ($getData) {
            $response['error'] = false;
            $response['message'] = "Updated successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}

