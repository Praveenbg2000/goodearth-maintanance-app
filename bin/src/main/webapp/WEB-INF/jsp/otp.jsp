<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Verify OTP</title>

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
          fontFamily: { display: ["Urbanist", "sans-serif"] },
          borderRadius: { DEFAULT: "1rem" },
        },
      },
    };
  </script>

  <style>
    body { font-family: 'Urbanist', sans-serif; transition: background-color 0.4s ease, color 0.4s ease; }
    .otp-input {
      width: 3rem; height: 3rem; text-align: center; font-size: 1.5rem;
      border-radius: 1rem; border: 2px solid #ccc; outline: none;
      transition: border-color 0.3s, background-color 0.3s, color 0.3s;
      background-color: #fff; color: #1F2937;
    }
    .dark .otp-input { background-color: #1f2937; color: #F3F4F6; border-color: #4B5563; }
    .otp-input:focus { border-color: #fde047; border-radius : 1rem; }
  </style>
</head>

<body class="bg-background-light dark:bg-background-dark text-text-light dark:text-text-dark min-h-screen flex flex-col transition-colors duration-500">
  
  <!-- Header -->
  <header class="w-full flex justify-between items-center p-6">
    <form action="${pageContext.request.contextPath}/login" method="GET">
      <button type="submit" class="text-gray-700 dark:text-gray-300 hover:text-black dark:hover:text-white">
        <span class="material-icons text-2xl">arrow_back</span>
      </button>
    </form>

    <button id="theme-toggle" class="flex items-center justify-center bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-full w-10 h-10 shadow-md transition-all duration-300 hover:scale-105">
      <span id="theme-icon" class="material-icons text-xl">dark_mode</span>
    </button>
  </header>

  <!-- Main Section -->
  <main class="flex-grow flex flex-col items-center justify-center text-center px-6">
    <div class="max-w-md w-full space-y-8">
      <div class="text-left">
        <h1 class="text-4xl font-bold text-text-light dark:text-text-dark leading-tight mb-4">
          Verify OTP
        </h1>
        <p class="text-text-secondary-light dark:text-text-secondary-dark text-base">
          Enter the 6-digit code sent to your registered email.
        </p>
      </div>

      <!-- OTP Form -->
      <form id="otpForm" method="post" action="${pageContext.request.contextPath}/verify-otp" class="space-y-6">
        <div id="otp-container" class="flex justify-center gap-2">
          <input type="text" maxlength="1" class="otp-input" required />
          <input type="text" maxlength="1" class="otp-input" required />
          <input type="text" maxlength="1" class="otp-input" required />
          <input type="text" maxlength="1" class="otp-input" required />
          <input type="text" maxlength="1" class="otp-input" required />
          <input type="text" maxlength="1" class="otp-input" required />
        </div>

        <!-- Hidden field to combine digits -->
        <input type="hidden" name="otp" id="finalOtp" />

        <button type="submit" class="w-full bg-primary text-gray-800 font-semibold py-4 px-4 rounded-full shadow-md focus:outline-none hover:opacity-90">
          Verify OTP
        </button>
      </form>

      <!-- Messages -->
      <c:if test="${not empty error}">
        <p class="text-red-500 text-sm">${error}</p>
      </c:if>
      <c:if test="${not empty message}">
        <p class="text-green-500 text-sm">${message}</p>
      </c:if>
     <form method="post" action="${pageContext.request.contextPath}/request-otp">
  <input type="hidden" name="email" value="${email}" />
  <input type="hidden" name="selectedHome" value="${selectedHome}" />

  <div class="text-text-secondary-light dark:text-text-secondary-dark text-sm">
    Didn’t receive the OTP? 
    <button type="submit" class="text-primary font-semibold hover:underline">
      Resend OTP
    </button>
  </div>
</form>

    </div>
  </main>

  <!-- Scripts -->
  <script>
    const toggleButton = document.getElementById('theme-toggle');
    const icon = document.getElementById('theme-icon');
    const inputs = document.querySelectorAll(".otp-input");
    const finalOtp = document.getElementById("finalOtp");

    // Dark/Light theme persistence
    if (localStorage.getItem('theme') === 'dark') {
      document.documentElement.classList.add('dark');
      icon.textContent = 'light_mode';
    }
    toggleButton.addEventListener('click', () => {
      document.documentElement.classList.toggle('dark');
      const isDark = document.documentElement.classList.contains('dark');
      icon.textContent = isDark ? 'light_mode' : 'dark_mode';
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });

    // OTP auto-focus & backspace behavior
    inputs.forEach((input, index) => {
      input.addEventListener("input", () => {
        if (input.value.length === 1 && index < inputs.length - 1) inputs[index + 1].focus();
        updateFinalOtp();
      });
      input.addEventListener("keydown", (e) => {
        if (e.key === "Backspace" && input.value === "" && index > 0) inputs[index - 1].focus();
      });
    });

    function updateFinalOtp() {
      finalOtp.value = Array.from(inputs).map(i => i.value).join("");
    }

    // Prevent non-numeric entry
    inputs.forEach(input => {
      input.addEventListener("keypress", e => {
        if (!/[0-9]/.test(e.key)) e.preventDefault();
      });
    });
  </script>
</body>
</html>
