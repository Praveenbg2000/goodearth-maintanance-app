<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:choose>
  <c:when test="${not empty tasks}">
    <ul>
      <c:forEach var="task" items="${tasks}">
        <li><strong>${task.title}</strong> - ${task.description}</li>
      </c:forEach>
    </ul>
  </c:when>
  <c:otherwise>
    <p>No tasks found for this month.</p>
  </c:otherwise>
</c:choose>
