<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $batch_id = $data->batch_id;
    $coaching_id = $data->coaching_id;
    if (!empty($batch_id) && !empty($coaching_id)) {
        $response=array();
        $db = new subsetsOperation();
        $getData=$db->deleteBatch($batch_id,$coaching_id);
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

