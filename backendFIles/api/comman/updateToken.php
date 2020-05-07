<?php
require_once '../operationDB/usersOperations.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $userID = $data->user_id;
    $type = $data->type;
    $token = $data->token;
    if (!empty($userID) && !empty($type) && !empty($token)) {
        $response = array();
        $db = new usersOperation();
        $response['error'] = $db->updateToken($userID, $type, $token);
        echo json_encode($response);
    }
}
