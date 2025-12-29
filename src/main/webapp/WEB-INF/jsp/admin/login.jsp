<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Login</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>

    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#0078d7",
                        "primary-hover": "#005fa3"
                    },
                    fontFamily: {
                        display: ["Inter", "sans-serif"],
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center bg-gray-100">

<div class="w-full h-screen flex flex-col lg:flex-row overflow-hidden">

    <!-- LEFT : LOGIN FORM -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-8 bg-white">
        <div class="w-full max-w-md space-y-8">

            <div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">
                    Welcome Admin
                </h1>
                <p class="text-gray-500">
                    Please login to continue
                </p>
            </div>

            <!-- FORM (FUNCTIONALITY PRESERVED) -->
            <form action="${pageContext.request.contextPath}/admin/login" method="post" class="space-y-6">

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">
                        Admin Email
                    </label>
                    <input
                        type="email"
                        name="email"
                        required
                        placeholder="Enter your email"
                        class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                    />
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">
                        Password
                    </label>
                    <input
                        type="password"
                        name="password"
                        required
                        placeholder="********"
                        class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"
                    />
                </div>

                <button
                    type="submit"
                    class="w-full py-3 bg-primary text-white font-bold rounded-lg hover:bg-primary-hover transition"
                >
                    Login
                </button>

                <!-- ERROR MESSAGE (PRESERVED) -->
                <c:if test="${not empty error}">
                    <div class="text-red-600 font-medium text-center">
                        ${error}
                    </div>
                </c:if>

            </form>

        </div>
    </div>

    <!-- RIGHT : IMAGE -->
    <div class="hidden lg:flex lg:w-1/2 relative overflow-hidden">

        <img
            src="${pageContext.request.contextPath}/images/IMG_7700.jpg"
            alt="Admin Illustration"
            class="absolute inset-0 w-full h-full object-cover"
        />

        <!-- Gradient Overlay -->
        <div class="absolute inset-0 bg-gradient-to-t from-black/50 via-black/30 to-transparent"></div>

    </div>

</div>

</body>
</html>
