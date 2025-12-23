<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>Manage Maintenance</title>

  <!-- Tailwind & Google Fonts -->
  <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>

  <!-- Tailwind Custom Config -->
  <script>
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          colors: {
            primary: "#FDE047",
            "background-light": "#FFFFFF",
            "background-dark": "#0a0618",
            "text-light": "#1F2937",
            "text-dark": "#F3F4F6",
            "text-secondary-light": "#6B7280",
            "text-secondary-dark": "#9CA3AF"
          },
          fontFamily: {
            display: ["Urbanist", "sans-serif"],
          },
          borderRadius: {
            DEFAULT: "1rem",
          },
        },
      },
    };
  </script>

  <style>
    body {
      font-family: 'Urbanist', sans-serif;
      transition: background-color 0.4s ease, color 0.4s ease;
    }

    .logo-container {
      padding-bottom: 1rem;
    }

    .logo-container img {
      width: 15vw;
      transition: opacity 0.4s ease;
    }

    @media(max-width:640px){
      .logo-container img {
        width: 50vw;
      }
    }
  </style>
</head>

<body class="bg-background-light dark:bg-background-dark min-h-screen flex flex-col p-6 transition-colors duration-500">

  <!-- Header with Dark/Light Toggle -->
  <header class="w-full flex justify-end items-center">
    <button id="theme-toggle" class="flex items-center justify-center bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-full w-10 h-10 shadow-md transition-all duration-300 hover:scale-105">
      <span id="theme-icon" class="material-icons text-xl">dark_mode</span>
    </button>
  </header>

  <!-- Main Content -->
  <main class="flex-grow flex flex-col justify-between">
    <div class="mt-16">

      <h1 class="text-4xl font-bold text-text-light dark:text-text-dark leading-tight">
        Manage<br/>Maintenance
      </h1>
      <p class="mt-4 text-text-secondary-light dark:text-text-secondary-dark">
        Your one-stop solution for all home maintenance
      </p>
    </div>
    <div class="logo-container">
        <img id="logo" src="${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg" alt="GoodEarth Logo"/>
    </div>


    <div class="w-full mt-10">
      <form action="${pageContext.request.contextPath}/login" method="get">
        <button
          type="submit"
          class="w-full bg-primary text-gray-800 font-semibold py-4 px-4 rounded-full shadow-md focus:outline-none hover:bg-yellow-400 transition"
        >
          Log In
        </button>
      </form>
    </div>
  </main>

  <!-- Dark/Light Mode Script -->
  <script>
    const toggleButton = document.getElementById('theme-toggle');
    const icon = document.getElementById('theme-icon');
    const logo = document.getElementById('logo');

    // 🌓 Apply saved theme and logo on load
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
      document.documentElement.classList.add('dark');
      icon.textContent = 'light_mode';
      logo.src = 'images/GoodEarth-White-logo.svg';
    } else {
      document.documentElement.classList.remove('dark');
      icon.textContent = 'dark_mode';
      logo.src = '${pageContext.request.contextPath}/images/goodearth-logo-colored.svg';
    }

    // 🟢 Toggle theme and logo
    toggleButton.addEventListener('click', () => {
      document.documentElement.classList.toggle('dark');
      const isDark = document.documentElement.classList.contains('dark');

      // change icon and logo
      icon.textContent = isDark ? 'light_mode' : 'dark_mode';
      logo.src = isDark 
        ? '${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg' 
        : '${pageContext.request.contextPath}/images/goodearth-logo-colored.svg';

      // save preference
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
  </script>
</body>
</html>
