<?php
include_once '../operationDB/usersOperations.php';
include_once '../subsetAdmin/write.php';
$response = array();

if ($_SERVER['REQUEST_METHOD'] = 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    $user_uid = $data->user_uid;
    $user_id = $data->user_id;
    $batch_id = $data->batch_id;
    $admission_date = $data->admission_date;
    $year_id = $data->year_id;
    $user_type = $data->user_type;
    $coaching_id = $data->coaching_id;
    $status = $data->status;

    if (!empty($user_uid) && !empty($user_id) && !empty($batch_id) && !empty($admission_date) && !empty($year_id) && !empty($user_type) && !empty($coaching_id)) {
        $db = new usersOperation();
        if ($db->alreadyRequested($user_type, $coaching_id, $year_id, $user_id)) {

            $response['error'] = true;
            $response['message'] = 'Already Registered !! You can not rend more then one request to same coaching';
        } else {
            $user_data = $db->admissionRequest($user_uid, $user_id, $batch_id, $admission_date, $year_id, $user_type, $coaching_id, $status);
            if ($user_data) {
                $response['error'] = false;
                $response['message'] = 'Your request has been sent to coaching admin . Please wait until verified your profile by coaching admin ';
                $response['user_id'] = $data->user_id;
            } else {
                $response['error'] = true;
                $response['message'] = 'Problem occurs . Please try again';
            }
	}
	echo json_encode($response);
    }
}


