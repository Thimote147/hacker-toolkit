<?php
// Secured file upload with random filenames
$extension = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
$random_name = bin2hex(random_bytes(16)); // 32 hexadecimal characters
$new_filename = $random_name . '.' . $extension;

// Store the mapping in the database
// original_name => random_name
?>
