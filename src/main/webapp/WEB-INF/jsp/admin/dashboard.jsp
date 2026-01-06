<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>

<!-- Tailwind -->
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<script>
tailwind.config = {
  theme: {
    extend: {
      colors: {
        primary: "#3b82f6",
        primaryHover: "#2563eb",
        secondary: "#ef4444",
        secondaryHover: "#dc2626"
      },
      fontFamily: {
    	  sans: ["Poppins", "sans-serif"]
    	}

    }
  }
}
</script>

<style>

/* ===== RESPONSIVE SUSPEND TOGGLE ===== */
.check {
  position: relative;
  width: 56px;
  height: 28px;
  display: inline-block;
}

.check input {
  display: none;
}

/* Track */
.check label {
  display: block;
  width: 100%;
  height: 100%;
  background: #92de97;
  border-radius: 999px;
  transition: background 0.35s ease;
}

/* Knob */
.check label::after {
  content: "";
  position: absolute;
  top: 3px;
  left: 3px;
  width: 22px;
  height: 22px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 4px 8px rgba(0,0,0,0.25);
  transition: transform 0.35s ease;
}

/* Checked = Active */
.check input:checked + label {
  background: #ec8f8f;
}

.check input:checked + label::after {
  transform: translateX(28px);
}

/* Center inside table cell */
td .check {
  margin: auto;
}



.modal { display: none; }
.modal.show { display: flex; }
.tag {
  background: #3b82f6;
  color: #fff;
  padding: 6px 10px;
  border-radius: 9999px;
  display: flex;
  gap: 6px;
  align-items: center;
  font-size: 14px;
}
</style>
</head>

<body class="bg-gray-100 min-h-screen font-sans">

<!-- HEADER -->
<header class="bg-primary text-white shadow">
  <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
    <img src="${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg" style="width: 180px;">
    <nav class="flex gap-6 text-sm font-medium">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center gap-1 hover:opacity-80">
        <span class="material-icons text-base">dashboard</span> Dashboard
      </a>
      <c:if test="${sessionScope.adminEmail == 'marketing@goodearth.org.in'}">
  <a href="${pageContext.request.contextPath}/admin/manage"
     class="flex items-center gap-1 hover:opacity-80">
    <span class="material-icons text-base">admin_panel_settings</span>
    Manage Admin
  </a>
</c:if>

      <a href="#" onclick="openAddUserModal()" class="flex items-center gap-1 hover:opacity-80">
        <span class="material-icons text-base">person_add</span> Add User
      </a>
      <a href="${pageContext.request.contextPath}/admin/logout" class="flex items-center gap-1 hover:opacity-80">
        <span class="material-icons text-base">logout</span> Logout
      </a>
    </nav>
  </div>
</header>

<!-- MAIN -->
<main class="mx-auto py-8">

<div class="bg-white rounded-xl shadow border p-6">

<!-- TITLE + SEARCH -->
<div class="flex flex-col md:flex-row justify-between items-center gap-4 mb-6">
  <h2 class="text-xl font-semibold flex items-center gap-2">
    <span class="material-icons text-primary">people</span>
    Registered Users
  </h2>

  <div class="relative w-full md:w-64">
    <span class="material-icons absolute left-3 top-2.5 text-gray-400">search</span>
    <input id="searchInput" type="text" placeholder="Search users..."
           class="pl-10 w-full rounded-lg border-gray-300 focus:ring-primary focus:border-primary">
  </div>
</div>

<!-- TABLE -->
<div class="overflow-x-auto border rounded-lg">
<table id="userTable" class="min-w-full divide-y">
<thead class="bg-gray-100">
<tr>
<th class="px-4 py-3 text-left text-xs font-semibold">Username</th>
<th class="px-4 py-3 text-left text-xs font-semibold">Email</th>
<th class="px-4 py-3 text-left text-xs font-semibold">Phone</th>
<th class="px-4 py-3 text-left text-xs font-semibold">Community</th>
<th class="px-4 py-3 text-left text-xs font-semibold">Primary Home</th>
<th class="px-4 py-3 text-center text-xs font-semibold">Profile</th>
<th class="px-4 py-3 text-center text-xs font-semibold">Suspend</th>
<th class="px-4 py-3 text-center text-xs font-semibold">Remove</th>
</tr>
</thead>

