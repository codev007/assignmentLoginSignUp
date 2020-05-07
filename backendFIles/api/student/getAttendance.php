<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $user_uid = $data->user_uid;
    if (!empty($user_uid)) {
        $db = new subsetsOperation();
        $response = $db->getAttendance($user_uid);
        echo json_encode($response);
    }
}
