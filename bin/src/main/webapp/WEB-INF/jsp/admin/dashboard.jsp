<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
  <title>Admin Dashboard</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f5f6fa;
      margin: 0;
      padding: 0;
    }

    .header {
      background-color: #0078d7;
      color: white;
      padding: 15px 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .nav-links a {
      color: white;
      text-decoration: none;
      font-weight: bold;
      margin-left: 20px;
    }

    .nav-links a:hover {
      text-decoration: underline;
    }

    .container {
      max-width: 1100px;
      margin: 40px auto;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.08);
      padding: 25px 30px;
    }

    .add-btn {
      background-color: #0078d7;
      color: white;
      border: none;
      padding: 10px 18px;
      border-radius: 8px;
      font-weight: bold;
      cursor: pointer;
      margin-bottom: 15px;
      text-decoration: none;
      display: inline-block;
    }

    .add-btn:hover { background-color: #005fa3; }

    .footer-actions {
      margin-top: 30px;
      text-align: center;
    }

    .footer-actions .add-btn {
      margin: 0 10px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    th, td {
      padding: 10px;
      border-bottom: 1px solid #e0e0e0;
      text-align: left;
    }

    th { background-color: #f0f4f8; }

    tr:hover {
      background-color: #eef6ff;
      cursor: pointer;
    }

    .profile {
      width: 50px;
      height: 50px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #0078d7;
    }

    /* Modal Styling */
    .modal {
      display: none;
      position: fixed;
      z-index: 999;
      left: 0; top: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.5);
      justify-content: center;
      align-items: center;
    }

    .modal-content {
      background: #fff;
      border-radius: 10px;
      width: 500px;
      padding: 25px;
      position: relative;
      box-shadow: 0 4px 15px rgba(0,0,0,0.3);
    }

    .close-btn {
      position: absolute;
      top: 10px;
      right: 15px;
      font-size: 22px;
      cursor: pointer;
      color: #666;
    }

    .input-field {
      width: 100%;
      padding: 8px;
      margin: 5px 0;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    .tag-container {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-top: 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 8px;
      min-height: 40px;
    }

    .tag {
      background: #0078d7;
      color: white;
      padding: 6px 10px;
      border-radius: 15px;
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 14px;
    }

    .tag span {
      cursor: pointer;
      font-weight: bold;
    }

    .save-btn {
      background: #0078d7;
      color: white;
      border: none;
      padding: 10px 16px;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 15px;
    }

    .save-btn:hover {
      background-color: #005fa3;
    }

    .primary-home {
      color: #0078d7;
      font-weight: 600;
    }
  </style>
</head>

<body>
<div class="header">
  <h2>Admin Dashboard</h2>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
    <a href="#" onclick="openAddUserModal()">Add User</a>
    <a href="${pageContext.request.contextPath}/admin/add-task">Add Task</a>
    <a href="${pageContext.request.contextPath}/admin/logout">Logout</a>
  </div>
</div>

<div class="container">
  <h3>Registered Users</h3>
  <table id="userTable">
    <tr>
      <th>ID</th>
      <th>Username</th>
      <th>Email</th>
      <th>Phone</th>
      <th>Community</th>
      <th>Primary Home</th>
      <th>Profile</th>
    </tr>
    <c:forEach var="u" items="${users}">
      <tr onclick="openUserModal('${u.id}', '${u.username}', '${u.email}', '${u.phone}', '${u.community}', '${u.homeName}')">
        <td>${u.id}</td>
        <td>${u.username}</td>
        <td>${u.email}</td>
        <td>${u.phone}</td>
        <td>${u.community}</td>
        <td class="primary-home">
          <c:out value="${u.homeName != null ? u.homeName : '—'}" />
        </td>
        <td>
          <c:choose>
            <c:when test="${not empty u.profilePhoto}">
              <img src="${pageContext.request.contextPath}/admin/uploads/${u.profilePhoto}" class="profile"/>
            </c:when>
            <c:otherwise>
              <img src="https://cdn.vectorstock.com/i/500p/50/89/female-profile-icon-woman-avatar-vector-31775089.jpg" class="profile"/>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
  </table>

  <!-- Footer action buttons -->
  <div class="footer-actions">
    <button class="add-btn" onclick="openAddUserModal()">+ Add User</button>
    <a href="${pageContext.request.contextPath}/admin/add-task" class="add-btn">+ Add Task</a>
    <a href="${pageContext.request.contextPath}/admin/logout" class="add-btn" style="background:#dc3545;">Logout</a>
  </div>
</div>


<!-- 🟢 User Modal -->
<div class="modal" id="userModal">
  <div class="modal-content">
    <span class="close-btn" onclick="closeModal()">&times;</span>
    <h3>Edit User & Add Homes</h3>

    <input type="hidden" id="modalUserId">
    <label>Username</label>
    <input type="text" id="modalUsername" class="input-field" readonly>

    <label>Email</label>
    <input type="text" id="modalEmail" class="input-field" readonly>

    <label>Phone</label>
    <input type="text" id="modalPhone" class="input-field" readonly>

    <label>Add Homes</label>
    <div id="homeTags" class="tag-container"></div>
    <input type="text" id="homeInput" placeholder="Type home name & press Enter" class="input-field">

    <button class="save-btn" onclick="saveHomes()">Save Homes</button>
  </div>
</div>

<!-- 🟢 Add User Modal -->
<div class="modal" id="addUserModal">
  <div class="modal-content">
    <span class="close-btn" onclick="closeAddUserModal()">&times;</span>
    <h3>Add New User</h3>

    <form id="addUserForm" enctype="multipart/form-data">
      <label>Username</label>
      <input type="text" name="username" class="input-field" required>

      <label>Email</label>
      <input type="email" name="email" class="input-field" required>

      <label>Phone</label>
      <input type="text" name="phone" class="input-field" required>

      <label>Community</label>
      <input type="text" name="community" class="input-field" required>

      <label>Home Name</label>
      <input type="text" name="homeName" class="input-field" required>

      <label>Profile Photo</label>
      <input type="file" name="profilePhoto" accept="image/*" class="input-field">

      <button type="submit" class="save-btn">Save User</button>
    </form>
  </div>
</div>

<script>
  const addModal = document.getElementById("addUserModal");

  function openAddUserModal() {
    addModal.style.display = "flex";
  }

  function closeAddUserModal() {
    addModal.style.display = "none";
    document.getElementById("addUserForm").reset();
  }

  // Submit form via AJAX
  document.getElementById("addUserForm").addEventListener("submit", async function(e) {
    e.preventDefault();
    const formData = new FormData(this);

    const response = await fetch("${pageContext.request.contextPath}/admin/add-user", {
      method: "POST",
      body: formData
    });

    if (response.ok) {
      alert("User added successfully!");
      closeAddUserModal();
      location.reload();
    } else {
      alert("Error adding user.");
    }
  });

  // Close modal when clicking outside
  window.onclick = function(e) {
    if (e.target === addModal) closeAddUserModal();
    if (e.target === modal) closeModal();
  };
</script>

<script>
  const modal = document.getElementById("userModal");
  const homeTagsContainer = document.getElementById("homeTags");
  const homeInput = document.getElementById("homeInput");
  let currentUserId = null;
  let homes = [];

  function openUserModal(id, username, email, phone, community, homeName) {
    modal.style.display = "flex";
    document.getElementById("modalUserId").value = id;
    document.getElementById("modalUsername").value = username;
    document.getElementById("modalEmail").value = email;
    document.getElementById("modalPhone").value = phone;
    currentUserId = id;
    homes = [];
    renderTags();
  }

  function closeModal() {
    modal.style.display = "none";
    homes = [];
    homeTagsContainer.innerHTML = "";
  }

  homeInput.addEventListener("keydown", function(e) {
    if (e.key === "Enter" && this.value.trim() !== "") {
      e.preventDefault();
      const value = this.value.trim();
      homes.push(value);
      this.value = "";
      renderTags();
    }
  });

  function renderTags() {
    homeTagsContainer.innerHTML = "";
    homes.forEach((home, index) => {
      const tag = document.createElement("div");
      tag.classList.add("tag");
      tag.innerHTML = `
        <span>${home}</span>
        <span onclick="removeHome(${index})">&times;</span>
      `;
      homeTagsContainer.appendChild(tag);
    });
  }

  function removeHome(index) {
    homes.splice(index, 1);
    renderTags();
  }

  async function saveHomes() {
    if (homes.length === 0) {
      alert("Please add at least one home.");
      return;
    }

    const formData = new URLSearchParams();
    formData.append("userId", currentUserId);
    homes.forEach(h => formData.append("homes", h));

    const res = await fetch("${pageContext.request.contextPath}/admin/save-homes", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: formData
    });

    const msg = await res.text();
    alert(msg);
    closeModal();
  }
</script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>

<script>
  var socket = new SockJS('/ws');
  var stompClient = Stomp.over(socket);

  stompClient.connect({}, function () {
    // Replace 'taskId' dynamically from backend variable
    var taskId = '${task.id}';
    stompClient.subscribe('/topic/task-updates/' + taskId, function (update) {
      var data = JSON.parse(update.body);
      updateTaskProgressUI(data);
    });
  });

  function updateTaskProgressUI(data) {
    var bar = document.getElementById('progress-' + data.taskId);
    if (bar) {
      bar.style.width = data.progress + '%';
      bar.innerText = data.progress + '%';
    }
  }
</script>


</body>
</html>

