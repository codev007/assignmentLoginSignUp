<?php
require_once '../operationDB/usersOperations.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_type = "";
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $user_id = $data->user_id;

    if ($data->user_type == "P") {
        $user_type = "S";
    } else {
        $user_type = $data->user_type;
    }
    if (!empty($user_id) && !empty($user_type)) {
        $db = new usersOperation();
        if ($user_type == "S") {
            $user_data = $db->studentProfile($user_id);
            $response['user_id'] = $user_data['user_id'];
            $response['username'] = $user_data['username'];
            $response['mobile'] = $user_data['mobile'];
            $response['address'] = $user_data['address'];
            $response['birth'] = $user_data['birth'];
            $response['gender'] = $user_data['gender'];
            $response['father_name'] = $user_data['father_name'];
            $response['image'] = $user_data['image'];
            $response['school_subject'] = $user_data['school_name'];
            $response['parents_experience'] = $user_data['parents_mobile'];
            $response['token'] = $user_data['token'];
        } else if ($user_type = "T") {
            $user_data = $db->teacherProfile($user_id);
            $response['user_id'] = $user_data['user_id'];
            $response['username'] = $user_data['username'];
            $response['mobile'] = $user_data['mobile'];
            $response['address'] = $user_data['address'];
            $response['birth'] = $user_data['birth'];
            $response['gender'] = $user_data['gender'];
            $response['father_name'] = $user_data['father_husband'];
            $response['image'] = $user_data['image'];
            $response['school_subject'] = $user_data['subjects'];
            $response['parents_experience'] = $user_data['experience'];
            $response['token'] = $user_data['token'];
        }
        echo json_encode($response);
    }
}
