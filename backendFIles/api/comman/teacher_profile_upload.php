<?php
require_once '../subsetAdmin/write.php';
require_once '../operationDB/usersOperations.php';

if ($_SERVER['REQUEST_METHOD'] = 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $user_id = $data->user_id;
    $username = $data->username;
    $mobile = $data->mobile;
    $address = $data->address;
    $birth = $data->birth;
    $gender = $data->gender;
    $father_husband = $data->father_husband;
    $image = $data->image;
    $subjects = $data->subjects;
    $experience = $data->experience;
    $token = $data->token;

    if (
        !empty($user_id) && !empty($username) && !empty($mobile) && !empty($address)
        && !empty($birth) && !empty($gender) && !empty($father_husband) && !empty($image)
        && !empty($subjects) && !empty($experience) && !empty($token)
    ) {
        $response = array();

        $db = new usersOperation();

        $user_data = $db->profile_push_teacher($user_id, $username, $mobile, $address, $birth, $gender, $father_husband, $image, $subjects, $experience, $token);

        if ($user_data) {
            $response['error'] = false;
            $response['message'] = 'Profile uploaded successfully';
            $response['user_id'] = $data->user_id;
        } else {
            $response['error'] = true;
            $response['message'] = 'Problem occurs . Please try again';
        }
        echo json_encode($response);
    }
}
