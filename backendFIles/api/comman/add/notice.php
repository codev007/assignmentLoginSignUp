<?php
require_once '../../subsetAdmin/write.php';
require_once '../../operationDB/usersOperations.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $notice_id = $data->notice_id;
    $title = $data->title;
    $description = $data->description;
    $user_uid = $data->user_uid;
    $batch_id = $data->batch_id;
    $type = $data->type;
    $file = $data->file;
    $fileType = $data->fileType;

    if (!empty($notice_id) && !empty($title) && !empty($description) && !empty($user_uid) && !empty($batch_id) && !empty($type) && !empty($fileType)) {
        $db = new usersOperation();
        $notice_data = $db->addNotice($notice_id, $title, $description, $user_uid, $batch_id, $type, $file, $fileType);
        if ($notice_data) {
            $response['error'] = false;
            $response['message'] = 'Notice or Assignment added successfully';
        } else {
            $response['error'] = true;
            $response['message'] = 'Problem occurs please try again !';
        }
        echo json_encode($response);
    }
}
