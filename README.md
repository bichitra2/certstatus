Create a folder named templates in the same directory as your script, and inside it, create an HTML file named certificate_status.html with the following content:
html
Copy code
<!DOCTYPE html>
<html>
<head>
    <title>SSL Certificate Status</title>
</head>
<body>
    <h1>SSL Certificate Status</h1>
    <p>Certificate Status: {{ status }}</p>
</body>
</html># certstatus


python your_script_name.py
This will start a local web server, and you can access the certificate status by opening a web browser and navigating to http://localhost:5000/.

The webpage will display the certificate's status (Valid or Expired), and if there's an error during the certificate check, it will display an error message.

You can automate this script to run periodically (e.g., once an hour) using scheduling tools like cron on Unix-like systems or Task Scheduler on Windows
