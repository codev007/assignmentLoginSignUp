<?php
include_once("core.php");

$con = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
if (mysqli_connect_errno()) {
	echo "Failed to connect with database" . mysqli_connect_error();
} else {
	echo "Database is connected.";
}
?>
<html>
	<body>
	Database is connected.
	</body>
	</html>
