<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $user_uid = $data->user_uid;
    $value = $data->value;
    if (!empty($user_uid)) {
        $response = array();
        $db = new adminoperations();
        $responseData = $db->requestHandler($user_uid, $value);
        if ($responseData) {
            $response['error'] = false;
            $response['message'] = "Updated successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem Occurs ! Try again";
        }
        echo json_encode($response);
    }
}
