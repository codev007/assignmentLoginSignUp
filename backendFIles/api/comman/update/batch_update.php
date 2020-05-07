<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $batch_id = $data->batch_id;
    $batch_name = $data->batch_name;
    $coaching_id = $data->coaching_id;
    $class_id = $data->class_id;
    if (!empty($batch_id) && !empty($batch_name) && !empty($coaching_id) && !empty($class_id)) {
        $response = array();
        $db = new subsetsOperation();
        $getData = $db->updateBatch($batch_id, $batch_name, $coaching_id, $class_id);
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

