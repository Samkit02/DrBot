<?php
ini_set('display_errors', 1);
try{
include('config.php');
    $currentDirectory = getcwd();
    $uploadDirectory = "/images/";

    $errors = []; // Store errors here

    $fileExtensionsAllowed = ['jpeg','jpg','PNG','png']; // These will be the only file extensions allowed 
   
    $fileName = $_FILES['fimage']['name'];

    $fileSize = $_FILES['fimage']['size'];
    $fileTmpName  = $_FILES['fimage']['tmp_name'];
    $fileType = $_FILES['fimage']['type'];
    $fileExtension = strtolower(end(explode('.',$fileName)));
    $uploadPath = $currentDirectory . $uploadDirectory . basename($fileName); 

$conn = new mysqli($servername, $username, $password, $dbname);
//echo $fileName ;
$sql = "INSERT INTO disease (pic, disease) VALUES ('$fileName' , '1')";
$result_json = array('Result' => 'OK', 'Message' => 'New record created successfully');

    //if (isset($_POST['submit'])) {

      if (! in_array($fileExtension,$fileExtensionsAllowed)) {
        $errors[] = "This file extension is not allowed. Please upload a JPEG or PNG file";
      }

      if ($fileSize > 10000000) {
        $errors[] = "File exceeds maximum size (10 MB)";
      }
      
      if (empty($errors)) {
        $didUpload = move_uploaded_file($fileTmpName, $uploadPath);

        if ($didUpload) {
          //echo "The file " . basename($fileName) . " has been uploaded";
          if ($conn->query($sql) === TRUE) {
            echo json_encode($result_json);
            //echo "New record created successfully";
          } else {
			  echo json_encode(array('Result' => 'ERR', 'Message' =>  "Error: " . $sql . "<br>" . $conn->error));
              //echo "Error: " . $sql . "<br>" . $conn->error;
          }
        } else {
			echo json_encode(array('Result' => 'ERR', 'Message' =>  "An error occurred. Please contact the administrator."));
          //echo "An error occurred. Please contact the administrator.";
        }
      } else {
        foreach ($errors as $error) {
			echo json_encode(array('Result' => 'ERR', 'Message' =>  $error));
          //echo $error . "These are the errors" . "\n";
        }
      }

    //}
 //header('Location: manage-users.php');
}catch(Exception $e){
	echo json_encode(array('Result' => 'ERR', 'Message' =>  'Message: ' .$e->getMessage()));
	//echo 'Message: ' .$e->getMessage();
 }
?>