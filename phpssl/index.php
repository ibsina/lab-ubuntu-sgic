<!DOCTYPE html>
<html>
<head>
    <title>Demo Website</title>
    <style>
        h1 {
            font-size: 48px; /* Adjust the font size as needed */
        }
        .demo {
            font-weight: bold;
            color: #00008B; /* Dark blue color */
        }
        .info {
            font-size: 24px; /* Adjust the font size as needed */
            font-weight: bold;
            color: #8B0000; /* Dark red color */
        }
    </style>
</head>
<body>
    <h1>This is <span class="demo">DEMO</span> website</h1>

    <?php
    // Get server's IP address
    $server_ip = $_SERVER['SERVER_ADDR'];

    // Get client IP address
    $client_ip = $_SERVER['REMOTE_ADDR'];

    // Get X-Forwarded-For header if present
    $x_forwarded_for = !empty($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : 'Not available';
    ?>

    <p>Server IP Address: <span class="info"><?php echo $server_ip; ?></span></p>
    <p>Client IP Address: <span class="info"><?php echo $client_ip; ?></span></p>
    <p>X-Forwarded-For Header: <span class="info"><?php echo $x_forwarded_for; ?></span></p>
</body>
</html>

