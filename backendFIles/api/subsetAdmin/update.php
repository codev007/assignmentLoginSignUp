<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $type = $data->type;
    $coaching_id = $data->coaching_id;
    $mainData = $data->data;
    if (!empty($type)) {
        $response = array();
        $db = new adminoperations();
        if ($type == 3) {
            $Repond = $db->updateAcievements($mainData, $coaching_id);
            if ($Repond) {
                $response['error'] = false;
                $response['message'] = "Updated successfully";
            } else {
                $response['error'] = true;
                $response['message'] = "Problem occurs";
            }
        } elseif ($type == 2) {
            $Repond1 = $db->updateImage($mainData, $coaching_id);
            if ($Repond1) {
                $response['error'] = false;
                $response['message'] = "Updated successfully";
            } else {
                $response['error'] = true;
                $response['message'] = "Problem occurs";
            }
        } elseif ($type == 1) {
            $Repond2 = $db->updateLogo($mainData, $coaching_id);
            if ($Repond2) {
                $response['error'] = false;
                $response['message'] = "Updated successfully";
            } else {
                $response['error'] = true;
                $response['message'] = "Problem occurs";
            }
        }
        echo json_encode($response);
    }
}
