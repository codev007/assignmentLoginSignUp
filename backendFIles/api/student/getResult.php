<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $user_uid = $data->user_uid;
    $test_id = $data->test_id;
    if (!empty($user_uid) && !empty($test_id)) {
        $db = new subsetsOperation();
        $response = array();
        $userData = $db->getResultUserData($user_uid);
        $userTestData = $db->getTestData($test_id);
        $response['name'] = $userData['username'];
        $response['image'] = $userData['image'];
        $response['test_name'] = $userTestData['test_name'];
        $response['created_at'] = $db->time_Ago(strtotime($userTestData['created_at']));
        $response['result'] = $db->getResult($test_id, $user_uid);
        $postData[] = $response;
        echo json_encode($postData);
    }
}
