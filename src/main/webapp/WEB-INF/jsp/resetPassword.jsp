<!-- resetPassword.jsp -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
</head>
<body>
    <h2>Reset Password</h2>
    <form action="/api/user/reset-password" method="post">
        <label for="resetToken">Reset Token:</label>
        <input type="text" id="resetToken" name="resetToken" required><br><br>

        <label for="newPassword">New Password:</label>
        <input type="password" id="newPassword" name="newPassword" required><br><br>

        <input type="submit" value="Reset Password">
    </form>
</body>
</html>