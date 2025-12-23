<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>My Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <style>
    body {
      font-family: 'Urbanist', sans-serif;
      transition: background-color 0.4s ease, color 0.4s ease;
    }
  
  </style>
</head>

<body class="bg-gray-50 dark:bg-[#1F1D2B] text-gray-900 dark:text-gray-100 min-h-screen flex flex-col items-center p-4 sm:p-6">

  <!-- 🔙 Back Button -->
  <div class="w-full max-w-3xl mb-6">
    <a href="${pageContext.request.contextPath}/user/dashboard"
       class="inline-flex items-center gap-2 text-yellow-500 hover:text-yellow-400 font-semibold transition">
      <span class="material-icons text-[20px]">arrow_back</span> Back to Dashboard
    </a>
  </div>

  <!-- 🧍 Profile Header -->
  <div class="text-center w-full max-w-3xl">
    <c:choose>
      <c:when test="${not empty user.profilePhoto}">
        <img src="${pageContext.request.contextPath}/user/photo/${user.profilePhoto}" 
             class="w-28 sm:w-32 h-28 sm:h-32 rounded-full border-4 border-yellow-400 mx-auto shadow-lg object-cover"/>
      </c:when>
      <c:otherwise>
        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
             class="w-28 sm:w-32 h-28 sm:h-32 rounded-full border-4 border-gray-400 mx-auto shadow-lg object-cover"/>
      </c:otherwise>
    </c:choose>

    <h1 class="mt-4 text-xl sm:text-2xl font-bold">${user.username}</h1>
    <p class="text-gray-500 text-sm sm:text-base">${user.email}</p>
  </div>

  <!-- 📋 Profile Details -->
  <div class="mt-6 bg-white dark:bg-[#2D2A43] rounded-2xl shadow-lg w-full max-w-3xl p-4 sm:p-6">
    <div class="overflow-x-auto">
      <table class="w-full text-left text-sm sm:text-base border-separate border-spacing-y-2">
        <tbody>
          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">Name</td>
            <td>${user.username}</td>
          </tr>
          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">Email</td>
            <td>${user.email}</td>
          </tr>
          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">Phone</td>
            <td>${user.phone}</td>
          </tr>
          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">Community</td>
            <td>${user.community}</td>
          </tr>

          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">Main Home</td>
            <td>
              <c:choose>
                <c:when test="${not empty user.homeName}">
                  ${user.homeName}
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </tr>

          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">🏡 Additional Homes</td>
            <td>
              <c:choose>
                <c:when test="${not empty homeNames}">
                  <div class="flex flex-wrap gap-2 mt-1">
                    <c:forEach var="h" items="${homeNames}">
                      <span class="bg-yellow-400 text-gray-800 px-3 py-1 rounded-full text-xs sm:text-sm font-medium">${h}</span>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </td>
          </tr>

          <tr>
            <td class="font-semibold py-2 pr-3 whitespace-nowrap">🏠 Total Homes</td>
            <td>
              <c:choose>
                <c:when test="${homeCount > 0}">
                  ${homeCount + 1} <!-- +1 for the main home -->
                </c:when>
                <c:otherwise>1</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

</body>
</html>
