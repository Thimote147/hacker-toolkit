<?php
// SECURIZED CODE

function validateImageUpload($file) {
    $allowed_extensions = ['jpg', 'jpeg', 'png', 'gif'];
    $allowed_mime_types = ['image/jpeg', 'image/png', 'image/gif'];
    $max_size = 5 * 1024 * 1024; // 5 MB
    
    // 1. Verify with file size
    if ($file['size'] > $max_size) {
        return ['success' => false, 'error' => 'File too large'];
    }
    
    // 2. Verify the extension (using pathinfo, not basename)
    $file_info = pathinfo($file['name']);
    $extension = strtolower($file_info['extension']);
    
    if (!in_array($extension, $allowed_extensions)) {
        return ['success' => false, 'error' => 'Invalid file extension'];
    }
    
    // 3. Verify the real MIME type (not just HTTP headers)
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mime_type = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);
    
    if (!in_array($mime_type, $allowed_mime_types)) {
        return ['success' => false, 'error' => 'Invalid file type'];
    }
    
    // 4. Verify that it is a real image (reprocessing)
    $image_check = getimagesize($file['tmp_name']);
    if ($image_check === false) {
        return ['success' => false, 'error' => 'Not a valid image'];
    }
    
    // 5. Reprocess the image to remove any malicious code
    list($width, $height, $type) = $image_check;
    
    switch ($type) {
        case IMAGETYPE_JPEG:
            $image = imagecreatefromjpeg($file['tmp_name']);
            break;
        case IMAGETYPE_PNG:
            $image = imagecreatefrompng($file['tmp_name']);
            break;
        case IMAGETYPE_GIF:
            $image = imagecreatefromgif($file['tmp_name']);
            break;
        default:
            return ['success' => false, 'error' => 'Unsupported image type'];
    }
    
    if ($image === false) {
        return ['success' => false, 'error' => 'Failed to process image'];
    }
    
    return ['success' => true, 'image_resource' => $image, 'type' => $type];
}

// Utilization
if ($_FILES['image']) {
    $result = validateImageUpload($_FILES['image']);
    
    if ($result['success']) {
        // Generate a random and secure filename
        $new_filename = bin2hex(random_bytes(16)) . '.jpg';
        $target_path = '/var/www/uploads/' . $new_filename;
        
        // Save the reprocessed image (removes any PHP code)
        imagejpeg($result['image_resource'], $target_path, 90);
        imagedestroy($result['image_resource']);
        
        echo "Upload successful: " . $new_filename;
    } else {
        echo "Upload failed: " . $result['error'];
    }
}
?>
