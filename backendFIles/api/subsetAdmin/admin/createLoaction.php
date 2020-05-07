<?php
require_once '../../subsetAdmin/write.php';
require_once '../../operationDB/subsetsOperation.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $type = $data->type;
    $name = $data->name;
    $id = $data->id;
    if (!empty($type) && !empty($name) && !empty($id)) {
        $response = array();
        $db = new subsetsOperation();
        if ($type == 'D') {
            $res = $db->createDistrict($name, $id);
            if ($res) {
                $response['error'] = false;
                $response['message'] = "District created";
            } else {
                $response['error'] = true;
                $response['message'] = "Failed ! Please try again";
            }
        } else if ($type == 'A') {
            $res = $db->createArea($name, $id);
            if ($res) {
                $response['error'] = false;
                $response['message'] = "Area created";
            } else {
                $response['error'] = true;
                $response['message'] = "Failed ! Please try again";
            }
        }
        echo json_encode($response);
    }
}

