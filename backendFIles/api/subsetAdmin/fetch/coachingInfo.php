<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    if (!empty($coaching_id)) {
        $response = array();
        $db = new adminoperations();
        $getData = $db->getCoachingDetails($coaching_id);
        $response['coaching_id'] = $getData['coaching_id'];
        $response['coaching_name'] = $getData['coaching_name'];
        $response['tagline'] = $getData['tagline'];
        $response['address'] = $getData['address'];
        $response['email'] = $getData['email'];
        $response['contact'] = $getData['contact'];
        $response['coaching_description'] = $getData['coaching_description'];
        $response['achievements'] = $getData['achievements'];
        $response['establishmentat'] = $getData['establishmentat'];
        $response['logo'] = $getData['logo'];
        $response['scount'] = $getData['scount'];
        $response['tcount'] = $getData['tcount'];
        $response['image'] = $getData['image'];
        $response['staff'] = $db->getStaff($coaching_id);
        $maindata[] = $response;

        echo json_encode($maindata);
    }
}
