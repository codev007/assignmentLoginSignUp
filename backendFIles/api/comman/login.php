<?php
require_once '../subsetAdmin/write.php';
require_once '../operationDB/usersOperations.php';

$response = array();
$userType="";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $mobileNumber = $data->mobile_number;
    if($data->userType=="P"){
        $userType = "S";
    }else{
        $userType = $data->userType;
    }

    if (!empty($mobileNumber && !empty($userType))) {

        $db = new usersOperation();

        if ($db->isUserProfileExist($mobileNumber, $userType)) {

            $response['error'] = false;
            $response['message'] = 'You are registered user';

            if (strcmp($userType, "S") == 0) {
                $user_datas = $db->fetchStudentID($mobileNumber);
                $response['user_id'] = $user_datas['user_id'];

            } else if (strcmp($userType, "T") == 0) {
                $user_data = $db->fetchTeacherID($mobileNumber);
                $response['user_id'] = $user_data['user_id'];

            } else if (strcmp($userType, "P") == 0) {
                $user_datasp = $db->fetchStudentID($mobileNumber);
                $response['user_id'] = $user_datasp['user_id'];

            }
        } else {
            $response['error'] = true;
            $response['message'] = 'You are not registered .Please complete your profile first';
        }
        echo json_encode($response);
    }
}
