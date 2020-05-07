<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $mobileNumber = $data->mobile;
    if (!empty($mobileNumber)) {
        $db = new subsetsOperation();
        $getData = $db->getChildrenList($mobileNumber);
        echo json_encode($getData);
    }
}
