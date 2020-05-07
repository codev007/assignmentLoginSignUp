<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $comment_id = $data->comment_id;
    $comment = $data->comment;
    if (!empty($comment_id) && !empty($comment)) {
        $db = new usersOperation();
        $getData = $db->updateComment($comment, $comment_id);
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

