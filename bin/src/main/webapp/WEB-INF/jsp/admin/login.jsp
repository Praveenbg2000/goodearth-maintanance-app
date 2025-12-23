<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #0078d7, #00b4d8);
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background: #fff;
            padding: 40px 45px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            width: 400px;
            text-align: center;
            animation: fadeIn 0.6s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-container img {
            width: 70px;
            height: 70px;
            margin-bottom: 10px;
        }

        h2 {
            color: #0078d7;
            margin-bottom: 25px;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 15px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        input:focus {
            border-color: #0078d7;
            outline: none;
            box-shadow: 0 0 5px rgba(0,120,215,0.3);
        }

        button {
            background-color: #0078d7;
            color: white;
            border: none;
            padding: 12px 20px;
            width: 100%;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.25s ease, transform 0.1s ease;
        }

        button:hover {
            background-color: #005fa3;
            transform: scale(1.03);
        }

        .error {
            color: #e74c3c;
            font-weight: 500;
            margin-top: 12px;
        }

        .back-link {
            display: block;
            margin-top: 15px;
            font-size: 14px;
        }

        .back-link a {
            color: #0078d7;
            text-decoration: none;
            font-weight: bold;
        }

        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
    <div class="login-container">
        <img src="https://cdn-icons-png.flaticon.com/512/1041/1041916.png" alt="Admin Icon" />
        <h2>Admin Login</h2>

        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <input type="email" name="email" placeholder="Admin Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <button type="submit">Login</button>
        </form>

        <div class="error">${error}</div>
    </div>
</body>
</html>
