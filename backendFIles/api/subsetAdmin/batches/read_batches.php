<?php
require_once '../write.php';
require_once '../../operationDB/subsetsOperation.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $coachingId = $data->coaching_id;

    if (!empty($coachingId)) {
        $db = new subsetsOperation();
        $batchList = $db->getAttendanceBatchList($coachingId);
        echo json_encode($batchList);
    }
}
