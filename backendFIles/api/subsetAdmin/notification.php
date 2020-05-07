<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $title = $data->title;
    $description = $data->description;
    $coaching_id = $data->coaching_id;
    $year_id=$data->year_id;
    if (!empty($title) && !empty($description) && !empty($coaching_id) && !empty($year_id)) {
        $response = array();
        $db = new adminoperations();
        $postData = $db->addNotification($title, $description, $coaching_id,$year_id);
        if ($postData) {
            $response['error'] = false;
            $response['message'] = "Notification sent successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}
