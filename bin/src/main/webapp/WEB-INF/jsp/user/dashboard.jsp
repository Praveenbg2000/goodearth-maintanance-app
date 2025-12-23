<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Dashboard</title>

  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>

  <style>
    /* 🌍 Base Styles */
    * { margin: 0; padding: 0;}
    
    *:focus {
  outline: none !important;
}
html, body {
  scroll-behavior: auto !important;
}
    
    
    body {
      font-family: 'Urbanist', sans-serif;
      background-color: var(--bg-primary);
      color: var(--text-primary);
      transition: background-color 0.4s, color 0.4s;
    }

    :root {
      --bg-primary: #ffffff;
      --card-bg: #ffffff;
      --text-primary: #1f1f1f;
      --text-secondary: #555;
      --accent: #facc15;
      --header-gradient: #0A0813;
    }
    
    
        .toast {
      position: fixed;
      bottom: -100px;
      left: 50%;
      transform: translateX(-50%);
      background: #2E304A;
      color: white;
      padding: 0.8rem 1.5rem;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      font-size: 0.9rem;
      font-weight: 500;
      opacity: 0;
      z-index: 9999;
      transition: all 0.5s ease;
    }
    .toast.show { bottom: 40px; opacity: 1; }
    .toast.success { background: #16a34a; }
    .toast.error { background: #dc2626; }
    
    .task-check {
  position: absolute;
  opacity: 0;
  pointer-events: none; /* prevents double clicks */
}

    .dark {
      --bg-primary: #1F1D2B;
      --card-bg: #2E2B43;
      --text-primary: #f5f5f5;
      --text-secondary: #b3b3b3;
      --accent: #facc15;
      --header-gradient: #4B4364;
    }

    .container {
      max-width: 100%;
      margin: auto;
    }

    /* HEADER */
    header {
      background: var(--header-gradient);
      position: sticky;
      top: 0;
      z-index: 50;
      padding: 1.5rem;
      border-bottom-left-radius: 1.5rem;
      border-bottom-right-radius: 1.5rem;
      box-shadow: 0 4px 10px rgba(0,0,0,0.2);
      margin-bottom: 4rem;
      color: white;
    }

    .header-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
    }

    .user-info h1 {
      font-size: 1.8rem;
      font-weight: 600;
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 1rem;
    }

    #themeToggle {
      background-color: rgba(255,255,255,0.2);
      border: none;
      border-radius: 50%;
      padding: 0.5rem;
      cursor: pointer;
      transition: 0.3s;
    }

    #themeToggle:hover { background-color: rgba(255,255,255,0.3); }

    .profile { position: relative; }

    .profile img {
      width: 45px;
      height: 45px;
      border-radius: 50%;
      border: 2px solid var(--accent);
      object-fit: cover;
      cursor: pointer;
    }

    .profile-menu {
      display: none;
      position: absolute;
      right: 0;
      top: 55px;
      background: var(--card-bg);
      border-radius: 10px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.3);
      width: 180px;
      overflow: hidden;
      z-index: 50;
    }

    .profile-menu a {
      display: block;
      padding: 0.6rem 1rem;
      color: var(--text-primary);
      text-decoration: none;
      transition: 0.2s;
    }

    .profile-menu a:hover { background-color: rgba(0,0,0,0.05); }
    .profile-menu a.logout { color: red; }

    /* Search bar */
.search-bar {
  display: flex;
  align-items: center;
  background: #ffffff;
  border-radius: 30px;
  padding: 0.5rem 1rem;
  margin-top: 1rem;

  /* FIXES */
  position: relative;
  z-index: 999;
  width: 100%;
  box-sizing: border-box;
  gap: 10px;
  cursor: text; /* ensures clickable */
}

.dark .search-bar { background: white; }

.search-bar input {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  font-size: 1rem;
  color: black;
  padding-left: 5px;
  cursor: text;
  z-index: 1000;
}

.search-bar span {
  color: gray;
  font-size: 22px;
  cursor: pointer;
}

