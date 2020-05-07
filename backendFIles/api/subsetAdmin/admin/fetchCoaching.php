<?php
require_once '../../operationDB/adminOperations.php';
require_once '../../subsetAdmin/write.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $db = new adminoperations();
    $getData = $db->getCoachingRequests();
    echo json_encode($getData);
}

