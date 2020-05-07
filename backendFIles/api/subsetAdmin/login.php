<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';
$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $mobileNumber = $data->mobile_number;
    
    if (!empty($mobileNumber)) {

        $db = new adminoperations();

        if ($db->isSubsetExist($mobileNumber)) {

            $user = $db->getCoaching($mobileNumber);
            $response['error'] = false;
            $response['id'] = $user['coaching_id'];
            $response['tagline'] = $user['tagline'];
            $response['address'] = $user['address'];
            $response['email'] = $user['email'];
            $response['registration_no'] = $user['registration_no'];
            $response['expired_at'] = $user['expired_at'];
            $response['is_active'] = $user['is_active'];
            $response['logo'] = $user['logo'];
            $response['image'] = $user['image'];
            $response['name'] = $user['coaching_name'];
            $response['year_id'] = $user['year_id'];
            $response['message'] = "Welcome To Subset";
        } else {
            $response['error'] = true;
            $response['isExist'] = false;
            $response['message'] = "Sorry ! You are not registered , Please Apply for registration";
        }
    } else {

        $response['error'] = true;
        $response['message'] = "Mobile number is empty";
    }
} else {
    $response['message'] = "WrongRequest";
}
echo json_encode($response);
