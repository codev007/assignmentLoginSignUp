<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $class_id = $data->class_id;
    if (!empty($class_id)) {
        $db = new subsetsOperation();
        $getData = $db->getSubjects($class_id);
        echo json_encode($getData);
    }
}
