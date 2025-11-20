# Install ClamAV
sudo apt-get install clamav clamav-daemon
sudo freshclam  # Update virus definitions

<?php
// Scan uploaded files
function scanFile($filepath) {
    $output = shell_exec("clamscan " . escapeshellarg($filepath));
    return (strpos($output, 'OK') !== false);
}
?>
