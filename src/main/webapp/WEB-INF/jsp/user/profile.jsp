<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
  <title>User Profile</title>
  <style>
    body { margin:0; font-family:'Segoe UI',sans-serif; background-color:#f5f6fa; }
    .header {
      background:#0078d7; color:white; padding:12px 20px;
      display:flex; justify-content:space-between; align-items:center;
    }
    .logout-link { color:white; text-decoration:none; font-weight:bold; }
    .container {
      max-width:900px; margin:30px auto; background:white;
      border-radius:12px; padding:25px 30px; box-shadow:0 4px 10px rgba(0,0,0,0.08);
    }
    h3 { color:#0078d7; }
    table { width:100%; border-collapse:collapse; margin-top:10px; }
    th,td { border:1px solid #ddd; padding:8px; text-align:left; }
    th { background:#f1f3f6; }
    button {
      background:#0078d7; color:white; border:none;
      padding:8px 16px; border-radius:5px; cursor:pointer;
    }
    button:hover { background:#005fa3; }
    .note-box {
      background:#eef6ff; border-left:4px solid #0078d7;
      padding:10px; border-radius:6px; margin-top:15px;
    }
  </style>
</head>
<body>

<div class="header">
  <h2>Hi, <c:out value="${viewerName != null ? viewerName : sessionScope.username}" /> 👋</h2>
  <a class="logout-link" href="${pageContext.request.contextPath}/user/logout">Logout</a>
</div>

<div class="container">
  <c:choose>
    <!-- Owner View -->
    <c:when test="${canAdd}">
      <h3>Edit My Profile</h3>
      <form action="${pageContext.request.contextPath}/user/update-profile" method="post" enctype="multipart/form-data">
        <p><strong>Name:</strong><br/><input type="text" name="name" value="${user.username}" required></p>
        <p><strong>Email:</strong><br/><input type="email" name="email" value="${user.email}" required></p>
        <p><strong>Phone:</strong><br/><input type="text" name="phone" value="${user.phone}" required></p>
        <p><strong>Profile Photo:</strong><br/><input type="file" name="profilePhoto" accept="image/*"></p>
        <button type="submit">Update Profile</button>
      </form>

      <hr/>
      <h3>Users Added Under This Owner</h3>
      <table>
        <tr><th>Photo</th><th>Name</th><th>Email</th><th>Phone</th><th>Relationship</th><th>Action</th></tr>
        <c:forEach var="a" items="${addedUsers}">
          <tr>
            <td>
              <c:if test="${not empty a.profilePhoto}">
                <img src="${pageContext.request.contextPath}/user/photo/${a.profilePhoto}" width="45" height="45" style="border-radius:50%;object-fit:cover;">
              </c:if>
            </td>
            <td>${a.name}</td>
            <td>${a.email}</td>
            <td>${a.phone}</td>
            <td>${a.relationship}</td>
            <td>
              <button type="button" onclick="confirmDelete(${a.id})">Delete</button>
            </td>
          </tr>
        </c:forEach>
      </table>

      <!-- OTP Section -->
      <div id="otp-section" style="display:none; margin-top:20px;">
        <h3>Enter OTP to Confirm Deletion</h3>
        <form id="otp-form" action="${pageContext.request.contextPath}/user/verify-delete-otp" method="post">
          <input type="text" name="otp" placeholder="Enter 6-digit OTP" maxlength="6" required>
          <button type="submit">Verify & Delete</button>
          <button type="button" onclick="cancelOtp()">Cancel</button>
        </form>
      </div>
    </c:when>

    <!-- Added User View -->
    <c:otherwise>
      <h3>My Profile</h3>
      <p><strong>Name:</strong> ${addedUser.name}</p>
      <p><strong>Email:</strong> ${addedUser.email}</p>
      <p><strong>Phone:</strong> ${addedUser.phone}</p>
      <p><strong>Relationship:</strong> ${addedUser.relationship}</p>
      <c:if test="${not empty addedUser.profilePhoto}">
        <img src="${pageContext.request.contextPath}/user/photo/${addedUser.profilePhoto}" width="100" style="border-radius:50%;">
      </c:if>
      <div class="note-box">⚠️ You are not allowed to edit or delete users.</div>
    </c:otherwise>
  </c:choose>
</div>

<script>
function confirmDelete(id) {
  if(confirm("Are you sure you want to delete this user? An OTP will be sent to your email.")) {
    fetch("${pageContext.request.contextPath}/user/send-delete-otp", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "addedUserId=" + id
    })
    .then(r => r.text())
    .then(msg => {
      alert(msg);
      document.getElementById("otp-section").style.display = "block";
    });
  }
}
function cancelOtp() {
  document.getElementById("otp-section").style.display = "none";
}
</script>
</body>
</html>
