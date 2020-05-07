<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $class_id = $data->class_id;
    $subject_id = $data->subject_id;

    if (!empty($coaching_id) && !empty($class_id) && !empty($subject_id)) {
        $db = new subsetsOperation();
        $getData = $db->fetchNotes($coaching_id, $class_id, $subject_id);
        echo json_encode($getData);
    }
}
