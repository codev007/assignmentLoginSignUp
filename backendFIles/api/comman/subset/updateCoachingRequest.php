<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $value = $data->value;
    if (!empty($coaching_id)) {
        $response = array();
        $db = new adminoperations();
        $postData = $db->updateCoachingStatus($coaching_id, $value);
        if ($postData) {
            $response['error'] = false;
            $response['message'] = "Updated successfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs";
        }
        echo json_encode($response);
    }
}