/* Ensure icons don’t block clicking the input */
.search-bar * {
  pointer-events: auto;
}
    /* MONTH SLIDER */
       /* MONTH SLIDER */
    .month-section {
      border-radius: 1rem;
      padding: 1rem;
      margin-bottom: 1.5rem;
      overflow-x: hidden;
    }

    .month-slider {
      display: flex;
      overflow-x: auto;
      gap: 1rem;
      padding: 0.5rem 0;
      scrollbar-width: none;
    }

    .month-slider::-webkit-scrollbar { display: none; }

    .month-item {
      cursor: pointer;
      font-size: 1.2rem;
      color: rgb(190, 190, 190);
      border-bottom: 2px solid transparent;
      padding-bottom: 0.5rem;
      transition: 0.3s;
      white-space: nowrap;
      flex-shrink: 0;
    }

    .dark .month-item { color: #888; }

    .month-item.active {
      color: black;
      border-color: var(--accent);
      font-size: 1.3rem;
      font-weight: 600;
      text-decoration: none;
      justify-content: center;
    }

    .dark .month-item.active { color: white; }

    /* MAINTENANCE SECTION */
    .tasks {
      border-radius: 1rem;
      padding: 1.2rem;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    .tasks h2 {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 1rem;
    }

    .progress-container {
      width: 100%;
      height: 25px;
      background: #e5e5e5;
      border-radius: 5px;
      overflow: hidden;
      margin-bottom: 0.5rem;
    }

    .dark .progress-container { background: #444; }

    .progress-bar {
      height: 25px;
      width: 0%;
      background-image: url('${pageContext.request.contextPath}/images/green-color-bar.png');
      border-radius: 5px;
      transition: width 0.5s ease;
    }

    .dark .progress-bar {
      background-image: url('${pageContext.request.contextPath}/images/green-color-bar.png');
    }

    .progress-text {
      font-size: 0.8rem;
      color: var(--text-secondary);
      text-align: left;
      margin-bottom: 1rem;
    }

    /* 🎨 ACCORDION DESIGN (based on screenshot) */
    .accordion {
      background: var(--card-bg);
      border-radius: 1rem;
      margin-bottom: 1rem;
      border: none;
      box-shadow: 0 3px 10px rgba(0,0,0,0.08);
      overflow: hidden;
      transition: all 0.3s ease;
    }


    .discription-with-content{
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 1rem;
    }

   .accordion-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem;
  background: var(--card-bg);
  border-radius: 1rem;
  cursor: pointer;
  transition: background 0.3s ease, color 0.3s ease;
}

/* When accordion is open → change only the header color */
.accordion.open .accordion-header {
  background-color: #FFD36E !important;
  color: #2E304A !important;
}

/* Keep inner text dark for readability */
.accordion.open .accordion-header span {
  color: #2E304A !important;
}

/* Optional: add a smooth transition effect on open/close */
.accordion {
  transition: background 0.3s ease;
}


    .accordion-header:hover {
      transform: translateY(-2px);
    }

    .accordion.open .accordion-content {
      max-height: 200px;
      padding: 1rem;
    }

    .accordion-content {
  max-height: 0;
  overflow: hidden;
  background: rgba(255, 211, 110, 0); /* #FFD36E but fully transparent */
  transition: max-height 0.3s ease, background 0.3s ease;
  padding: 0 1rem;
}

.accordion.open .accordion-content {
  max-height: 200px;
  padding: 1rem;
  background: rgba(255, 211, 110, 0); /* keep it 0% opacity */
}


    /* ✅ Checkbox */
    .custom-check {
      width: 18px;
      height: 18px;
      border: 2px solid var(--text-primary);
      border-radius: 50%;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin-right: 10px;
      cursor: pointer;
      transition: 0.3s;
    }

    .custom-check input {
      opacity: 0;
      position: absolute;
      width: 100%;
      height: 100%;
      cursor: pointer;
    }

    .custom-check input:checked::after {
      content: '';
      position: absolute;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background-color: var(--accent);
    }

    /* 🎯 Raise Ticket Button Centered */
    .accordion-content a {
      display: inline-block;
      margin: 1rem auto 0;
      background-color: #fbbf24; /* orange accent */
      color: #000;
      font-weight: 600;
      text-decoration: none;
      padding: 0.6rem 1.2rem;
      border-radius: 8px;
      text-align: center;
      transition: background 0.3s;
    }

    .accordion-content a:hover {
      background-color: #facc15;
    }

    .accordion-content p {
      text-align: center;
      font-size: 0.9rem;
      color: var(--text-secondary);
    }

    .how-to {
      padding: 1rem;
    }

    .how-to-do{
      display: flex;
      align-items: center;
      gap: 1rem;
      padding: 0.5rem 0;
    }

    /* MOBILE */
    @media(max-width:640px){
      .user-info h1 { font-size: 1.3rem; }
      header { padding: 1.2rem; }
      .accordion-header span { font-size: 0.85rem; }
      .discription-with-content{
        padding: 0rem;
      }
    }
  </style>
</head>

<body>
<div class="container">

  <!-- HEADER -->
  <header>
    <div class="header-top">
<div class="user-info">
  <h1>Hi, <c:out value="${viewerName != null ? viewerName : sessionScope.username}" /></h1>
<h3 style="font-size: 1.1rem; margin-top: 0.3rem; color: #FFD36E;">
   <c:out value="${selectedHome}" />
</h3>

</div>


      <div class="header-actions">
        <button id="themeToggle"><span id="themeIcon" class="material-icons">dark_mode</span></button>
        <div class="profile">
          <c:choose>
            <c:when test="${not empty user.profilePhoto}">
              <img id="profileBtn" src="${pageContext.request.contextPath}/user/photo/${user.profilePhoto}" />
            </c:when>
            <c:otherwise>
              <img id="profileBtn" src="https://cdn-icons-png.flaticon.com/512/149/149071.png" />
            </c:otherwise>
          </c:choose>
          <div id="profileMenu" class="profile-menu">
            <a href="${pageContext.request.contextPath}/user/my-profile">My Profile</a>
            <a href="${pageContext.request.contextPath}/user/added-users">Added Users</a>
            <a href="${pageContext.request.contextPath}/user/logout" class="logout">Logout</a>
          </div>
        </div>
      </div>
    </div>
    <div style="width: 100%; display: flex; justify-content: center; position: relative; top: 50px; left: 20px;">
      <img src="${pageContext.request.contextPath}/images/hand-back-fist-solid-full.svg" alt="GoodEarth Logo" style="width:120px;"/>
    </div>
    
    <!-- Search -->
    <div class="search-bar" style="position: relative; top: 38px; z-index: 1000;">
      <span class="material-icons">search</span>
      <input id="taskSearchInput" type="text" placeholder="How do I check rainwater chamber?" />
      <span class="material-icons">mic</span>
    </div>
  </header>

<!-- MONTH SLIDER -->
  <section class="month-section">
    <div class="month-header" style="display:flex;justify-content:space-between;align-items:center; gap:1rem; margin-bottom:0.5rem;">
      <span id="currentYear"></span>
    </div>
    <div id="monthSlider" class="month-slider"></div>
  </section>
  
  <!-- TASKS -->
  <section class="tasks">
  <div style="display:flex; flex-direction:row; justify-content:space-between;" >
    <h2 id="maintenanceTitle">Maintenance</h2>
    <div class="flex justify-between items-center mb-4">
    <span id="progressPercent" class="text-sm text-gray-300 font-medium">0%</span>
  </div>
  </div>
    <div class="progress-container">
      <div id="taskProgressBar" class="progress-bar"></div>
    </div>
    <p id="taskProgressText" class="progress-text">0 of 4 tasks completed</p>

    <div id="accordion-container" class="space-y-4">
      <c:forEach var="task" items="${tasks}">
        <!-- Added data-month attribute. Backend must populate task.month (e.g., "January") -->
        <div class="accordion bg-[#2A2B3D] rounded-2xl overflow-hidden transition-all duration-300"
             data-task="${task.title}" data-month="${task.month}">
          
          <!-- Accordion Header -->
          <div class="accordion-header flex justify-between items-stretch cursor-pointer h-[50px] bg-[#2E304A]/90">
            <div class="flex items-center gap-3 px-4 w-full">
              <label class="relative flex items-center cursor-pointer">
                <input type="checkbox" class="task-check" />
                <span class="custom-check w-[18px] h-[18px] border-2 border-white rounded-full flex items-center justify-center transition-all duration-300"></span>
              </label>
              <span class="font-medium text-white text-[15px]">${task.title}</span>
            </div>
            <div class="arrow-box bg-[#FFD36E] flex items-center justify-center h-full w-[50px]">
              <span class="material-icons text-black transition-transform">chevron_right</span>
            </div>
          </div>

          <!-- Accordion Content -->
          <div class="accordion-content max-h-0 overflow-hidden transition-all duration-300 ease-in-out bg-transparent">
            <div class="p-4 text-sm text-gray-300">

              <!-- Description -->
              <div class="discription-with-content">
                <div class="discription-image">
                  <c:if test="${not empty task.taskImage}">
                    <img src="${pageContext.request.contextPath}/images/${task.taskImage}" alt="Task Image" style="width: 120px; height: 120px; border-radius: 8px;">
                  </c:if>
                </div>
                <div style="width: 100%;">
                  <p style="width: 100%; text-align: left; font-size: small;">${task.description}</p>
                </div>
              </div>

              <!-- Steps -->
              <h2 class="how-to mt-3">How to?</h2>
              <c:forEach var="step" items="${task.steps}">
                <div class="how-to-do">
                  <div class="circle-img">
                    <c:if test="${not empty step.stepImage}">
                      <img src="${pageContext.request.contextPath}/images/${step.stepImage}" alt="Step ${step.stepOrder}" style="width: 100px; height: 100px; border-radius: 50%;">
                    </c:if>
                  </div>
                  <div>
                    <p style="font-size: small; text-align: left;">${step.stepText}</p>
                  </div>
                </div>
              </c:forEach>

              <!-- Materials -->
            <h2 class="how-to mt-3" style="display: inline; font-weight: 600; padding-left: none; width:100%;">Materials/Finish:</h2>
			<div style="width:100%; padding-left: 0.5rem; padding-right: 0.5rem;">
				<span style="font-weight: 400; font-size: 12px; width:100%; ">${task.materialsFinish}</span>
			</div>

              <div style="display:flex; flex-direction:column; justify-content: center; width: 100%">
              <div style="display:flex; justify-content: center; width:100%; margin-top:15px;"><h4 style="font-weight: 400;">Still having issues?</h4></div>
          <!-- Raise Ticket Button -->
              <a href="${pageContext.request.contextPath}/user/raise-ticket?task=${task.title}"
                 class="mt-3 inline-block bg-[#ffd36ec4] hover:bg-yellow-500 text-black px-4 py-1.5 rounded-lg text-sm font-medium" style="text-decoration: underline; border-radius:25px; font-size: small; padding: 15px; width: 35vw;">
                 Raise Ticket
              </a>          
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- Toast -->
    <div id="toast" class="toast"></div>
  </section>
</div>

<!-- Inline small style fixes (kept from your original file) -->
<style>
  .custom-check::after { content: '✓'; font-size: 18px; font-weight: 600; color: green; display: none; }
  input:checked + .custom-check { background-color: #FFD36E; border-color: #FFD36E; }
  input:checked + .custom-check::after { display: block; }

  /* Remove yellow background from accordion content */
  .accordion-content { background: transparent !important; }

  /* When checked, highlight header yellow */
  .task-check:checked ~ .custom-check {
    background-color: #FFD36E !important;
    border-color: #FFD36E !important;
  }
  .task-check:checked ~ .custom-check + span,
  .task-check:checked ~ span {
    color: #2E304A !important;
  }

  .accordion-header.checked {
    background-color: #FFD36E !important;
    color: #2E304A !important;
  }
</style>

<!-- Consolidated script block -->
<script>
document.addEventListener("DOMContentLoaded", async () => {
  const baseUrl = "${pageContext.request.contextPath}";
  const monthNames = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  const now = new Date();
  const currentMonthIdx = now.getMonth();
  const currentYear = now.getFullYear();
  //--- GLOBAL selected month ---
  // Initialize with the full name of the current month
  let selectedMonth = monthNames[currentMonthIdx]; 

  // Elements
  const slider = document.getElementById("monthSlider");
  const title = document.getElementById("maintenanceTitle");
  const yearEl = document.getElementById("currentYear");
  const accordionContainer = document.getElementById("accordion-container");
  const progressBar = document.getElementById("taskProgressBar");
  const progressText = document.getElementById("taskProgressText");
  const progressPercent = document.getElementById("progressPercent");
  const toastEl = document.getElementById("toast");
  const profileBtn = document.getElementById("profileBtn");
  const profileMenu = document.getElementById("profileMenu");
  const themeToggle = document.getElementById("themeToggle");
  const themeIcon = document.getElementById("themeIcon");
  const searchInput = document.getElementById("taskSearchInput");

  // set current year
  yearEl.textContent = currentYear;

  // helper: toast
  function showToast(message, type = "success") {
    toastEl.textContent = message;
    toastEl.className = `toast show ${type}`;
    setTimeout(() => { toastEl.className = "toast"; }, 3000);
  }

  // theme
  function setTheme(mode) {
    const html = document.documentElement;
    if (mode === "dark") {
      html.classList.add("dark");
      themeIcon.textContent = "light_mode";
      localStorage.setItem("theme", "dark");
    } else {
      html.classList.remove("dark");
      themeIcon.textContent = "dark_mode";
      localStorage.setItem("theme", "light");
    }
  }
  setTheme(localStorage.getItem("theme") || "light");
  themeToggle.addEventListener("click", () => {
    const mode = document.documentElement.classList.contains("dark") ? "light" : "dark";
    setTheme(mode);
  });

  // profile menu
  profileBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    profileMenu.style.display = profileMenu.style.display === "block" ? "none" : "block";
  });
  document.addEventListener("click", (e) => {
    if (!profileMenu.contains(e.target)) profileMenu.style.display = "none";
  });

  // Generate month slider
  monthNames.forEach((m, i) => {
    const div = document.createElement("div");
    div.textContent = m.slice(0, 3);
    div.className = "month-item";

    if (i === currentMonthIdx) {
      div.classList.add("active");
      title.textContent = m + "'s Maintenance Tasks"; 
    }

    div.addEventListener("click", () => {
      document.querySelectorAll(".month-item")
        .forEach(el => el.classList.remove("active"));

      div.classList.add("active");
      
      selectedMonth = m; // Update global month variable

      title.textContent = m + "'s Maintenance Tasks"; 

      // Reset search input on month change
      searchInput.value = ""; 

      filterTasksByMonth(m);
    });

    slider.appendChild(div);
  });


  // scroll to current month
  setTimeout(() => {
    slider.children[currentMonthIdx]?.scrollIntoView({ behavior: "smooth", inline: "center" });
  }, 200);

  // Fetch saved tasks (which tasks are completed) from server
  let savedTasks = [];
  try {
    const res = await fetch(`${baseUrl}/user/tasks`, { credentials: "include" });
    if (res.ok) savedTasks = await res.json();
  } catch (e) {
    // ignore - default to empty
    savedTasks = [];
  }

  // Initialize accordions and checkboxes
  function initializeAccordionsAndCheckboxes() {
    const accordions = Array.from(accordionContainer.querySelectorAll(".accordion"));
    accordions.forEach(acc => {
      const header = acc.querySelector(".accordion-header");
      const content = acc.querySelector(".accordion-content");
      const icon = header.querySelector(".material-icons");
      const checkbox = header.querySelector(".task-check");

      // set saved state if present
      const taskYear = currentYear;
      const taskMonth = acc.getAttribute("data-month");
      const taskName = acc.getAttribute("data-task");
   
      // Find matching saved task
      const match = savedTasks.find(t =>
          t.taskName === taskName &&
          t.taskMonth === taskMonth &&
          t.taskYear === taskYear
      );

      // Apply check if match found
      if (match) {
          checkbox.checked = true;
          header.classList.add("checked");
      } else {
          checkbox.checked = false;
          header.classList.remove("checked");
      }

      // ⭐ FIX: Accordion click logic for smooth, non-scrolling open/close
      header.addEventListener("click", (e) => {
        // Prevent click if target is the checkbox or its label area.
        if (e.target.type === "checkbox" || e.target.closest('label')?.querySelector('.task-check') === checkbox) {
            return;
        }

        // 1. Primary Fix: Stop the browser from scrolling the element into view.
        e.preventDefault(); 
        
        const scrollY = window.scrollY; // Save scroll position as a safety measure

        const isOpen = acc.classList.contains("open");

        // close all other accordions
        document.querySelectorAll(".accordion").forEach(a => {
          a.classList.remove("open");
          a.querySelector(".accordion-content").style.maxHeight = 0;
          const ic = a.querySelector(".material-icons");
          if (ic) ic.style.transform = "rotate(0deg)";
        });

        if (!isOpen) {
          acc.classList.add("open");
          // 2. Secondary Fix: Use requestAnimationFrame for smoother animation and scroll restore
          requestAnimationFrame(() => {
            content.style.maxHeight = content.scrollHeight + "px";
            window.scrollTo(0, scrollY); 
          });
          if (icon) icon.style.transform = "rotate(90deg)";
        }
      });


      // checkbox change logic
      checkbox.addEventListener("change", async (ev) => {
        const completed = checkbox.checked;
        // optimistic UI
        if (completed) header.classList.add("checked");
        else header.classList.remove("checked");

        // send update to backend
        try {
          const resp = await fetch(`${baseUrl}/user/update-task`, {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: new URLSearchParams({ taskName, completed, taskMonth, taskYear }),
            credentials: "include"
          });
          const result = await resp.text();
          if (result === "success") {
            showToast(`✅ Task "${taskName}" marked ${completed ? "complete" : "incomplete"}`, "success");
            // update savedTasks array
            if (completed) {
                // Add entire object (avoid duplicates)
                if (!savedTasks.some(t =>
                    t.taskName === taskName &&
                    t.taskMonth === taskMonth &&
                    t.taskYear === taskYear
                )) {
                    savedTasks.push({ taskName, taskMonth, taskYear });
                }
            } else {
                // Remove that specific task entry
                savedTasks = savedTasks.filter(t =>
                    !(t.taskName === taskName &&
                      t.taskMonth === taskMonth &&
                      t.taskYear === taskYear)
                );
            }

          } else if (result === "deleted") {
            showToast(`🗑️ Task "${taskName}" removed`, "error");
            // if deleted, hide the task
            acc.style.display = "none";
          } else {
            showToast(`⚠️ Something went wrong`, "error");
            // revert UI if needed
            checkbox.checked = !completed;
            if (!completed) header.classList.add("checked");
            else header.classList.remove("checked");
          }
        } catch (err) {
          showToast(`⚠️ Network error`, "error");
          // revert
          checkbox.checked = !completed;
          if (!completed) header.classList.add("checked");
          else header.classList.remove("checked");
        }
        // update progress after change
        updateProgress();
      });
    });
  }

  // Filter tasks by month
  function filterTasksByMonth(monthName) {
      const allTasks = Array.from(document.querySelectorAll("#accordion-container .accordion"));

      allTasks.forEach(task => {
          const taskMonth = task.getAttribute("data-month");

          // Show tasks that belong to selected month
          if (!taskMonth || taskMonth === monthName) {
              task.style.display = "block";
          } else {
              // Hide tasks from other months
              task.style.display = "none";

              // Close if opened
              task.classList.remove("open");

              const content = task.querySelector(".accordion-content");
              if (content) content.style.maxHeight = 0;

              const ic = task.querySelector(".material-icons");
              if (ic) ic.style.transform = "rotate(0deg)";
          }
      });

      // Update progress bar only for visible tasks
      updateProgress();
  }


  // Update progress bar based on visible tasks
  function updateProgress() {
    const allVisible = Array.from(document.querySelectorAll("#accordion-container .accordion"))
                          .filter(a => a.style.display !== "none");
    const total = allVisible.length;
    const done = allVisible.filter(a => {
      const cb = a.querySelector(".task-check");
      return cb && cb.checked;
    }).length;
    const percent = total ? Math.round((done / total) * 100) : 0;
    if (progressBar) progressBar.style.width = percent + "%";
    if (progressPercent) progressPercent.textContent = percent + "%";
    if (progressText) progressText.textContent = done + " of " + total + " tasks completed";
  }


  // Search filter
  if (searchInput) {
    searchInput.addEventListener("input", () => {
      const query = searchInput.value.toLowerCase().trim();
      const tasks = document.querySelectorAll("#accordion-container .accordion");
      // Use the global selectedMonth variable (full name, e.g., "January")
      const currentMonth = selectedMonth; 

      tasks.forEach(task => {
        // Use data-task attribute for reliable name
        const taskMonth = task.getAttribute("data-month")?.toLowerCase() || "";
        const taskTitle = task.getAttribute("data-task")?.toLowerCase() || ""; 

        // Determine if the task is relevant to the current month view.
        const isCurrentMonthTask = taskMonth === currentMonth.toLowerCase() || taskMonth === ""; 

        if (isCurrentMonthTask) {
          // If query is empty, show all current month tasks
          if (query === "") {
            task.style.display = "block";
          } 
          // If query is not empty and the task title matches, show it
          else if (taskTitle.includes(query)) {
            task.style.display = "block";
          } 
          // Hide current month tasks that don't match the query
          else {
            task.style.display = "none";
          }
        } else {
          // Keep tasks from other months hidden
          task.style.display = "none";
        }
      });

      // Update progress after search
      updateProgress();
    });
  }


  // Initialize everything
  initializeAccordionsAndCheckboxes();

  // Default filter: current month
  filterTasksByMonth(selectedMonth);

  // Also, when page first loads, ensure progress is set
  updateProgress();
});
</script>

</body>
</html>
