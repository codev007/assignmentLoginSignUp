<?php
require_once '../../operationDB/usersOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));
    $user_id = $data->user_id;
    $parent_subject = $data->parent_subject;
    $date_of_birth = $data->date_of_birth;
    $school_experience = $data->school_experience;
    $type = $data->type;

    if (!empty($user_id) && !empty($parent_subject) && !empty($date_of_birth) && !empty($school_experience) && !empty($type)) {
        $db = new usersOperation();
        $response = array();
        if ($type == 'S') {
            $getData = $db->updateStudentProfile($parent_subject,$date_of_birth,$school_experience,$user_id);
            if ($getData) {
                $response['error'] = false;
                $response['message'] = "Updated successfully";
            } else {
                $response['error'] = true;
                $response['message'] = "Problem occurs ! Please try again";
            }
        } else if ($type == 'T') {
            $getData = $db->updateTeacherProfile($parent_subject,$date_of_birth,$school_experience,$user_id);
            if ($getData) {
                $response['error'] = false;
                $response['message'] = "Updated successfully";
            } else {
                $response['error'] = true;
                $response['message'] = "Problem occurs ! Please try again";
            }
        }
        echo json_encode($response);
    }
}
