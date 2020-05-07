<?php
date_default_timezone_set("Asia/Kolkata");

class subsetsOperation
{
    public $con;

    function __construct()
    {
        require_once dirname(__FILE__) . '/../config/database.php';
        $db = new DbConnect();
        $this->con = $db->connect();
    }
    public function addResultNew( $user_uid, $test_id, $subject_id, $batch_id, $marks,$total){
        $arrlength = count($user_uid);
        if ($arrlength != 0) {
            for ($x = 0; $x < $arrlength; $x++) {
                $stmt = $this->con->prepare("INSERT INTO `result_table`( `user_uid`, `test_id`, `subject_id`, `batch_id`, `marks`,`total`) VALUES (?,?,?,?,?,?);");
                $stmt->bind_param("ssssss", $user_uid[$x], $test_id, $subject_id, $batch_id, $marks[$x],$total);
                $stmt->execute();
            }
        }
        return true;
    }
    public function fetchNotes($coaching_id, $class_id, $subject_id)
    {
        $hide = '0';
        $stmt = $this->con->prepare("SELECT `notes_id`, `title`, `pdf_url`, `created_at` FROM `notes_table` WHERE coaching_id = ? AND class_id = ? AND subject_id = ? AND hide = ?");

        $stmt->bind_param("ssss", $coaching_id, $class_id, $subject_id, $hide);

        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function uploadNotes($coaching_id, $class_id, $subject_id, $title, $file)
    {
        $folder = "../images/notes/";
        $date = date("Ymdhms");
        $rand = rand(0, 999);
        $nameimage = "files" . $date . $rand . ".pdf";
        $path = $folder . $nameimage;

        $created = date("Y/m/d H:i:s");
        $hide = "0";
        $stmt = $this->con->prepare("INSERT INTO `notes_table`(`coaching_id`, `class_id`, `subject_id`, `title`, `pdf_url`, `created_at`, `hide`) VALUES (?,?,?,?,?,?,?);");
        $stmt->bind_param("sssssss", $coaching_id, $class_id, $subject_id, $title, $nameimage, $created, $hide);
        file_put_contents($path, base64_decode($file));
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function getChildrenList($mobileNumber)
    {
        $stmt = $this->con->prepare("SELECT `user_id`, `username`,`birth`, `image` FROM `student_table` WHERE parents_mobile=?");

        $stmt->bind_param("s", $mobileNumber);

        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function updateToNewBatch($coachingID, $year_id, $batch_id_new, $batch_id_old)
    {
        $userType = 'S';
        $stmt = $this->con->prepare("UPDATE `coaching_user_connection_table` 
        SET `batch_id`= ? WHERE coaching_id=? AND year_id=? AND user_type=? AND batch_id=?");
        $stmt->bind_param("sssss", $batch_id_new, $coachingID, $year_id, $userType, $batch_id_old);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function time_Ago($time)
    {

        // Calculate difference between current 
        // time and given timestamp in seconds 
        $diff  = time() - $time;

        // Time difference in seconds 
        $sec     = $diff;

        // Convert time difference in minutes 
        $min     = round($diff / 60);

        // Convert time difference in hours 
        $hrs     = round($diff / 3600);

        // Convert time difference in days 
        $days     = round($diff / 86400);

        // Convert time difference in weeks 
        $weeks     = round($diff / 604800);

        // Convert time difference in months 
        $mnths     = round($diff / 2600640);

        // Convert time difference in years 
        $yrs     = round($diff / 31207680);

        // Check for seconds 
        if ($sec <= 60) {
            return "$sec seconds ago";
        }

        // Check for minutes 
        else if ($min <= 60) {
            if ($min == 1) {
                return "one minute ago";
            } else {
                return "$min minutes ago";
            }
        }

        // Check for hours 
        else if ($hrs <= 24) {
            if ($hrs == 1) {
                return "an hour ago";
            } else {
                return "$hrs hours ago";
            }
        }

        // Check for days 
        else if ($days <= 7) {
            if ($days == 1) {
                return "Yesterday";
            } else {
                return "$days days ago";
            }
        }

        // Check for weeks 
        else if ($weeks <= 4.3) {
            if ($weeks == 1) {
                return "a week ago";
            } else {
                return "$weeks weeks ago";
            }
        }

        // Check for months 
        else if ($mnths <= 12) {
            if ($mnths == 1) {
                return "a month ago";
            } else {
                return "$mnths months ago";
            }
        }

        // Check for years 
        else {
            if ($yrs == 1) {
                return "one year ago";
            } else {
                return "$yrs years ago";
            }
        }
    }
    //------------------VERSION 1.3.0 CODE-----------------------------------------
    public function deleteBatch($batch_id, $coaching_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `batch_table` WHERE batch_id=? AND coaching_id=?");
        $stmt->bind_param("ss", $batch_id, $coaching_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function updateBatch($batch_id, $batch_name, $coaching_id, $class_id)
    {
        $created = date("d M Y");
        $stmt = $this->con->prepare("UPDATE `batch_table` SET `batch_name`=?,`class_id`=?,`created_at`=? WHERE batch_id=? AND coaching_id=?");
        $stmt->bind_param("sssss", $batch_name, $class_id, $created, $batch_id, $coaching_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    //--------------------VERSION 1.1.0 CODE----------------------------------------
    public function getAdmissionCount($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT `registration_no` as total,
        (SELECT COUNT(*) FROM coaching_user_connection_table WHERE coaching_user_connection_table.coaching_id = coaching_table.coaching_id AND year_id =coaching_table.year_id) as admitted FROM `coaching_table` WHERE coaching_table.coaching_id=?;");
        $stmt->bind_param("s", $coaching_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getCoachingList($location)
    {
        $stmt = $this->con->prepare("SELECT `coaching_id`, `coaching_name`, `tagline`, `address`, 
        `coaching_description`, `registration_no`, `logo`, `image`,`year_id` 
        FROM `coaching_table` 
        WHERE is_active='1' 
        AND location_id=?");

        $stmt->bind_param("s", $location);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $count = $this->admissionCount($row['coaching_id'], $row['year_id']);
                if ($count['no'] < $row['registration_no'] + 1) {
                    $cbg[] = $row;
                }
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    private function admissionCount($coaching_id, $year_id)
    {
        $stmt = $this->con->prepare("SELECT COUNT(*) as no FROM coaching_user_connection_table WHERE coaching_user_connection_table.coaching_id = ? AND year_id =?");
        $stmt->bind_param("ss", $coaching_id, $year_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function createDistrict($dist_name, $state_id)
    {
        $stmt = $this->con->prepare("INSERT INTO `districts`(`dist_name`, `state_id`) VALUES (?,?)");
        $stmt->bind_param("ss", $dist_name, $state_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function createArea($area_name, $dist_id)
    {
        $stmt = $this->con->prepare("INSERT INTO `areas`( `area_name`, `dist_id`) VALUES (?,?)");
        $stmt->bind_param("ss", $area_name, $dist_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function getStates()
    {
        $stmt = $this->con->prepare("SELECT `state_id`, `state_name` FROM `states` WHERE 1");

        //     $stmt->bind_param("s", $user_uid);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getDistricts($state_id)
    {
        $stmt = $this->con->prepare("SELECT `dist_id`, `dist_name` FROM `districts` WHERE `state_id`=?");

        $stmt->bind_param("s", $state_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getArea($dist_id)
    {
        $stmt = $this->con->prepare("SELECT `area_id`, `area_name` FROM `areas` WHERE `dist_id`=?");

        $stmt->bind_param("s", $dist_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }

    public function getResultUserData($user_uid)
    {
        $stmt = $this->con->prepare("SELECT student_table.username,student_table.image 
        FROM result_table 
        INNER JOIN coaching_user_connection_table 
        ON result_table.user_uid=coaching_user_connection_table.user_uid 
        INNER JOIN student_table ON coaching_user_connection_table.user_id=student_table.user_id 
        WHERE result_table.user_uid=?;");
        $stmt->bind_param("s", $user_uid);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getTestData($test_id)
    {
        $stmt = $this->con->prepare("SELECT  `test_name`,`created_at` FROM `test_list_table` WHERE test_id=?;");
        $stmt->bind_param("s", $test_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getResult($test_id, $user_uid)
    {
        $stmt = $this->con->prepare("SELECT result_table.total,result_table.marks,subject_table.subject_name 
        FROM result_table 
        INNER JOIN subject_table 
        ON result_table.subject_id=subject_table.subject_id 
        WHERE result_table.user_uid=? 
        AND result_table.test_id=?");

        $stmt->bind_param("ss", $user_uid, $test_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }


    public function getAttendance($user_uid)
    {
        $stmt = $this->con->prepare("SELECT `date`, `value` FROM `attendance_table` WHERE user_uid = ?");

        $stmt->bind_param("s", $user_uid);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getTestList($batch_id, $year_id)
    {
        $stmt = $this->con->prepare("SELECT `test_id`,`test_name`,`created_at` FROM `test_list_table` WHERE batch_id = ? AND year_id = ?");

        $stmt->bind_param("ss", $batch_id, $year_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }

    public function getSubjects($class_id)
    {
        $stmt = $this->con->prepare("SELECT `subject_id`, `subject_name` FROM `subject_table` WHERE class_id = ?");

        $stmt->bind_param("s", $class_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function LikeNotice($notice_id, $user_id, $value)
    {
        if ($this->isNoticeLikeExist($notice_id, $user_id)) {
            if ($this->isNoticeLikeSame($notice_id, $user_id, $value)) {
                return $this->deleteNoticeLike($notice_id, $user_id);
            } else {
                return $this->updateNoticeLike($notice_id, $user_id, $value);
            }
        } else {
            return $this->addNoticeLike($notice_id, $user_id, $value);
        }
    }
    private function updateNoticeLike($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("UPDATE `notice_likes` SET `value`=? WHERE user_id=? AND notice_id=?");
        $stmt->bind_param("sss", $value, $user_id, $notice_id);
        $stmt->execute();
        return true;
    }

    private function deleteNoticeLike($notice_id, $user_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `notice_likes` WHERE notice_id = ? AND user_id = ?");
        $stmt->bind_param("ss", $notice_id, $user_id);
        $stmt->execute();
        return true;
    }
    private function addNoticeLike($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("INSERT INTO `notice_likes`(`notice_id`, `user_id`, `value`) VALUES (?,?,?)");
        $stmt->bind_param("sss", $notice_id, $user_id, $value);
        $stmt->execute();
        return true;
    }
    private function isNoticeLikeSame($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("SELECT `notice_like_id` FROM `notice_likes` WHERE `user_id` = ? AND `notice_id` = ? AND `value` = ? ");
        $stmt->bind_param("sss", $user_id, $notice_id, $value);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
    private function isNoticeLikeExist($notice_id, $user_id)
    {
        $stmt = $this->con->prepare("SELECT `notice_like_id` FROM `notice_likes` WHERE `user_id` = ? AND `notice_id` = ? ");
        $stmt->bind_param("ss", $user_id, $notice_id);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    public function getLike($userUid, $notice_id)
    {
        $stmt = $this->con->prepare("SELECT `value` FROM `notice_likes` WHERE user_uid=? AND notice_id=?;");
        $stmt->bind_param("ss", $userUid, $notice_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function StudentListAttendance($batch_id, $year_id)
    {
        $stmt = $this->con->prepare("SELECT student_table.username,coaching_user_connection_table.user_uid,
        student_table.father_name 
        FROM coaching_user_connection_table 
        INNER JOIN student_table 
        ON student_table.user_id=coaching_user_connection_table.user_id 
        WHERE coaching_user_connection_table.batch_id = ? 
        AND coaching_user_connection_table.year_id = ? 
        AND coaching_user_connection_table.status = 1 
        AND coaching_user_connection_table.user_type = 'S';");

        $stmt->bind_param("ss", $batch_id, $year_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $row['value'] = 'A';
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getAttendanceBatchList($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT batch_table.batch_id,batch_table.batch_name,
        classes_table.class_name,batch_table.class_id 
        FROM batch_table 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE batch_table.coaching_id=?;");

        $stmt->bind_param("s", $coaching_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getQuesFiles($questoin_id)
    {
        $stmt = $this->con->prepare("SELECT `url` FROM `question_image` WHERE question_id = ? ;");
        $stmt->bind_param("s", $questoin_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getAnswerFiles($id)
    {
        $stmt = $this->con->prepare("SELECT `url` FROM `answer_image_table` WHERE answer_id=? ;");
        $stmt->bind_param("s", $id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function getQuesInfo($questoin_id)
    {
        $stmt = $this->con->prepare("SELECT question_table.question,question_table.created_at,
        student_table.username,student_table.image,student_table.token,classes_table.class_name,subject_table.subject_name 
        FROM question_table 
        INNER JOIN student_table 
        ON question_table.user_id=student_table.user_id 
        INNER JOIN classes_table 
        ON question_table.class_id=classes_table.class_id 
        INNER JOIN subject_table 
        ON question_table.subject_id=subject_table.subject_id 
        WHERE question_table.question_id= ? ;");

        $stmt->bind_param("s", $questoin_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getQuesLikeInfo($question_id, $user_id)
    {

        $stmt = $this->con->prepare("SELECT  `value` FROM `question_like` WHERE question_id = ? AND user_id =?;");
        $stmt->bind_param("ss", $question_id, $user_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getNoticeLikeInfo($notice_id, $user_id)
    {

        $stmt = $this->con->prepare("SELECT `value` FROM `notice_likes` WHERE notice_id=? AND user_id=?;");
        $stmt->bind_param("ss", $notice_id, $user_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function getNoticeInfo($notice_id)
    {
        $stmt = $this->con->prepare("SELECT notice_table.title,notice_table.description,
        notice_table.created_at,batch_table.batch_name,teacher_table.username,teacher_table.image,teacher_table.token,notice_table.type
        FROM notice_table 
        INNER JOIN batch_table 
        ON notice_table.batch_id=batch_table.batch_id         
        INNER JOIN coaching_user_connection_table 
        ON notice_table.user_uid = coaching_user_connection_table.user_uid 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id
        WHERE notice_id = ? ;");

        $stmt->bind_param("s", $notice_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function getNoticeFiles($notice_id)
    {
        $stmt = $this->con->prepare("SELECT  `url`, `type` FROM `notice_files` WHERE notice_id= ? ;");
        $stmt->bind_param("s", $notice_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
    public function addResult($user_uid, $test_id, $subject_id, $batch_id, $marks)
    {
        $arrlength = count($user_uid);
        if ($arrlength != 0) {
            for ($x = 0; $x < $arrlength; $x++) {
                $stmt = $this->con->prepare("INSERT INTO `result_table`( `user_uid`, `test_id`, `subject_id`, `batch_id`, `marks`) VALUES (?,?,?,?,?);");
                $stmt->bind_param("sssss", $user_uid[$x], $test_id, $subject_id, $batch_id, $marks[$x]);
                $stmt->execute();
            }
        }
        return true;
    }

    public function AddAttendance($date, $user_id, $value)
    {
        $arrlength = count($user_id);
        if ($arrlength != 0) {
            for ($x = 0; $x < $arrlength; $x++) {
                $stmt = $this->con->prepare("INSERT INTO `attendance_table`( `user_uid`, `date`, `value`) VALUES (?,?,?);");
                $stmt->bind_param("sss", $user_id[$x], $date, $value[$x]);
                $stmt->execute();
            }
        }
        return true;
    }

    public function applyForRegistration(
        $id,
        $name,
        $email,
        $phone,
        $address,
        $description,
        $estd,
        $tagline,
        $registration
    ) {
        $created = date("d M Y");
        $expired = date("d M Y", strtotime('+1 year'));
        $stmt = $this->con->prepare("INSERT INTO `coaching_table`(`coaching_id`, `coaching_name`, `tagline`, `address`, `email`, `contact`, `coaching_description`, `registration_no`, `establishmentat`, `created_at`, `expired_at`) VALUES (?,?,?,?,?,?,?,?,?,?,?);");
        $stmt->bind_param("sssssssssss", $id, $name, $tagline, $address, $email, $phone, $description, $registration, $estd, $created, $expired);
        if ($stmt->execute()) {
            return 1;
        } else {
            return 2;
        }
    }
    public function createNewBatch($batchName, $coachingID, $classID)
    {
        if ($this->isBatchExist($batchName, $coachingID)) {
            return false;
        } else {
            return $this->insertBatch($batchName, $coachingID, $classID);
        }
    }

    private function isBatchExist($batchName, $coachingID)
    {
        $stmt = $this->con->prepare("SELECT batch_id FROM `batch_table` WHERE batch_table.batch_name=? AND batch_table.coaching_id=?");
        $stmt->bind_param("ss", $batchName, $coachingID);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    private function insertBatch($batchName, $coachingID, $classID)
    {
        $created = date("d M Y");
        $stmt = $this->con->prepare("INSERT INTO `batch_table`(`batch_name`, `coaching_id`, `created_at`,`class_id`) VALUES (?,?,?,?);");
        $stmt->bind_param("ssss", $batchName, $coachingID, $created, $classID);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function fetchBatches($coachingID)
    {
        $stmt = $this->con->prepare("SELECT `batch_id`, `batch_name` FROM `batch_table` WHERE batch_table.coaching_id = ? ;");
        $stmt->bind_param("s", $coachingID);
        $stmt->execute();
        return $stmt;
    }

    public function LikeQuestion($notice_id, $user_id, $value)
    {
        if ($this->isQuestionLikeExist($notice_id, $user_id)) {
            if ($this->isQuestionLikeSame($notice_id, $user_id, $value)) {
                return $this->deleteQuestionLike($notice_id, $user_id);
            } else {
                return $this->updateQuestionLike($notice_id, $user_id, $value);
            }
        } else {
            return $this->addQuestionLike($notice_id, $user_id, $value);
        }
    }
    private function updateQuestionLike($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("UPDATE `question_like` SET `value`=? WHERE `question_id`=? AND`user_id`=?");
        $stmt->bind_param("sss", $value, $notice_id, $user_id);
        $stmt->execute();
        return true;
    }

    private function deleteQuestionLike($notice_id, $user_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `question_like` WHERE question_id=? AND user_id=?");
        $stmt->bind_param("ss", $notice_id, $user_id);
        $stmt->execute();
        return true;
    }
    private function addQuestionLike($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("INSERT INTO `question_like`( `question_id`, `user_id`, `value`) VALUES (?,?,?)");
        $stmt->bind_param("sss", $notice_id, $user_id, $value);
        $stmt->execute();
        return true;
    }
    private function isQuestionLikeSame($notice_id, $user_id, $value)
    {
        $stmt = $this->con->prepare("SELECT `question_like_id` FROM `question_like` WHERE `user_id` = ? AND `question_id` = ? AND `value` = ?");
        $stmt->bind_param("sss", $user_id, $notice_id, $value);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
    private function isQuestionLikeExist($notice_id, $user_id)
    {
        $stmt = $this->con->prepare("SELECT `question_like_id` FROM `question_like` WHERE `user_id` = ? AND `question_id` = ? ");
        $stmt->bind_param("ss", $user_id, $notice_id);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    private function isAttendanceSubmitted($batch_id, $date)
    {
        $stmt = $this->con->prepare("SELECT `attendance_id` 
        FROM `attendance_table` 
        INNER JOIN coaching_user_connection_table 
        ON attendance_table.user_uid=coaching_user_connection_table.user_uid 
        WHERE coaching_user_connection_table.batch_id = ? 
        AND attendance_table.date=? 
        LIMIT 1");
        $stmt->bind_param("ss", $batch_id, $date);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    public function getAttendanceBatchListFetch($coaching_id, $date)
    {
        $stmt = $this->con->prepare("SELECT batch_table.batch_id,batch_table.batch_name,
        classes_table.class_name,batch_table.class_id 
        FROM batch_table 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE batch_table.coaching_id=?;");

        $stmt->bind_param("s", $coaching_id);
        if ($stmt->execute()) {
            $cbg = array();
            $result = $stmt->get_result();
            while ($row = $result->fetch_assoc()) {
                $row['value'] = $this->isAttendanceSubmitted($row['batch_id'], $date);
                $cbg[] = $row;
            }
            $stmt->close();
            return $cbg;
        } else {
            return NULL;
        }
    }
}
