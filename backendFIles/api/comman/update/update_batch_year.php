<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coachingID = $data->coaching_id;
    $year_id = $data->year_id;
    $batch_id_old = $data->batch_id_old;
    $batch_id_new = $data->batch_id_new;

    if (!empty($coachingID) && !empty($year_id) && !empty($batch_id_old) && !empty($batch_id_new)) {
        $response = array();
        $db = new subsetsOperation();
        $getData = $db->updateToNewBatch($coachingID, $year_id, $batch_id_new, $batch_id_old);
        if ($getData) {
            $response['error'] = false;
            $response['message'] = "Updated succesfully";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please try again";
        }
        echo json_encode($response);
    }
}
