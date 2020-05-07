<?php
date_default_timezone_set("Asia/Kolkata");

class usersOperation
{
    public $con;

    function __construct()
    {
        require_once dirname(__FILE__) . '/../config/database.php';
        $db = new DbConnect();
        $this->con = $db->connect();
    }
    public function updateStudentProfile($parent_subject, $date_of_birth, $school_experience, $user_id)
    {
        $stmt = $this->con->prepare("UPDATE `student_table` SET `birth`=?,`school_name`=?,`parents_mobile`=? WHERE user_id=?;");
        $stmt->bind_param("ssss", $date_of_birth, $school_experience, $parent_subject, $user_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function updateTeacherProfile($parent_subject, $date_of_birth, $school_experience, $user_id)
    {
        $stmt = $this->con->prepare("UPDATE `teacher_table` SET `birth`=? ,`subjects`= ?,`experience`= ? WHERE user_id=? ;");
        $stmt->bind_param("ssss", $date_of_birth, $parent_subject, $school_experience, $user_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    //----------------CODE VERSION 1.3.0 --------------------------
    public function deleteComment($comment_id, $user_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `comments_table` WHERE `comment_id` = ? AND `user_id` = ? ;");
        $stmt->bind_param("ss", $comment_id, $user_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function updateAnswer($answer, $answer_id)
    {
        $stmt = $this->con->prepare("UPDATE `answer_table` SET `answer`= ? WHERE answer_id = ?;");
        $stmt->bind_param("ss", $answer, $answer_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function updateComment($comment, $comment_id)
    {
        $stmt = $this->con->prepare("UPDATE `comments_table` SET `comment`= ? WHERE comment_id = ?;");
        $stmt->bind_param("ss", $comment, $comment_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    //-------------EXIT 1.3.0--------------------------------------
    public function updateToken($userID, $type, $token)
    {
        if ($type == 'S') {
            return $this->updateStudent($userID, $token);
        } elseif ($type == 'T') {
            return $this->updateTeacher($userID, $token);
        }
    }
    private function updateStudent($userID, $token)
    {
        $stmt = $this->con->prepare("UPDATE `student_table` SET `token`=? WHERE user_id=?;");
        $stmt->bind_param("ss", $token, $userID);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    private function updateTeacher($userID, $token)
    {
        $stmt = $this->con->prepare("UPDATE `teacher_table` SET `token`=? WHERE user_id=?;");
        $stmt->bind_param("ss", $token, $userID);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function getCoachingComments($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT coaching_comments.comment , 
        coaching_comments.created_at , student_table.username,student_table.image,
        coaching_comments.coaching_comments_id 
        FROM coaching_comments 
        INNER JOIN student_table 
        ON coaching_comments.user_id=student_table.user_id 
        WHERE coaching_comments.coaching_id=?
        UNION ALL
        SELECT coaching_comments.comment , coaching_comments.created_at , 
        teacher_table.username,teacher_table.image,
        coaching_comments.coaching_comments_id 
        FROM coaching_comments 
        INNER JOIN teacher_table 
        ON coaching_comments.user_id=teacher_table.user_id 
        WHERE coaching_comments.coaching_id=?");

        $stmt->bind_param("ss", $coaching_id, $coaching_id);
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

    public function addCoachingComments($user_id, $coaching_id, $comment)
    {
        $created_at = date('M d Y H:i');
        $stmt = $this->con->prepare("INSERT INTO `coaching_comments`( `user_id`, `coaching_id`, `comment`, `created_at`) VALUES (?,?,?,?);");
        $stmt->bind_param("ssss", $user_id, $coaching_id, $comment, $created_at);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function addAnswer($answer_id, $answer, $user_id, $question_id, $files)
    {
        $created_at = date('Y/m/d H:i:s');
        $stmt = $this->con->prepare("INSERT INTO `answer_table`(`answer_id`, `answer`, `user_id`, `created_at`, `question_id`) VALUES (?,?,?,?,?);");
        $stmt->bind_param("sssss", $answer_id, $answer, $user_id, $created_at, $question_id);
        if ($stmt->execute()) {
            if (!$files) {
                return true;
            } else {
                return $this->addAnswerImages($files, $answer_id);
            }
        } else {
            return false;
        }
    }
    private function addAnswerImages($files, $answer_id)
    {
        $arrlength = count($files);
        if ($arrlength != 0) {
            for ($x = 0; $x < $arrlength; $x++) {
                $mainFile = base64_decode($files[$x]);
                $folder = "../../images/answer/";
                $date = date("Ymdhms");
                $rand = rand(0, 999);
                $nameimage = "QIMG" . $date . $rand . ".png";
                $path = $folder . $nameimage;
                $stmt = $this->con->prepare("INSERT INTO `answer_image_table`(`answer_id`, `url`) VALUES (?,?);");
                $stmt->bind_param("ss", $answer_id, $nameimage);
                $stmt->execute();
                file_put_contents($path, $mainFile);
            }
        }
        return true;
    }

    public function addQuestion($question_id, $question, $user_id, $subject_id, $files, $class_id)
    {
        $created_at = date('Y/m/d H:i:s');
        $stmt = $this->con->prepare("INSERT INTO `question_table`(`question_id`, `question`, `user_id`, `created_at`, `subject_id`,`class_id`) VALUES (?,?,?,?,?,?);");
        $stmt->bind_param("ssssss", $question_id, $question, $user_id, $created_at, $subject_id, $class_id);

        if ($stmt->execute()) {
            if (count($files) > 0) {
                return $this->addQuestionImages($files, $question_id);
            } else {
                return true;
            }
        } else {
            return false;
        }
    }
    private function addQuestionImages($files, $question_id)
    {
        $arrlength = count($files);
        if ($arrlength != 0) {
            for ($x = 0; $x < $arrlength; $x++) {
                $mainFile = base64_decode($files[$x]);
                $folder = "../../images/questions/";
                $date = date("Ymdhms");
                $rand = rand(0, 999);
                $nameimage = "QIMG" . $date . $rand . ".png";
                $path = $folder . $nameimage;
                $stmt = $this->con->prepare("INSERT INTO `question_image`(`question_id`, `url`) VALUES (?,?);");
                $stmt->bind_param("ss", $question_id, $nameimage);
                $stmt->execute();
                file_put_contents($path, $mainFile);
            }
        }
        return true;
    }
    public function addComments($comment, $notice_id, $user_id)
    {
        $created_at = date('M d H:i');
        $stmt = $this->con->prepare("INSERT INTO `comments_table`( `comment`, `notice_id`, `user_id`, `created_at`) VALUES (?,?,?,?);");
        $stmt->bind_param("ssss",  $comment, $notice_id, $user_id, $created_at);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function addNotice($notice_id, $title, $description, $user_uid, $batch_id, $type, $file, $fileType)
    {
        $created_at = date('Y/m/d H:i:s');
        $stmt = $this->con->prepare("INSERT INTO `notice_table`(`notice_id`, `title`, `description`, `created_at`, `user_uid`, `batch_id`, `type`) VALUES (?,?,?,?,?,?,?);");
        $stmt->bind_param("sssssss", $notice_id, $title, $description, $created_at, $user_uid, $batch_id, $type);

        if ($stmt->execute()) {
            if (!empty($file)) {
                return $this->addNoticeImages($file, $notice_id, $fileType);
            } else {
                return true;
            }
        } else {
            return false;
        }
    }
    private function addNoticeImages($files, $notice_id, $fileType)
    {
        if ($fileType == "F") {
            $arrlength = count($files);
            if ($arrlength != 0) {
                for ($x = 0; $x < $arrlength; $x++) {
                    $mainFile = base64_decode($files[$x]);
                    $f = finfo_open();
                    $type = finfo_buffer($f, $mainFile, FILEINFO_MIME_TYPE);
                    $folder = "../../images/notice/";
                    $date = date("Ymdhms");
                    $rand = rand(0, 999);
                    $nameimage = "NFILES" . $date . $rand . ".png";
                    $path = $folder . $nameimage;
                    $this->uploadFiles($notice_id, $nameimage, $type);
                    file_put_contents($path, $mainFile);
                }
            }
        } else if ($fileType == "L") {
            $this->uploadFiles($notice_id, $files, $fileType);
        }

        return true;
    }
    private function uploadFiles($notice_id, $nameimage, $type)
    {
        $stmt = $this->con->prepare("INSERT INTO `notice_files`( `notice_id`, `url`, `type`) VALUES (?,?,?);");
        $stmt->bind_param("sss", $notice_id, $nameimage, $type);
        $stmt->execute();
    }
    public function alreadyRequested($user_type, $coaching_id, $year_id, $user_id)
    {
        $stmt = $this->con->prepare("SELECT  `user_id` FROM `coaching_user_connection_table` WHERE user_id=? AND year_id=? AND user_type=? AND coaching_id=?;");
        $stmt->bind_param("ssss", $user_id, $year_id, $user_type, $coaching_id);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
    public function studentProfile($user_id)
    {
        $stmt = $this->con->prepare("SELECT `user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_name`, `image`, `school_name`, `parents_mobile`, `token` FROM `student_table` WHERE user_id=? ;");
        $stmt->bind_param("s", $user_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function teacherProfile($user_id)
    {
        $stmt = $this->con->prepare("SELECT `user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_husband`, `image`, `subjects`, `experience`, `token` FROM `teacher_table` WHERE user_id=? ;");
        $stmt->bind_param("s", $user_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
    public function admissionRequest($user_uid, $user_id, $batch_id, $admission_date, $year_id, $user_type, $coaching_id, $status)
    {

        $stmt = $this->con->prepare("INSERT INTO `coaching_user_connection_table`(`user_uid`, `user_id`, `batch_id`, `admission_date`, `year_id`, `user_type`, `coaching_id`, `status`) VALUES (?,?,?,?,?,?,?,?);");
        $stmt->bind_param("ssssssss", $user_uid, $user_id, $batch_id, $admission_date, $year_id, $user_type, $coaching_id, $status);
        if ($stmt->execute()) {
            return true;
        }
        return false;
    }
    public function isUserProfileExist($mobile, $userType)
    {
        if ($userType == "S") {

            $stmt = $this->con->prepare("SELECT `user_id` FROM `student_table` WHERE `mobile`= ? ;");
            $stmt->bind_param("s", $mobile);
            $stmt->execute();
            $stmt->store_result();
            return $stmt->num_rows > 0;
        } else if ($userType == "T") {

            $stmt = $this->con->prepare("SELECT `user_id` FROM `teacher_table` WHERE `mobile`= ? ;");
            $stmt->bind_param("s", $mobile);
            $stmt->execute();
            $stmt->store_result();
            return $stmt->num_rows > 0;
        }
    }

    public function fetchStudentID($mobile)
    {
        $stmt = $this->con->prepare("SELECT `user_id` FROM `student_table` WHERE `mobile`= ? ;");
        $stmt->bind_param("s", $mobile);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function fetchTeacherID($mobile)
    {
        $stmt = $this->con->prepare("SELECT `user_id` FROM `teacher_table` WHERE `mobile`=?;");
        $stmt->bind_param("s", $mobile);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function profile_push_student($user_id, $username, $mobile, $address, $birth, $gender, $father_name, $image, $school_name, $parents_mobile, $token)
    {
        $folder = "../images/profile/";
        $date = date("Ymdhms");
        $rand = rand(0, 999);
        $nameimage = "user" . $date . $rand . ".png";
        $path = $folder . $nameimage;
        $stmt = $this->con->prepare("INSERT INTO `student_table`(`user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_name`, `image`, `school_name`, `parents_mobile`, `token`) VALUES (?,?,?,?,?,?,?,?,?,?,?);");
        $stmt->bind_param("sssssssssss", $user_id, $username, $mobile, $address, $birth, $gender, $father_name, $nameimage, $school_name, $parents_mobile, $token);
        file_put_contents($path, base64_decode($image));
        if ($stmt->execute()) {
            return true;
        }
        return false;
    }
    public function profile_push_teacher($user_id, $username, $mobile, $address, $birth, $gender, $father_husband, $image, $subjects, $experience, $token)
    {
        $folder = "../images/profile/";
        $date = date("Ymdhms");
        $rand = rand(0, 999);
        $nameimage = "user" . $date . $rand . ".png";
        $path = $folder . $nameimage;

        $stmt = $this->con->prepare("INSERT INTO `teacher_table`(`user_id`, `username`, `mobile`, `address`, `birth`, `gender`, `father_husband`, `image`, `subjects`, `experience`, `token`) VALUES (?,?,?,?,?,?,?,?,?,?,?);");
        $stmt->bind_param("sssssssssss", $user_id, $username, $mobile, $address, $birth, $gender, $father_husband, $nameimage, $subjects, $experience, $token);
        file_put_contents($path, base64_decode($image));
        if ($stmt->execute()) {
            return true;
        }
        return false;
    }
}
