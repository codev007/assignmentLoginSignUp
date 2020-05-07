<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../write.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    $batchName = $data->batch_name;
    $coachingId = $data->coaching_id;
    $classId = $data->class_id;
    if (!empty($batchName) && !empty($coachingId) && !empty($classId)) {
        $db = new subsetsOperation();
        // createNewBatch code
        $result = $db->createNewBatch($batchName, $coachingId,$classId);
        if (!$result) {
            $response['error'] = true;
            $response['message'] = 'Batch already exist';
        } else {
            $response['error'] = false;
            $response['message'] = 'Batch created successfully';
        }
    }
}

echo json_encode($response);
