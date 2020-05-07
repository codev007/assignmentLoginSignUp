<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $class_id = $data->class_id;
    $subject_id = $data->subject_id;
    $title = $data->title;
    $file = $data->file;

    if (
        !empty($coaching_id) && !empty($class_id)
        && !empty($subject_id) && !empty($title) && !empty($file)
    ) {
        $response = array();
        $db = new subsetsOperation();
        $getData = $db->uploadNotes($coaching_id, $class_id, $subject_id, $title, $file);
        if ($getData) {
            $response['error'] = false;
            $response['message'] = "Notes uploaded successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}
