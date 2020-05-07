<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';
require_once '../config/core.php';


if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $date = $data->date;
    $user_id = $data->user_id;
    $value = $data->value;
    $response = array();

    if (!empty($value)) {
        $db = new subsetsOperation();
        $data = $db->AddAttendance($date, $user_id, $value);
        if ($data) {
            $response['error'] = false;
            $response['message'] = "Attendace added successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs , Please try again";
        }
        echo json_encode($response);
    }
}
