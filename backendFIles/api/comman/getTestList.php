<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    $batch_id = $data->batch_id;
    $year_id = $data->year_id;
    if (!empty($batch_id) & !empty($year_id)) {
        $db = new subsetsOperation();
        $response = $db->getTestList($batch_id, $year_id);
        echo json_encode($response);
    }
}
