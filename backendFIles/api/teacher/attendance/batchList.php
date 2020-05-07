<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $date = $data->date;
    if (!empty($coaching_id) && !empty($date)) {

        $db = new subsetsOperation();
        $batchList = $db->getAttendanceBatchListFetch($coaching_id,$date);
        echo json_encode($batchList);
    } else {
        $db = new subsetsOperation();
        $batchList = $db->getAttendanceBatchList($coaching_id);
        echo json_encode($batchList);
    }
}
