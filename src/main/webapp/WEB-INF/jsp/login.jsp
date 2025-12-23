<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>User Login</title>

  <!-- Tailwind & Google Fonts -->
  <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>

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
    body {
      font-family: 'Urbanist', sans-serif;
      transition: background-color 0.4s ease, color 0.4s ease;
    }
    .material-icons {
      vertical-align: middle;
    }
    .valid-tick {
      position: absolute;
      right: 15px;
      top: 50%;
      transform: translateY(-50%);
      color: green;
      display: none;
    }
    .relative-input {
      position: relative;
    }

    /* ===== OTP LOADER (ADDED) ===== */
    #otpLoader {
      position: fixed;
      inset: 0;
      background-color: #0a0618;
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 9999;
    }

    .otp-logo-container {
      opacity: 0;
      transform: translateY(100px);
      animation: slideUp 1.2s ease-out forwards;
      text-align: center;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(100px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .otp-logo-container img {
      width: 25vw;
      max-width: 280px;
      margin: auto;
    }

    .otp-loader {
      border: 4px solid rgba(255,255,255,0.2);
      border-top: 4px solid #fff;
      border-radius: 50%;
      width: 2.5rem;
      height: 2.5rem;
      animation: spin 1s linear infinite;
      margin: 2rem auto 0;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .otp-loader-text {
      color: white;
      margin-top: 14px;
      font-size: 14px;
      letter-spacing: 1px;
    }

    @media(max-width:640px){
      .otp-logo-container img {
        width: 70vw;
      }
    }
  </style>
</head>

<body class="bg-background-light dark:bg-background-dark text-text-light dark:text-text-dark min-h-screen flex flex-col transition-colors duration-500">

<!-- 🔄 OTP Sending Loader (ADDED) -->
<div id="otpLoader">
  <div class="otp-logo-container">
    <img src="${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg" alt="GoodEarth Logo"/>
    <div class="otp-loader"></div>
    <div class="otp-loader-text">Sending OTP… Please wait</div>
  </div>
</div>

<!-- Header -->
<header class="w-full flex justify-between items-center p-6">
  <form action="${pageContext.request.contextPath}/manage" method="GET">
    <button type="submit" class="text-gray-700 dark:text-gray-300 hover:text-black dark:hover:text-white">
      <span class="material-icons text-2xl">arrow_back</span>
    </button>
  </form>

  <button id="theme-toggle"
          class="flex items-center justify-center bg-gray-200 dark:bg-gray-700
                 text-gray-800 dark:text-gray-200 rounded-full w-10 h-10 shadow-md
                 transition-all duration-300 hover:scale-105">
    <span id="theme-icon" class="material-icons text-xl">dark_mode</span>
  </button>
</header>

<!-- Main Section -->
<main class="flex-grow flex flex-col items-center justify-center text-center px-6">
  <div class="max-w-md w-full space-y-8">
    <div class="text-left">
      <h1 class="text-4xl font-bold text-text-light dark:text-text-dark leading-tight mb-4">
        Enter Your Email
      </h1>
      <p class="text-text-secondary-light dark:text-text-secondary-dark text-base">
        Please enter your registered email ID to receive an OTP for login.
      </p>
    </div>

    <!-- Login Form -->
    <form method="post"
          action="${pageContext.request.contextPath}/request-otp"
          class="space-y-6"
          id="loginForm"
          onsubmit="showOtpLoader()">

      <div class="relative-input">
        <input type="email"
               id="emailInput"
               name="email"
               placeholder="Enter your email"
               required
               autocomplete="email"
               class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-600 
                      bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 
                      placeholder-gray-500 dark:placeholder-gray-400 
                      focus:outline-none focus:ring-2 focus:ring-primary"/>
        <span id="validTick" class="material-icons valid-tick">check_circle</span>
      </div>

      <!-- 🏠 Dynamic Home Dropdown -->
      <div id="homeDropdownContainer" style="display:none;">
        <label class="block text-left text-sm font-medium text-gray-600 dark:text-gray-300 mb-2">
          Select Home
        </label>
        <select id="homeDropdown"
                name="selectedHome"
                required
                class="w-full px-4 py-3 rounded-xl border border-gray-300 dark:border-gray-600 
                       bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 
                       focus:outline-none focus:ring-2 focus:ring-primary">
        </select>
      </div>

      <!-- Hidden Home Input -->
      <input type="hidden" id="hiddenHome" name="selectedHome"/>

      <button type="submit"
              class="w-full bg-primary text-gray-800 font-semibold py-4 px-4
                     rounded-full shadow-md focus:outline-none hover:opacity-90">
        Send OTP
      </button>
    </form>

    <!-- Feedback -->
    <p id="feedbackMsg" class="text-sm mt-2"></p>

    <c:if test="${not empty error}">
      <p class="text-red-500 text-sm">${error}</p>
    </c:if>
    <c:if test="${not empty message}">
      <p class="text-green-500 text-sm">${message}</p>
    </c:if>
  </div>
</main>

<!-- 🌗 Theme Toggle -->
<script>
  const toggleButton = document.getElementById('theme-toggle');
  const icon = document.getElementById('theme-icon');

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
</script>

<!-- 🧠 Fetch Homes Dynamically -->
<script>
document.getElementById('emailInput').addEventListener('blur', async function() {
  const email = this.value.trim();
  const dropdown = document.getElementById('homeDropdown');
  const container = document.getElementById('homeDropdownContainer');
  const tick = document.getElementById('validTick');
  const feedback = document.getElementById('feedbackMsg');

  tick.style.display = 'none';
  feedback.textContent = '';
  feedback.className = 'text-sm mt-2';

  if (!email) {
    container.style.display = "none";
    return;
  }

  const baseUrl = "${pageContext.request.contextPath}";
  const res = await fetch(baseUrl + "/user/fetch-homes?email=" + encodeURIComponent(email));

  if (!res.ok) {
    feedback.textContent = "⚠️ Error fetching homes. Try again.";
    feedback.classList.add('text-red-500');
    return;
  }

  const homes = await res.json();
  dropdown.innerHTML = "";

  if (homes.length > 0) {
    homes.forEach(h => {
      const opt = document.createElement('option');
      opt.value = h;
      opt.textContent = h;
      dropdown.appendChild(opt);
    });
    container.style.display = "block";
    tick.style.display = "inline";
    feedback.textContent = "✅ Email found! Please select your home.";
    feedback.classList.add('text-green-500');

    if (homes.length === 1) {
      dropdown.value = homes[0];
      document.getElementById('hiddenHome').value = homes[0];
    }
  } else {
    container.style.display = "none";
    feedback.textContent = "⚠️ Email not registered.";
    feedback.classList.add('text-red-500');
  }
});

// Ensure home is submitted
document.getElementById("loginForm").addEventListener("submit", function () {
  const dropdown = document.getElementById("homeDropdown");
  const hiddenHome = document.getElementById("hiddenHome");

  if (dropdown && dropdown.value) {
    hiddenHome.value = dropdown.value;
  } else if (dropdown.options.length > 0) {
    hiddenHome.value = dropdown.options[0].value;
  }
});
</script>

<!-- 🔄 Show Loader on Send OTP -->
<script>
function showOtpLoader() {
  const btn = document.querySelector("#loginForm button[type='submit']");
  if (btn) btn.disabled = true;
  document.getElementById("otpLoader").style.display = "flex";
}
</script>

</body>
</html>