<tbody class="divide-y">
<c:forEach var="u" items="${users}">
<tr onclick="openUserModal('${u.username}','${u.email}','${u.phone}','${u.community}','${u.homeName}')"
    class="hover:bg-gray-50 cursor-pointer">

  <td class="px-4 py-3 font-medium">${u.username}</td>
  <td class="px-4 py-3 text-gray-600">${u.email}</td>
  <td class="px-4 py-3 text-gray-600">${u.phone}</td>
  <td class="px-4 py-3 text-gray-600">${u.community}</td>

  <td class="px-4 py-3 text-primary font-semibold">
    <c:out value="${u.homeName != null ? u.homeName : '—'}"/>
  </td>

  <!-- PROFILE -->
  <td class="px-4 py-3 text-center">
    <c:choose>
      <c:when test="${not empty u.profilePhoto}">
        <img src="${pageContext.request.contextPath}/admin/uploads/${u.profilePhoto}"
             class="w-10 h-10 rounded-full object-cover mx-auto border">
      </c:when>
      <c:otherwise>
        <img src="https://cdn.vectorstock.com/i/500p/50/89/female-profile-icon-woman-avatar-vector-31775089.jpg"
             class="w-10 h-10 rounded-full mx-auto border">
      </c:otherwise>
    </c:choose>
  </td>

  <!-- ✅ SUSPEND -->
  <td class="px-4 py-3 text-center" onclick="event.stopPropagation()">
    <div class="check mx-auto">
      <input type="checkbox"
             id="suspend_${u.email}"
             <c:if test="${u.suspended}">checked</c:if>
             onchange="toggleSuspend('${u.email}', this.checked)">
      <label for="suspend_${u.email}"></label>
    </div>
  </td>

  <!-- ✅ DELETE -->
  <td class="px-4 py-3 text-center" onclick="event.stopPropagation()">
    <button onclick="openDeleteModal('${u.email}','${u.homeName}')"
            class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-xs">
      Delete
    </button>
  </td>

</tr>
</c:forEach>
</tbody>

</table>
</div>

<!-- ACTION BUTTONS -->
<div class="flex flex-wrap justify-center gap-4 mt-8">
<button onclick="openAddUserModal()" class="bg-primary hover:bg-primaryHover text-white px-6 py-2 rounded-lg flex items-center gap-2">
  <span class="material-icons text-sm">add</span> Add User
</button>
<a href="${pageContext.request.contextPath}/admin/add-task" class="bg-primary hover:bg-primaryHover text-white px-6 py-2 rounded-lg flex items-center gap-2">
  <span class="material-icons text-sm">add_task</span> Add Task
</a>
<a href="${pageContext.request.contextPath}/admin/logout" class="bg-secondary hover:bg-secondaryHover text-white px-6 py-2 rounded-lg flex items-center gap-2">
  <span class="material-icons text-sm">logout</span> Logout
</a>
</div>

</div>
</main>

<!-- ================= ADD USER MODAL ================= -->
<div id="addUserModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
<div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
<button onclick="closeAddUserModal()" class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
<span class="material-icons">close</span>
</button>

<h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
<span class="material-icons text-primary">person_add</span> Add New User
</h3>

<form id="addUserForm" enctype="multipart/form-data" class="space-y-4">
<input type="text" name="username" placeholder="Username" required class="w-full rounded-lg border-gray-300">
<input type="email" name="email" placeholder="Email" required class="w-full rounded-lg border-gray-300">
<input type="text" name="phone" placeholder="Phone" required class="w-full rounded-lg border-gray-300">
<input type="text" name="community" placeholder="Community" required class="w-full rounded-lg border-gray-300">
<input type="text" name="homeName" placeholder="Home Name" required class="w-full rounded-lg border-gray-300">
<button type="submit" class="w-full bg-primary hover:bg-primaryHover text-white py-2 rounded-lg font-medium">Save User</button>
</form>
</div>
</div>

<!-- ================= EDIT USER / ADD HOMES MODAL ================= -->
<div id="userModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
<div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
<button onclick="closeModal()" class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
<span class="material-icons">close</span>
</button>

<h3 class="text-lg font-semibold mb-4">Edit User & Add Homes</h3>
<input type="hidden" id="modalUserId">
<input id="modalUsername" readonly class="w-full mb-2 rounded-lg border-gray-300">
<input id="modalEmail" readonly class="w-full mb-2 rounded-lg border-gray-300">
<input id="modalPhone" readonly class="w-full mb-2 rounded-lg border-gray-300">

<div id="homeTags" class="flex flex-wrap gap-2 border rounded-lg p-2 mb-2"></div>
<input id="homeInput" placeholder="Type home name & press Enter"
       class="w-full rounded-lg border-gray-300">

<button onclick="saveHomes()" class="w-full bg-primary hover:bg-primaryHover text-white py-2 rounded-lg mt-4">
Save Homes
</button>
</div>
</div>


<!-- ================= DELETE CONFIRM MODAL ================= -->
<div id="deleteConfirmModal"
     class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">

  <div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 text-center">
    <h3 class="text-lg font-semibold text-red-600 mb-4">
      Confirm User Deletion
    </h3>

    <p class="text-gray-700 mb-2">
      Are you sure you want to permanently delete this user?
    </p>

    <div class="bg-gray-100 rounded-lg p-3 text-sm text-left mb-4">
      <p><strong>Email:</strong> <span id="deleteUserEmail"></span></p>
      <p><strong>Home:</strong> <span id="deleteUserHome"></span></p>
    </div>

    <div class="flex justify-center gap-4">
      <button onclick="closeDeleteModal()"
              class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400">
        Cancel
      </button>

      <button onclick="confirmDeleteUser()"
              class="px-4 py-2 rounded bg-red-500 hover:bg-red-600 text-white">
        Yes, Delete
      </button>
    </div>
  </div>
