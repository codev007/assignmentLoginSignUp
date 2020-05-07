<?php
require_once '../operationDB/usersOperations.php';
require_once '../subsetAdmin/write.php';
require_once '../config/core.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_type="";
    $response = array();
    $data = json_decode(file_get_contents("php://input"));
    $user_id = $data->user_id;
//    $user_type = $data->user_type;
    if($data->user_type=="P"){
        $user_type = "S";
    }else{
        $user_type = $data->user_type;
    }
    if (!empty($user_id) && !empty($user_type)) {

        $con = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

        $sql = "SELECT coaching_table.coaching_name,coaching_user_connection_table.admission_date,
         coaching_user_connection_table.user_uid,coaching_user_connection_table.user_id, 
         coaching_user_connection_table.batch_id,coaching_user_connection_table.year_id,
          coaching_user_connection_table.user_type,coaching_user_connection_table.coaching_id,
          batch_table.class_id, coaching_user_connection_table.status 
          FROM coaching_table 
          INNER JOIN coaching_user_connection_table 
          ON coaching_user_connection_table.coaching_id=coaching_table.coaching_id 
          INNER JOIN batch_table ON coaching_user_connection_table.batch_id=batch_table.batch_id 
          WHERE coaching_user_connection_table.user_id='$user_id' 
        AND coaching_user_connection_table.user_type='$user_type';";

        $result = mysqli_query($con, $sql);
        while ($row = mysqli_fetch_array($result)) {
            array_push($response, array(
                'user_uid' => $row['user_uid'],
                'user_id' => $row['user_id'],
                'batch_id' => $row['batch_id'],
                'admission_date' => $row['admission_date'],
                'year_id' => $row['year_id'],
                'user_type' => $data->user_type,
                'coaching_id' => $row['coaching_id'],
                'status' => $row['status'],
                'coaching_name' => $row['coaching_name'],
                'class_id' => $row['class_id'],
            ));
        }

        echo json_encode($response);
    }
}
