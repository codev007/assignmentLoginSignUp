<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $user_id = $data->user_id;
    $coaching_id = $data->coaching_id;
    $comment = $data->comment;
    if (!empty($user_id) && !empty($coaching_id) && !empty($comment)) {
        $response = array();
        $db = new usersOperation();
        $postData = $db->addCoachingComments($user_id, $coaching_id, $comment);
        if ($postData) {
            $response['error'] = false;
            $response['message'] = "Comment added successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs please try again";
        }
        echo json_encode($response);
    }
}