</div>

<!-- ================= DELETE SUCCESS MODAL ================= -->
<div id="deleteSuccessModal"
     class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">

  <div class="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 text-center">
    <span class="material-icons text-green-500 text-5xl mb-3">check_circle</span>
    <h3 class="text-lg font-semibold mb-3">User Deleted Successfully</h3>

    <button onclick="location.reload()"
            class="mt-4 px-6 py-2 rounded bg-primary hover:bg-primaryHover text-white">
      OK
    </button>
  </div>
</div>



<!-- ================= JS (UNCHANGED LOGIC) ================= -->
<script>

//Popup model script

let deleteEmail = "";
let deleteHome = "";

// OPEN MODAL
function openDeleteModal(email, homeName) {
  deleteEmail = email;
  deleteHome = homeName || "—";

  document.getElementById("deleteUserEmail").innerText = deleteEmail;
  document.getElementById("deleteUserHome").innerText = deleteHome;

  const modal = document.getElementById("deleteConfirmModal");
  modal.classList.remove("hidden");
  modal.classList.add("flex");
}

// CLOSE CONFIRM MODAL
function closeDeleteModal() {
  const modal = document.getElementById("deleteConfirmModal");
  modal.classList.add("hidden");
  modal.classList.remove("flex");
}

// CONFIRM DELETE
async function confirmDeleteUser() {
  closeDeleteModal();

  const res = await fetch("${pageContext.request.contextPath}/admin/delete-user", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      email: deleteEmail,
      homeName: deleteHome
    })
  });

  if (res.ok) {
    const successModal = document.getElementById("deleteSuccessModal");
    successModal.classList.remove("hidden");
    successModal.classList.add("flex");
  } else {
    alert("Failed to delete user");
  }
}



//DELETE USER
async function deleteUser(email, homeName) {
  if (!confirm("Are you sure you want to permanently delete this user?")) return;

  const res = await fetch("${pageContext.request.contextPath}/admin/delete-user", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ email, homeName })
  });

  if (res.ok) {
    alert("User deleted successfully");
    location.reload();
  } else {
    alert("Failed to delete user");
  }
}

// SUSPEND USER
async function toggleSuspend(email, status) {
  const res = await fetch("${pageContext.request.contextPath}/admin/suspend-user", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ email, status })
  });

  if (!res.ok) {
    alert("Failed to update suspend status");
  }
}



/* SEARCH */
document.getElementById("searchInput").addEventListener("keyup", function () {
  const filter = this.value.toLowerCase();
  document.querySelectorAll("#userTable tbody tr").forEach(row => {
    row.style.display = row.innerText.toLowerCase().includes(filter) ? "" : "none";
  });
});

/* ADD USER MODAL */
const addModal = document.getElementById("addUserModal");
function openAddUserModal(){ addModal.classList.remove("hidden"); addModal.classList.add("flex"); }
function closeAddUserModal(){ addModal.classList.add("hidden"); addModal.classList.remove("flex"); document.getElementById("addUserForm").reset(); }

document.getElementById("addUserForm").addEventListener("submit", async function(e){
e.preventDefault();
const res = await fetch("${pageContext.request.contextPath}/admin/add-user",{ method:"POST", body:new FormData(this)});
if(res.ok){ alert("User added successfully"); location.reload(); } else alert("User already added or try to add another records");
});

/* USER MODAL */
const modal = document.getElementById("userModal");
let homes=[], currentUserId=null;

function openUserModal(id,u,e,p){ modal.classList.remove("hidden"); modal.classList.add("flex");
currentUserId=id; homes=[]; renderTags();
document.getElementById("modalUserId").value=id;
document.getElementById("modalUsername").value=u;
document.getElementById("modalEmail").value=e;
document.getElementById("modalPhone").value=p;
}
function closeModal(){ modal.classList.add("hidden"); modal.classList.remove("flex"); }

document.getElementById("homeInput").addEventListener("keydown",e=>{
if(e.key==="Enter" && e.target.value.trim()){
e.preventDefault(); homes.push(e.target.value.trim()); e.target.value=""; renderTags();
}});

function renderTags(){
document.getElementById("homeTags").innerHTML="";
homes.forEach((h,i)=>{
const d=document.createElement("div");
d.className="tag"; d.innerHTML=`${h}<span onclick="removeHome(${i})" class="cursor-pointer">&times;</span>`;
document.getElementById("homeTags").appendChild(d);
});
}
function removeHome(i){ homes.splice(i,1); renderTags(); }

async function saveHomes(){
const data=new URLSearchParams(); data.append("userId",currentUserId);
homes.forEach(h=>data.append("homes",h));
const r=await fetch("${pageContext.request.contextPath}/admin/save-homes",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},body:data});
alert(await r.text()); closeModal();
}
</script>

</body>
</html>
