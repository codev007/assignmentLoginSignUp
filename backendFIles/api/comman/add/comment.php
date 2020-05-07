<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $comment = $data->comment;
    $notice_id = $data->notice_id;
    $user_id = $data->user_id;

    if ( !empty($comment) && !empty($notice_id) && !empty($user_id)) {
        $db = new usersOperation();
        $data = $db->addComments($comment, $notice_id, $user_id);
        if ($data) {
            $response['error'] = false;
            $response['message'] = "Comment added";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs";
        }
        echo json_encode($response);
    }
}
