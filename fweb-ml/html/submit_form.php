<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $address = $_POST['address'];
    // Handle the rest of the form data
    echo "Form submitted successfully!";
     // Add a link back to index.html
    echo '<p><a href="index.html">Go back to the form</a></p>';
}
?>

