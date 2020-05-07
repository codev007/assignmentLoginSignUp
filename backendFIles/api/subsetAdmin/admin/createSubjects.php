<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $class_id=$data->class_id;
    $subject_name=$data->subject_name;
    if(!empty($class_id) && !empty($subject_name)){
        $reponse = array();
        $db=new adminoperations();
        $getData=$db->createSubject($class_id,$subject_name);
        if ($getData) {
            $reponse['error'] = false;
            $reponse['message'] = "Subject Created Successfully";
        } else {
            $reponse['error'] = true;
            $reponse['message'] = "Failed ! Please try again";
        }
        echo json_encode($reponse);

    }
}

