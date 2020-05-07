<?php
require_once '../../operationDB/subsetsOperation.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $question_id = $data->question_id;
    $user_id = $data->user_id;
    $value = $data->value;
    if (!empty($question_id) && !empty($user_id)) {
        $db = new subsetsOperation();
        $dataR = $db->LikeQuestion($question_id, $user_id, $value);
        if($dataR){
            $response['error']=false;
            $response['message']="Submitted";
        }else{
            $response['error']=true;
            $response['message']="Failed";
        }

        echo json_encode($response);
    }
}