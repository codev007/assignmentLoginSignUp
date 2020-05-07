<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $user_uid = $data->user_uid;
    $test_id = $data->test_id;
    $subject_id = $data->subject_id;
    $batch_id = $data->batch_id;
    $marks = $data->marks;
    $total = $data->total;
    $response = array();
    
    if (!empty($test_id) && !empty($batch_id) && !empty($subject_id) && !empty($total)) {
        $db = new subsetsOperation();
        $data = $db->addResultNew( $user_uid, $test_id, $subject_id, $batch_id, $marks,$total);
        if ($data) {
            $response['error'] = false;
            $response['message'] = "Result uploaded successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs , Please try again";
        }
        echo json_encode($response);
    }
}
