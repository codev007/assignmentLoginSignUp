<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));

    $question_id = $data->question_id;
    $user_id = $data->user_id;
    if (!empty($question_id) && !empty($user_id)) {

        $response = array();
        $db = new subsetsOperation();
        $maindata=array();

        $question_info = $db->getQuesInfo($question_id);
        $question_files = $db->getQuesFiles($question_id);
        $like_info = $db->getQuesLikeInfo($question_id, $user_id);
        $response['files'] = $question_files;
        $response['like'] = $like_info['value'];
        $response['name'] = $question_info['username'];
        $response['image'] = $question_info['image'];
        $response['created_at'] = $db->time_Ago(strtotime($question_info['created_at']));
        $response['subject_name'] = $question_info['subject_name'];
        $response['class_name'] = $question_info['class_name'];
        $response['question'] = $question_info['question'];
        $response['token'] = $question_info['token'];
        $maindata[]=$response;

        echo json_encode($maindata);
    }
}
