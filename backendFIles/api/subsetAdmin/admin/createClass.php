<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $class_name = $data->class_name;
    if (!empty($class_name)) {
        $reponse = array();
        $db = new adminoperations();
        $getData = $db->createClass($class_name);
        if ($getData) {
            $reponse['error'] = false;
            $reponse['message'] = "Class Created Successfully";
        } else {
            $reponse['error'] = true;
            $reponse['message'] = "Failed ! Please try again";
        }
        echo json_encode($reponse);
    }
}

