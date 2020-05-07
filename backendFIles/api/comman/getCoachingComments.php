<?php
require_once '../operationDB/usersOperations.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;

    if (!empty($coaching_id)) {
        $db = new usersOperation();
        $getData = $db->getCoachingComments($coaching_id);
        echo json_encode($getData);
    }
}
