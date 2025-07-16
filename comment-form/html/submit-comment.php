<?php
// File to store comments
$commentsFile = 'comments.txt';

// Check if form is submitted and data is available
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $firstName = htmlspecialchars($_POST["firstname"]);
    $lastName = htmlspecialchars($_POST["lastname"]);
    $comment = htmlspecialchars($_POST["comment"]);

    // Append new comment to the file
    $entry = "$firstName $lastName|$comment\n";
    file_put_contents($commentsFile, $entry, FILE_APPEND);
}

// Read all comments from the file
$comments = [];
if (file_exists($commentsFile)) {
    $comments = file($commentsFile, FILE_IGNORE_NEW_LINES);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Comments</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f0f0f0;
        }

        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 50%;
            max-width: 600px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }

        th {
            background-color: #28a745;
            color: white;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>All Submitted Comments</h1>

    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Comment</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($comments)): ?>
                <?php foreach ($comments as $commentLine): ?>
                    <?php list($name, $commentText) = explode('|', $commentLine); ?>
                    <tr>
                        <td><?php echo $name; ?></td>
                        <td><?php echo $commentText; ?></td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="2">No comments yet.</td>
                </tr>
            <?php endif; ?>
        </tbody>
    </table>

    <a href="index.html" class="back-link">Back to Comment Form</a>
</div>

</body>
</html>

