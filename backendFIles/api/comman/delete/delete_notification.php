<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $notification_id = $data->id;
    if (!empty($notification_id)) {
        $db = new adminoperations();
        $getData = $db->deleteNotification($notification_id);
        if ($getData) {
            $response['error'] = false;
            $response['message'] = "Deleted successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}

