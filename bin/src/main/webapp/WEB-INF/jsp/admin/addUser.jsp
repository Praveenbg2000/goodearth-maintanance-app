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

    .header a {
      color: white;
      text-decoration: none;
      font-weight: bold;
      margin-left: 15px;
    }

    .container {
      max-width: 1100px;
      margin: 40px auto;
      background: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.08);
      padding: 25px 30px;
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

    th {
      background-color: #f0f4f8;
    }

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
      animation: fadeIn 0.3s ease;
    }

    @keyframes fadeIn {
      from { transform: scale(0.95); opacity: 0; }
      to { transform: scale(1); opacity: 1; }
    }

    .close-btn {
      position: absolute;
      top: 10px; right: 15px;
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
      gap: 8px;
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
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 14px;
    }

    .tag span.remove {
      cursor: pointer;
      font-weight: bold;
      font-size: 16px;
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
      width: 100%;
    }

    .save-btn:hover {
      background-color: #005fa3;
    }

    .modal label {
      font-weight: 600;
      display: block;
      margin-top: 10px;
    }

    .primary-home-display {
      background: #eef6ff;
      border: 1px solid #cfe0f9;
      padding: 10px;
      border-radius: 6px;
      color: #0078d7;
      font-weight: bold;
      margin-top: 5px;
    }

    #homeMessage {
      color: #d9534f;
      font-weight: 500;
      margin-top: 6px;
      display: none;
      font-size: 14px;
    }
  </style>
</head>

<body>
<div class="header">
  <h2>Admin Dashboard</h2>
  <div>
    Welcome, <strong>${sessionScope.adminName}</strong> |
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
      <th>Profile</th>
    </tr>
    <c:forEach var="u" items="${users}">
      <tr onclick="openUserModal('${u.id}', '${u.username}', '${u.email}', '${u.phone}', '${u.community}', '${u.homeName}')">
        <td>${u.id}</td>
        <td>${u.username}</td>
        <td>${u.email}</td>
        <td>${u.phone}</td>
        <td>${u.community}</td>
        <td>
          <c:choose>
            <c:when test="${not empty u.profilePhoto}">
              <img src="${pageContext.request.contextPath}/user/photo/${u.id}" class="profile"/>
            </c:when>
            <c:otherwise>
              <img src="https://cdn.vectorstock.com/i/500p/50/89/female-profile-icon-woman-avatar-vector-31775089.jpg" class="profile"/>
            </c:otherwise>
          </c:choose>
        </td>
      </tr>
    </c:forEach>
  </table>
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

    <label>Primary Home</label>
    <div id="modalPrimaryHome" class="primary-home-display">—</div>

    <label>Add More Homes</label>
    <div id="homeTags" class="tag-container"></div>
    <input type="text" id="homeInput" placeholder="Type home name & press Enter" class="input-field">
    <div id="homeMessage">⚠️ Home already exists for this user.</div>

    <button class="save-btn" onclick="saveHomes()">Save Homes</button>
  </div>
</div>

<script>
  const modal = document.getElementById("userModal");
  const homeTagsContainer = document.getElementById("homeTags");
  const homeInput = document.getElementById("homeInput");
  const homeMessage = document.getElementById("homeMessage");
  const modalPrimaryHome = document.getElementById("modalPrimaryHome");
  let currentUserId = null;
  let homes = [];

  function openUserModal(id, username, email, phone, community, homeName) {
    modal.style.display = "flex";
    document.getElementById("modalUserId").value = id;
    document.getElementById("modalUsername").value = username;
    document.getElementById("modalEmail").value = email;
    document.getElementById("modalPhone").value = phone;
    modalPrimaryHome.textContent = homeName && homeName.trim() !== "" ? homeName : "—";
    currentUserId = id;
    homes = [];
    renderTags();
    homeMessage.style.display = "none";
  }

  function closeModal() {
    modal.style.display = "none";
    homes = [];
    homeTagsContainer.innerHTML = "";
    homeMessage.style.display = "none";
  }

  homeInput.addEventListener("keydown", async function(e) {
    if (e.key === "Enter" && this.value.trim() !== "") {
      e.preventDefault();
      const homeName = this.value.trim();

      // ✅ Check if already exists in DB
      const res = await fetch(`${"${pageContext.request.contextPath}"}/admin/check-home-exists?userId=${currentUserId}&homeName=${encodeURIComponent(homeName)}`);
      const result = await res.text();

      if (result === "EXISTS") {
        homeMessage.style.display = "block";
        homeMessage.innerHTML = `⚠️ Home <b>${homeName}</b> already exists for this user.`;
      } else {
        homeMessage.style.display = "none";
        homes.push(homeName);
        this.value = "";
        renderTags();
      }
    }
  });

  function renderTags() {
    homeTagsContainer.innerHTML = "";
    homes.forEach((home, index) => {
      const tag = document.createElement("div");
      tag.classList.add("tag");
      tag.innerHTML = `
        <span>${home}</span>
        <span class="remove" onclick="removeHome(${index})">&times;</span>
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
      alert("Please add at least one new home.");
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

  window.onclick = function(e) {
    if (e.target === modal) closeModal();
  };
</script>

</body>
</html>
