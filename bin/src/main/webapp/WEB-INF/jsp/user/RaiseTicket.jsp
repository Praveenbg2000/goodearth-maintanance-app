<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Raise Maintenance Ticket</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 dark:bg-[#1F1D2B] text-gray-900 dark:text-gray-100 min-h-screen flex justify-center items-center">
  <div class="bg-white dark:bg-[#2D2A43] p-8 rounded-2xl shadow-lg w-[90%] max-w-lg">
    <h2 class="text-2xl font-semibold mb-4 text-center">Raise Ticket for ${param.task}</h2>
    
    <form action="${pageContext.request.contextPath}/user/submit-ticket" method="post" class="space-y-4">
      <input type="hidden" name="task" value="${param.task}">
      <textarea name="message" rows="5" required placeholder="Describe the issue faced..." 
        class="w-full p-3 rounded-lg border dark:border-gray-600 dark:bg-transparent"></textarea>

      <div class="flex justify-between items-center">
        <a href="${pageContext.request.contextPath}/user/dashboard" class="text-gray-500 hover:underline">← Back to Dashboard</a>
        <button type="submit" class="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-2 rounded-lg font-medium">Submit Ticket</button>
      </div>
    </form>
  </div>
</body>
</html>
