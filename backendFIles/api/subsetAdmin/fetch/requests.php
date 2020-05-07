<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    if (!empty($coaching_id)) {
        $db = new adminoperations();
        $postData1 = $db->getTeachersRequests($coaching_id);
        $postData = $db->getStudentsRequests($coaching_id);

        echo $merger=json_encode(array_merge($postData,$postData1));
    }
}
