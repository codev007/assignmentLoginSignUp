<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $type = $data->type;
    $id = $data->id;
    if (!empty($type) && !empty($id)) {
        $db = new subsetsOperation();
        if ($type == 'S') {
            $getData = $db->getStates();
            echo json_encode($getData);
        } else if ($type == 'D') {
            $getData = $db->getDistricts($id);
            echo json_encode($getData);
        } else if ($type == 'A') {
            $getData = $db->getArea($id);
            echo json_encode($getData);
        }
    }
}

