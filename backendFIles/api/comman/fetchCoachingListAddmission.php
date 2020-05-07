<?php
require_once '../subsetAdmin/write.php';
require_once '../operationDB/subsetsOperation.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $mobile = $data->mobile;
    if (!empty($mobile)) {
        $db = new subsetsOperation();
        $getData = $db->getCoachingList($mobile);
        echo json_encode($getData);
    }
}

