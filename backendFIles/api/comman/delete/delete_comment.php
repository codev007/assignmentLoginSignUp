<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $comment_id = $data->comment_id;
    $user_id = $data->user_id;
    if (!empty($comment_id) && !empty($user_id)) {
        $db = new usersOperation();
        $getData = $db->deleteComment($comment_id, $user_id);
        if ($getData) {
            $response['error'] = false;
            $response['message'] = "Deleted successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}

