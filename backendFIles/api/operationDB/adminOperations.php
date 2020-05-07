<?php
date_default_timezone_set("Asia/Kolkata");

class adminoperations
{
    public $con;

    function __construct()
    {
        require_once dirname(__FILE__) . '/../config/database.php';
        $db = new DbConnect();
        $this->con = $db->connect();
    }
    public function fetchClassWithID($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT DISTINCT classes_table.class_id,classes_table.class_name FROM `batch_table`
        INNER JOIN classes_table ON batch_table.class_id=classes_table.class_id WHERE batch_table.coaching_id = ? ;");
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
    //---------------VERSION CODE 1.3.0 -------------------------------
    public function deleteNotification($notification_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `notification_table` WHERE notification_id = ?;");
        $stmt->bind_param("s", $notification_id);
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    //----------------CLOSE CODE 1.3.0---------------------------------

    public function addTest($batch_id, $test_name, $year_id)
    {
        $created = date("Y/m/d H:i:s");
        $stmt = $this->con->prepare("INSERT INTO `test_list_table`(`test_name`, `batch_id`, `created_at`, `year_id`) VALUES (?,?,?,?);");
        $stmt->bind_param("ssss", $test_name, $batch_id, $created, $year_id);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function getCoachingRequests()
    {
        $stmt = $this->con->prepare("SELECT `coaching_id`, `coaching_name`, `tagline`, `address`,
        `email`, `contact`, `coaching_description`, `registration_no`, `achievements`, `establishmentat`,
        `created_at`, `expired_at`, `is_active`, `location_id`, `logo`, `image`, `year_id`
        FROM `coaching_table`
        WHERE 1");
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
    public function createSubject($class_id, $subject_name)
    {
        $stmt = $this->con->prepare("INSERT INTO `subject_table`(`subject_name`, `class_id`) VALUES (?,?);");
        $stmt->bind_param("ss", $subject_name, $class_id);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function createClass($class_name)
    {
        $stmt = $this->con->prepare("INSERT INTO `classes_table`(`class_name`) VALUES (?);");
        $stmt->bind_param("s", $class_name);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function updateImage($image, $coaching_id)
    {
        $folder = "../images/coaching_img/";
        $date = date("Ymdhms");
        $rand = rand(0, 999);
        $nameimage = "IMG" . $date . $rand . ".png";
        $path = $folder . $nameimage;

        $stmt = $this->con->prepare("UPDATE `coaching_table` SET `image`=? WHERE coaching_id=?");
        $stmt->bind_param("ss", $nameimage, $coaching_id);
        file_put_contents($path, base64_decode($image));

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function updateLogo($image, $coaching_id)
    {
        $folder = "../images/logo/";
        $date = date("Ymdhms");
        $rand = rand(0, 999);
        $nameimage = "IMG" . $date . $rand . ".png";
        $path = $folder . $nameimage;

        $stmt = $this->con->prepare("UPDATE `coaching_table` SET `logo`=? WHERE coaching_id=?");
        $stmt->bind_param("ss", $nameimage, $coaching_id);
        file_put_contents($path, base64_decode($image));

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    public function fetchClass()
    {
        $stmt = $this->con->prepare("SELECT `class_id`, `class_name` FROM `classes_table` WHERE 1");
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
    public function getTeacher($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT coaching_user_connection_table.admission_date,
        teacher_table.username,teacher_table.mobile,
        teacher_table.address,teacher_table.birth,teacher_table.gender,teacher_table.father_husband,
        teacher_table.image,teacher_table.subjects,teacher_table.experience,
        teacher_table.token,batch_table.batch_name,classes_table.class_name 
        FROM coaching_user_connection_table 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id 
        INNER JOIN batch_table 
        ON coaching_user_connection_table.batch_id=batch_table.batch_id 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE coaching_user_connection_table.coaching_id=?
        AND coaching_user_connection_table.user_type='T' 
        AND coaching_user_connection_table.status='1'");

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


    public function getStudent($coaching_id, $batchID)
    {

        $stmt = $this->con->prepare("SELECT student_table.user_id,student_table.username,student_table.mobile,student_table.address,student_table.birth,
        student_table.gender,student_table.father_name,student_table.image,student_table.school_name,student_table.parents_mobile,
        student_table.token,coaching_user_connection_table.user_uid,coaching_user_connection_table.admission_date,batch_table.batch_name,batch_table.batch_id,classes_table.class_name,classes_table.class_id FROM coaching_user_connection_table 
        INNER JOIN student_table 
        ON coaching_user_connection_table.user_id=student_table.user_id 
        INNER JOIN batch_table 
        ON coaching_user_connection_table.batch_id=batch_table.batch_id 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE coaching_user_connection_table.coaching_id=? 
        AND coaching_user_connection_table.status='1' 
        AND coaching_user_connection_table.user_type='S' 
        AND coaching_user_connection_table.batch_id=?");

        $stmt->bind_param("ss", $coaching_id, $batchID);
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
    public function getStaff($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT DISTINCT teacher_table.username,teacher_table.image,
        teacher_table.subjects,teacher_table.experience 
        FROM coaching_user_connection_table 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id 
        WHERE coaching_user_connection_table.coaching_id=? 
        AND coaching_user_connection_table.user_type='T' AND coaching_user_connection_table.status='1'");

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

    public function getCoachingDetails($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT * ,(SELECT COUNT(*) FROM coaching_user_connection_table
        WHERE year_id = coaching_table.year_id AND coaching_id= coaching_table.coaching_id AND user_type= 'S') AS scount ,
        (SELECT COUNT(*) FROM coaching_user_connection_table
        WHERE year_id = coaching_table.year_id AND coaching_id= coaching_table.coaching_id AND user_type= 'T') AS tcount
        FROM `coaching_table` 
        WHERE coaching_id = ? ;");
        $stmt->bind_param("s", $coaching_id);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    public function updateCoachingStatus($coaching_id, $value)
    {
        if ($value == 1) {

            $expired = date("d M Y", strtotime('+1 year'));
            $stmt = $this->con->prepare("UPDATE `coaching_table` SET `is_active`= ?,`expired_at`=? WHERE coaching_id=?");
            $stmt->bind_param("sss", $value, $expired, $coaching_id);

            if ($stmt->execute()) {
                return true;
            } else {
                return false;
            }
        } else if ($value == 0) {
            $stmt = $this->con->prepare("DELETE FROM `coaching_table` WHERE coaching_id=?");
            $stmt->bind_param("s", $coaching_id);

            if ($stmt->execute()) {
                return true;
            } else {
                return false;
            }
        }
    }
    public function updateAcievements($achievement, $coaching_id)
    {
        $stmt = $this->con->prepare("UPDATE `coaching_table` SET `achievements`=? WHERE coaching_id=?");
        $stmt->bind_param("ss", $achievement, $coaching_id);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function requestHandler($user_uid, $value)
    {
        if ($value == 1) {
            $stmt = $this->con->prepare("UPDATE `coaching_user_connection_table` SET `status`='1' WHERE user_uid=?");
            $stmt->bind_param("s", $user_uid);

            if ($stmt->execute()) {
                return true;
            } else {
                return false;
            }
        } else {
            $stmt = $this->con->prepare("DELETE FROM `coaching_user_connection_table` WHERE user_uid=?");
            $stmt->bind_param("s", $user_uid);

            if ($stmt->execute()) {
                return true;
            } else {
                return false;
            }
        }
    }
    public function getTeachersRequests($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT coaching_user_connection_table.user_uid,
        coaching_user_connection_table.user_id,coaching_user_connection_table.admission_date,
        batch_table.batch_name,classes_table.class_name,teacher_table.username,teacher_table.mobile,
        teacher_table.address,teacher_table.birth,teacher_table.gender,teacher_table.father_husband as fname,
        teacher_table.image,teacher_table.subjects as info,coaching_user_connection_table.user_type,
        teacher_table.token 
        FROM coaching_user_connection_table 
        INNER JOIN teacher_table 
        ON coaching_user_connection_table.user_id=teacher_table.user_id 
        INNER JOIN batch_table 
        ON coaching_user_connection_table.batch_id=batch_table.batch_id 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE coaching_user_connection_table.coaching_id=? 
        AND coaching_user_connection_table.status='0'");

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
    public function getStudentsRequests($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT coaching_user_connection_table.user_uid,
        coaching_user_connection_table.user_id,coaching_user_connection_table.admission_date,
        batch_table.batch_name,classes_table.class_name,student_table.username,student_table.mobile,
        student_table.address,student_table.birth,student_table.gender,student_table.father_name as fname,
        student_table.image,student_table.school_name as info,coaching_user_connection_table.user_type,
        student_table.token 
        FROM coaching_user_connection_table 
        INNER JOIN student_table 
        ON coaching_user_connection_table.user_id=student_table.user_id 
        INNER JOIN batch_table 
        ON coaching_user_connection_table.batch_id=batch_table.batch_id 
        INNER JOIN classes_table 
        ON batch_table.class_id=classes_table.class_id 
        WHERE coaching_user_connection_table.coaching_id=? 
        AND coaching_user_connection_table.status='0'");

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
    public function getNotification($coaching_id)
    {
        $stmt = $this->con->prepare("SELECT `notification_id`, `title`, `description`, `coaching_id`, 
        `created_at` 
        FROM `notification_table` 
        WHERE coaching_id = ? ORDER BY `notification_table`.`notification_id` DESC");

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

    public function addNotification($title, $description, $coaching_id, $year_id)
    {
        $created = date("Y/m/d H:i:s");
        $stmt = $this->con->prepare("INSERT INTO `notification_table`(`title`,
         `description`, `coaching_id`,`year_id`,`created_at`) 
         VALUES (?,?,?,?,?)");
        $stmt->bind_param("sssss", $title, $description, $coaching_id, $year_id, $created);

        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }
    //------------UPDATE VERSION ------------------------------
    public function applyCoaching(
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
    ) {
        $created = date("Y/m/d H:i:s");
        $year = date("Y");
        $stmt = $this->con->prepare("INSERT INTO `coaching_table`(`coaching_id`, `coaching_name`, `tagline`, `address`,
         `email`, `contact`, `coaching_description`, `registration_no`, `establishmentat`,
           `created_at`, `year_id`,`location_id`)
           VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
        $stmt->bind_param(
            "ssssssssssss",
            $coaching_id,
            $coaching_name,
            $tagline,
            $address,
            $email,
            $contact,
            $coaching_description,
            $registration_no,
            $establishmentat,
            $created,
            $year,
            $location_id
        );
        if ($stmt->execute()) {
            return true;
        } else {
            return false;
        }
    }

    public function isSubsetExist($mobile)
    {
        $stmt = $this->con->prepare("SELECT coaching_id FROM `coaching_table` WHERE coaching_table.contact=?");
        $stmt->bind_param("s", $mobile);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
    public function isPhoneNumberExistApplyData($mobile)
    {
        $stmt = $this->con->prepare("SELECT coaching_id FROM `coaching_table` WHERE coaching_table.contact=? ");
        $stmt->bind_param("s", $mobile);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }
    public function getCoaching($mobile)
    {
        $stmt = $this->con->prepare("SELECT `coaching_id`, `coaching_name`, `tagline`, `address`, `email`, 
        `contact`,`registration_no`,`establishmentat`, `created_at`, 
        `expired_at`, `is_active`, `location_id`, `logo`, `image`,`year_id` 
        FROM `coaching_table` 
        WHERE coaching_table.contact=?;");
        $stmt->bind_param("s", $mobile);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }
}
