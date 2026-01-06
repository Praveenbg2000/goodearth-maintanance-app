<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
String adminEmail = (String) session.getAttribute("adminEmail");
if (adminEmail == null || 
    !adminEmail.equalsIgnoreCase("marketing@goodearth.org.in")) {
    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    return;
}
%>



<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Admin</title>

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
</head>

<body class="bg-gray-100 min-h-screen font-sans">

<!-- ================= HEADER ================= -->
<header class="bg-primary text-white shadow">
  <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
    <img src="${pageContext.request.contextPath}/images/GoodEarth-White-logo.svg" style="width:180px">

    <nav class="flex gap-6 text-sm font-medium">
      <a href="${pageContext.request.contextPath}/admin/dashboard" class="hover:opacity-80">
  		<span class="material-icons text-base">dashboard</span> Dashboard
	  </a>

      <a href="${pageContext.request.contextPath}/admin/manage" class="hover:opacity-80">
      	<span class="material-icons text-base">admin_panel_settings</span>Manage Admin
	  </a>

      <a href="${pageContext.request.contextPath}/admin/logout" class="hover:opacity-80">
        <span class="material-icons text-base">logout</span> Logout
      </a>
    </nav>
  </div>
</header>

<!-- ================= MAIN ================= -->
<main class="max-w-6xl mx-auto py-8 px-4">

<div class="bg-white rounded-xl shadow border p-6">

<!-- TITLE -->
<div class="flex justify-between items-center mb-6">
  <h2 class="text-xl font-semibold flex items-center gap-2">
    <span class="material-icons text-primary">admin_panel_settings</span>
    Admin Accounts
  </h2>

  <button onclick="openAddAdminModal()"
          class="bg-primary hover:bg-primaryHover text-white px-5 py-2 rounded-lg flex items-center gap-2">
    <span class="material-icons text-sm">add</span>
    Add Admin
  </button>
</div>

<!-- TABLE -->
<div class="overflow-x-auto border rounded-lg">
<table class="min-w-full divide-y">
<thead class="bg-gray-100">
<tr>
  <th class="px-4 py-3 text-left text-xs font-semibold">Name</th>
  <th class="px-4 py-3 text-left text-xs font-semibold">Email</th>
  <th class="px-4 py-3 text-left text-xs font-semibold">Password</th>
  <th class="px-4 py-3 text-center text-xs font-semibold">Edit Admin</th>
  <th class="px-4 py-3 text-center text-xs font-semibold">Delete</th>
 </tr>
</thead>

<tbody class="divide-y">
<c:forEach var="a" items="${admins}">
<tr class="hover:bg-gray-50">

  <td class="px-4 py-3 font-medium">${a.name}</td>
  <td class="px-4 py-3 text-gray-600">${a.email}</td>
  <td class="px-4 py-3 text-gray-600">${a.password}</td>

  <!-- EDIT ICON -->
  <td class="px-4 py-3 text-center">
    <button
      onclick="openEditAdminModal('${a.id}','${a.name}','${a.email}','${a.password}')"
      class="text-primary hover:text-primaryHover"
      title="Edit Admin">
      <span class="material-icons text-lg">edit</span>
    </button>
  </td>

  <!-- DELETE ICON -->
  <td class="px-4 py-3 text-center">
    <button
      onclick="deleteAdmin('${a.id}')"
      class="text-red-600 hover:text-red-800"
      title="Delete Admin">
      <span class="material-icons text-lg">delete</span>
    </button>
  </td>

</tr>
</c:forEach>
</tbody>


</div>

</div>
</main>

<!-- ================= ADD ADMIN MODAL ================= -->
<div id="addAdminModal"
     class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">

  <div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
    <button onclick="closeAddAdminModal()"
            class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
      <span class="material-icons">close</span>
    </button>

    <h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
      <span class="material-icons text-primary">person_add</span>
      Add New Admin
    </h3>

    <form id="addAdminForm" class="space-y-4">
      <input name="name" placeholder="Name" required
             class="w-full rounded-lg border-gray-300">

      <input name="email" type="email" placeholder="Email" required
             class="w-full rounded-lg border-gray-300">

      <input name="password" type="password" placeholder="Password" required
             class="w-full rounded-lg border-gray-300">

      <button class="w-full bg-primary hover:bg-primaryHover text-white py-2 rounded-lg font-medium">
        Save Admin
      </button>
    </form>
  </div>
</div>


<!-- ================= EDIT ADMIN MODAL ================= -->
<div id="editAdminModal"
     class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">

  <div class="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
    <button onclick="closeEditAdminModal()"
            class="absolute top-3 right-3 text-gray-400 hover:text-gray-600">
      <span class="material-icons">close</span>
    </button>

    <h3 class="text-lg font-semibold mb-4 flex items-center gap-2">
      <span class="material-icons text-primary">edit</span>
      Edit Admin
    </h3>

    <form id="editAdminForm" class="space-y-4">

      <input type="hidden" name="id" id="editAdminId">

      <input name="name" id="editAdminName"
             placeholder="Name" required
             class="w-full rounded-lg border-gray-300">

      <input name="email" id="editAdminEmail"
             type="email" placeholder="Email" required
             class="w-full rounded-lg border-gray-300">

      <input name="password" id="editAdminPassword"
             type="text" placeholder="Password" required
             class="w-full rounded-lg border-gray-300">

      <button class="w-full bg-primary hover:bg-primaryHover text-white py-2 rounded-lg font-medium">
        Confirm Edit
      </button>

    </form>
  </div>
</div>


<!-- ================= JS ================= -->
<script>

function deleteAdmin(adminId) {
    if (!confirm("Are you sure you want to delete this admin?")) {
        return;
    }

    fetch("/admin/delete-admin", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "id=" + adminId
    })
    .then(res => res.text())
    .then(data => {
        alert("Admin deleted successfully");
        location.reload();
    })
    .catch(err => {
        console.error(err);
        alert("Failed to delete admin");
    });
}



const addAdminModal = document.getElementById("addAdminModal");

function openAddAdminModal() {
  addAdminModal.classList.remove("hidden");
  addAdminModal.classList.add("flex");
}

function closeAddAdminModal() {
  addAdminModal.classList.add("hidden");
  addAdminModal.classList.remove("flex");
  document.getElementById("addAdminForm").reset();
}

document.getElementById("addAdminForm").addEventListener("submit", async e => {
  e.preventDefault();

  const res = await fetch(
    "${pageContext.request.contextPath}/admin/add-admin",
    { method: "POST", body: new FormData(e.target) }
  );

  if (res.ok) {
    alert("Admin added successfully");
    location.reload();
  } else {
    alert(await res.text());
  }
});

//admin edit script

const editAdminModal = document.getElementById("editAdminModal");

function openEditAdminModal(id, name, email, password) {
  document.getElementById("editAdminId").value = id;
  document.getElementById("editAdminName").value = name;
  document.getElementById("editAdminEmail").value = email;
  document.getElementById("editAdminPassword").value = password;

  editAdminModal.classList.remove("hidden");
  editAdminModal.classList.add("flex");
}

function closeEditAdminModal() {
  editAdminModal.classList.add("hidden");
  editAdminModal.classList.remove("flex");
}

document.getElementById("editAdminForm").addEventListener("submit", async e => {
  e.preventDefault();

  const res = await fetch(
    "${pageContext.request.contextPath}/admin/update-admin",
    { method: "POST", body: new FormData(e.target) }
  );

  if (res.ok) {
    alert("Admin updated successfully");
    location.reload();
  } else {
    alert(await res.text());
  }
});


</script>

</body>
</html>
