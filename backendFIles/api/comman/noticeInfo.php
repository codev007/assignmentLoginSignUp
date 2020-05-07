<?php
require_once '../operationDB/subsetsOperation.php';
require_once '../config/core.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $notice_id = $data->notice_id;
    $user_id = $data->user_id;
    if (!empty($notice_id) && !empty($user_id)) {
        $db = new subsetsOperation();
        $response = array();
        $maindata=array();
        $notice_info = $db->getNoticeInfo($notice_id);
        $notice_files = $db->getNoticeFiles($notice_id);
        $like_info=$db->getNoticeLikeInfo($notice_id,$user_id);
        $response['files'] = $notice_files;
        $response['title'] = $notice_info['title'];
        $response['description'] = $notice_info['description'];
        $response['created_at'] = $db->time_Ago(strtotime($notice_info['created_at']));
        $response['batch_name'] = $notice_info['batch_name'];
        $response['name'] = $notice_info['username'];
        $response['image'] = $notice_info['image'];
        $response['type'] = $notice_info['type'];
        $response['like']=$like_info['value'];
        $response['token']=$notice_info['token'];
        $maindata[]=$response;
        echo json_encode($maindata);
    }
}
