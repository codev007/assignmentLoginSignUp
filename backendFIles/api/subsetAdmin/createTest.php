<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    $data = json_decode(file_get_contents("php://input"));
    $batch_id = $data->batch_id;
    $test_name = $data->test_name;
    $year_id = $data->year_id;

    if (!empty($batch_id) && !empty($test_name) && !empty($year_id)) {
        $response = array();
        $db = new adminoperations();
        $getResponse = $db->addTest($batch_id, $test_name, $year_id);
        if ($getResponse) {
            $response['error'] = false;
            $response['message'] = "Created Successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}

