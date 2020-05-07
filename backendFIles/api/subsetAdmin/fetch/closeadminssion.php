<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    if (!empty($coaching_id)) {
        $db = new subsetsOperation();
        $getData = $db->getAdmissionCount($coaching_id);
        echo json_encode($getData);
    }
}

