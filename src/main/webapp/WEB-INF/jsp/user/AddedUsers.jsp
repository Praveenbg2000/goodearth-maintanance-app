<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="en">
<head>
  <title>Added Users</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <style>
  
    body {
      font-family: 'Urbanist', sans-serif;
      transition: background-color 0.4s ease, color 0.4s ease;
    }
    /* OTP input box style */
    .otp-input {
      width: 2.5rem;
      height: 2.5rem;
      text-align: center;
      font-size: 1.25rem;
      margin: 0 0.25rem;
      border: 2px solid #ccc;
      border-radius: 0.5rem;
      outline: none;
      transition: all 0.2s ease-in-out;
    }
    .otp-input:focus {
      border-color: #facc15;
      box-shadow: 0 0 4px #facc15;
    }
  </style>
</head>

<body class="bg-gray-50 dark:bg-[#1F1D2B] text-gray-900 dark:text-gray-100 min-h-screen p-4 sm:p-6">

  <!-- 🔙 Back to Dashboard -->
  <div class="w-full max-w-5xl mb-6">
    <a href="${pageContext.request.contextPath}/user/dashboard"
       class="inline-flex items-center gap-2 text-yellow-500 hover:text-yellow-400 font-semibold transition">
      <span class="material-icons text-[20px]">arrow_back</span> Back to Dashboard
    </a>
  </div>

  <!-- 👥 Added Users -->
  <h1 class="text-2xl sm:text-3xl font-bold mb-6 text-center sm:text-left">Added Users</h1>

  <div class="bg-white dark:bg-[#2D2A43] p-4 sm:p-6 rounded-2xl shadow-lg w-full max-w-5xl mx-auto overflow-x-auto">
    <table class="w-full text-sm sm:text-base text-left">
      <thead class="bg-gray-100 dark:bg-[#1F1D2B]/60 text-gray-700 dark:text-gray-300">
        <tr>
          <th class="px-3 sm:px-4 py-2 whitespace-nowrap">Photo</th>
          <th class="px-3 sm:px-4 py-2">Name</th>
          <th class="px-3 sm:px-4 py-2">Email</th>
          <th class="px-3 sm:px-4 py-2">Phone</th>
          <th class="px-3 sm:px-4 py-2">Relationship</th>
          <th class="px-3 sm:px-4 py-2 text-center">Action</th>
        </tr>
      </thead>
      <tbody id="userTableBody">
        <c:forEach var="a" items="${addedUsers}">
          <tr class="border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-[#1F1D2B]/60 transition">
            <td class="px-3 sm:px-4 py-2 text-center">
              <c:choose>
                <c:when test="${not empty a.profilePhoto}">
                  <img src="${pageContext.request.contextPath}/user/photo/${a.profilePhoto}"
                       width="40" height="40" class="rounded-full object-cover mx-auto sm:mx-0">
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
            <td class="px-3 sm:px-4 py-2">${a.name}</td>
            <td class="px-3 sm:px-4 py-2">${a.email}</td>
            <td class="px-3 sm:px-4 py-2">${a.phone}</td>
            <td class="px-3 sm:px-4 py-2">${a.relationship}</td>
            <td class="px-3 sm:px-4 py-2 text-center">
              <button onclick="openOtpModal(${a.id})"
                      class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-xs sm:text-sm transition">
                Delete
              </button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>   
  </div>

  <!-- ✅ Success Message (Hidden Initially) -->
  <div id="successMessage" class="text-green-500 text-center font-semibold mt-4 hidden">
    User added successfully!
  </div>

  <!-- ➕ Add User Button -->
  <div class="flex flex-col sm:flex-row justify-between items-center mb-4 gap-3 mt-6" style="width:100%; display: flex; flex-direction: row; justify-content: center;">
    <button onclick="openAddModal()" 
            class="bg-yellow-400 text-gray-800 font-semibold py-4 px-4 
                 rounded-full shadow-md focus:outline-none hover:opacity-90">
      + Add User
    </button>
  </div>

  <!-- 🧾 Add User Modal -->
  <div id="addModal" class="fixed inset-0 bg-black/50 hidden flex items-center justify-center z-50">
    <div class="bg-white dark:bg-[#2D2A43] p-6 rounded-2xl shadow-xl w-[90%] max-w-md">
      <h3 class="text-lg font-semibold mb-4">Add New User</h3>

      <form id="addUserForm"
            action="${pageContext.request.contextPath}/user/add-related"
            method="post"
            enctype="multipart/form-data"
            class="space-y-3">

        <input type="text" name="name" placeholder="Name" required
               class="w-full rounded-lg p-2 border dark:bg-transparent dark:border-gray-600"/>

        <input type="email" name="email" placeholder="Email" required
               class="w-full rounded-lg p-2 border dark:bg-transparent dark:border-gray-600"/>

        <input type="text" name="phone" placeholder="Phone" required
               class="w-full rounded-lg p-2 border dark:bg-transparent dark:border-gray-600"/>

        <input type="text" name="relationship" placeholder="Relationship" required
               class="w-full rounded-lg p-2 border dark:bg-transparent dark:border-gray-600"/>

        <input type="file" name="profilePhoto" accept="image/*" class="w-full"/>

        <div class="flex justify-end gap-2 mt-3">
          <button type="button"
                  onclick="closeAddModal()"
                  class="px-4 py-2 rounded-lg bg-gray-300 dark:bg-gray-600 text-gray-800 dark:text-gray-200">
            Cancel
          </button>

          <button type="submit"
                  class="px-4 py-2 rounded-lg bg-blue-500 hover:bg-blue-600 text-white">
            Add
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- 🔐 OTP Modal -->
  <div id="otpModal" class="fixed inset-0 bg-black/50 hidden flex items-center justify-center z-50">
    <div class="bg-white dark:bg-[#2D2A43] p-6 rounded-2xl shadow-xl w-[90%] max-w-md text-center">
      <h3 class="text-lg font-semibold mb-3">Verify OTP</h3>
      <p class="text-sm text-gray-500 dark:text-gray-400 mb-3">
        Enter the 6-digit OTP sent to your email.
      </p>

      <!-- OTP 6 Boxes -->
      <div class="flex justify-center mb-4">
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
        <input type="text" maxlength="1" class="otp-input" style="color:black;" />
      </div>

      <div id="messageBox" class="hidden text-sm font-semibold mb-2"></div>

      <div class="flex justify-center gap-2">
        <button onclick="verifyOtp()"
                class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg">
          Verify & Delete
        </button>
        <button onclick="closeOtpModal()"
                class="bg-gray-400 hover:bg-gray-500 text-white px-4 py-2 rounded-lg">
          Cancel
        </button>
      </div>
    </div>
  </div>

  <!-- 🧠 Scripts -->
  <script>
    let selectedUserId = null;

    function openAddModal() {
      document.getElementById('addModal').classList.remove('hidden');
    }
    function closeAddModal() {
      document.getElementById('addModal').classList.add('hidden');
    }

    // 🟩 Show success message after form submit (without redirect)
    document.getElementById("addUserForm").addEventListener("submit", function (e) {
      e.preventDefault(); // stop redirect
      const formData = new FormData(this);

      fetch(this.action, {
        method: "POST",
        body: formData
      })
      .then(res => res.text())
      .then(() => {
        closeAddModal();
        document.getElementById("successMessage").classList.remove("hidden");
        setTimeout(() => document.getElementById("successMessage").classList.add("hidden"), 3000);
      })
      .catch(() => alert("❌ Failed to add user"));
    });

    // OTP Modal functions
    function openOtpModal(id) {
      selectedUserId = id;
      document.getElementById('otpModal').classList.remove('hidden');
      fetch("${pageContext.request.contextPath}/user/send-delete-otp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "addedUserId=" + id
      })
      .then(r => r.text())
      .then(msg => console.log("OTP sent:", msg))
      .catch(() => alert("❌ Failed to send OTP"));
    }

    function closeOtpModal() {
      document.getElementById('otpModal').classList.add('hidden');
      document.querySelectorAll('.otp-input').forEach(i => i.value = '');
      document.getElementById('messageBox').classList.add('hidden');
    }

    function verifyOtp() {
      const otpInputs = [...document.querySelectorAll(".otp-input")];
      const otp = otpInputs.map(i => i.value).join('');
      const msg = document.getElementById("messageBox");

      if (otp.length !== 6) {
        msg.innerText = "Enter all 6 digits";
        msg.className = "text-red-500";
        msg.classList.remove('hidden');
        return;
      }

      fetch("${pageContext.request.contextPath}/user/verify-delete-otp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "otp=" + otp + "&addedUserId=" + selectedUserId
      })
      .then(r => r.text())
      .then(t => {
        if (t.includes("successfully")) {
          msg.innerText = "✅ User deleted successfully!";
          msg.className = "text-green-500";
          msg.classList.remove('hidden');
          setTimeout(() => {
            document.querySelector(`button[onclick="openOtpModal(${selectedUserId})"]`)
              ?.closest("tr")?.remove();
            closeOtpModal();
          }, 1000);
        } else {
          throw new Error(t);
        }
      })
      .catch(() => {
        msg.innerText = "❌ Invalid OTP";
        msg.className = "text-red-500";
        msg.classList.remove('hidden');
      });
    }

    // Auto move between OTP boxes
    document.addEventListener("input", function(e) {
      if (e.target.classList.contains("otp-input") && e.target.value) {
        const next = e.target.nextElementSibling;
        if (next && next.classList.contains("otp-input")) next.focus();
      }
    });
  </script>
</body>
</html>
