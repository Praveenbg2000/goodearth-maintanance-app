<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Server Error</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
     <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>

    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#FDE047",
                        secondary: "#1F2937",
                        "background-light": "#F3F4F6",
                        "background-dark": "#0B0C15",
                        "surface-dark": "#161822",
                        "text-grey": "#9CA3AF",
                    },
                    fontFamily: { display: ["Urbanist", "sans-serif"] },
                    borderRadius: {
                        pill: "9999px",
                    },
                },
            },
        };
    </script>

    <style>
        body { transition: background-color 0.3s ease, color 0.3s ease; }
    </style>
</head>

<body class="bg-background-light dark:bg-background-dark text-gray-900 dark:text-white font-body min-h-screen flex flex-col items-center justify-between p-6 relative overflow-hidden">

<!-- Header -->
<div class="w-full max-w-md flex justify-end items-center z-10">
    <button id="theme-toggle"
            class="p-2 rounded-full bg-gray-200 dark:bg-white/10 hover:bg-gray-300 dark:hover:bg-white/20 transition-colors">
        <span class="material-icons-round text-xl">dark_mode</span>
    </button>
</div>

<!-- Main -->
<main class="flex-1 w-full max-w-md flex flex-col justify-center items-center text-center z-10 space-y-8">

    <!-- Icon -->
    <div class="relative w-32 h-32">
        <div class="absolute inset-0 bg-primary/20 rounded-full animate-ping opacity-75"></div>
        <div class="relative flex items-center justify-center w-full h-full bg-white dark:bg-surface-dark rounded-full shadow-lg border-4 border-gray-100 dark:border-white/5">
            <span class="material-icons-round text-6xl text-primary rotate-12">dns</span>
            <div class="absolute bottom-2 right-2 w-8 h-8 bg-red-500 rounded-full flex items-center justify-center border-4 border-white dark:border-surface-dark">
                <span class="material-icons-round text-white text-sm">priority_high</span>
            </div>
        </div>
    </div>

    <!-- Message -->
    <div class="space-y-3">
        <h1 class="text-3xl font-bold">Your session has expired. Please log in again to continue.</h1>
        <p class="text-gray-500 dark:text-text-grey px-4">
            For security reasons, your session has expired. Kindly log in again.
        </p>
    </div>

    <!-- Error code -->
    <div class="inline-flex items-center px-3 py-1 rounded-full bg-gray-200 dark:bg-surface-dark border border-gray-300 dark:border-white/10">
        <span class="w-2 h-2 rounded-full bg-red-500 mr-2 animate-pulse"></span>
        <span class="text-xs font-mono text-gray-600 dark:text-gray-400">
            Logged out : Session Error
        </span>
    </div>

    <!-- Actions -->
    <div class="w-full space-y-4 pt-4">

        <!-- Login Button -->
        <a href="${pageContext.request.contextPath}/login"
           class="w-full bg-primary hover:bg-yellow-300 text-gray-900 font-semibold py-4 px-6 rounded-pill shadow-lg shadow-yellow-400/20 flex items-center justify-center space-x-2 transition-all">
            <span class="material-icons-round text-xl">login</span>
            <span>Login Again</span>
        </a>
    </div>

</main>


<!-- Background blobs -->
<div class="absolute top-[-10%] left-[-10%] w-64 h-64 bg-primary/10 rounded-full blur-3xl"></div>
<div class="absolute bottom-[-10%] right-[-10%] w-80 h-80 bg-blue-500/10 rounded-full blur-3xl"></div>

<!-- Dark mode toggle -->
<script>
    const toggle = document.getElementById("theme-toggle");
    const html = document.documentElement;
    const icon = toggle.querySelector("span");

    if (localStorage.theme === "dark") {
        html.classList.add("dark");
        icon.textContent = "light_mode";
    }

    toggle.onclick = () => {
        html.classList.toggle("dark");
        localStorage.theme = html.classList.contains("dark") ? "dark" : "light";
        icon.textContent = html.classList.contains("dark") ? "light_mode" : "dark_mode";
    };
</script>

</body>
</html>
