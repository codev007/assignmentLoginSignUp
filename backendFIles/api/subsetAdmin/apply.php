<?php
require_once '../operationDB/adminOperations.php';
require_once '../subsetAdmin/write.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $coaching_id = $data->coaching_id;
    $coaching_name = $data->coaching_name;
    $tagline = $data->tagline;
    $address = $data->address;
    $email = $data->email;
    $contact = $data->contact;
    $coaching_description = $data->coaching_description;
    $registration_no = $data->registration_no;
    $establishmentat = $data->establishmentat;
    $location_id = $data->location_id;

    if (
        !empty($coaching_id) && !empty($coaching_name) && !empty($tagline) && !empty($address)
        && !empty($email) && !empty($contact) && !empty($coaching_description) && !empty($registration_no)
        && !empty($establishmentat) && !empty($location_id)
    ) {
        $db = new adminoperations();
        $postRequest = $db->applyCoaching(
            $coaching_id,
            $coaching_name,
            $tagline,
            $address,
            $email,
            $contact,
            $coaching_description,
            $registration_no,
            $establishmentat,
            $location_id
        );

        if ($postRequest) {
            $response['error'] = false;
            $response['message'] = "Your request has been sent to subset . We will contact you soon";
        } else {
            $response['error'] = true;
            $response['message'] = "Problem occurs ! Please wait";
        }
    }
}
echo json_encode($response);

