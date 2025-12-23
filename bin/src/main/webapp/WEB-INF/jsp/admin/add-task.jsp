<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<title>Admin - Add Monthly Task</title>
<style>
    body { font-family: 'Segoe UI', sans-serif; background: #f5f6fa; margin: 0; }
    .header { background: #0078d7; color: white; padding: 15px 25px; display: flex; justify-content: space-between; }
    .header a { color: white; text-decoration: none; font-weight: bold; margin-left: 15px; }
    .container { max-width: 900px; margin: 30px auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .input-field, textarea, select { width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ccc; border-radius: 6px; }
    .btn { background: #0078d7; color: white; border: none; padding: 10px 18px; border-radius: 6px; cursor: pointer; font-weight: bold; }
    .btn:hover { background: #005fa3; }
    .cancel-btn { background: #6c757d; }
    .cancel-btn:hover { background: #5a6268; }
    .step-group { border: 1px solid #ddd; padding: 10px; border-radius: 8px; margin-top: 10px; background: #fafafa; }
    .action-icons { display: flex; justify-content: flex-end; gap: 8px; margin-top: 5px; }
    .add-step, .remove-step { cursor: pointer; font-size: 20px; font-weight: bold; padding: 4px 10px; border-radius: 50%; color: white; }
    .add-step { background: #28a745; } .add-step:hover { background: #218838; }
    .remove-step { background: #dc3545; } .remove-step:hover { background: #c82333; }
    #stepSection { display: none; margin-top: 30px; }
</style>
</head>
<body>

<div class="header">
    <h2>Admin - Manage Monthly Tasks</h2>
    <div>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/add-task">Add Task</a>
        <a href="${pageContext.request.contextPath}/admin/logout">Logout</a>
    </div>
</div>

<div class="container">
    <!-- STEP 1: Task Form -->
    <div id="taskSection">
        <h3>Add New Task</h3>
        <form id="taskForm">
            <label>Month</label>
            <select name="month" id="month" class="input-field" required>
                <option value="">-- Select Month --</option>
               <c:set var="months" value="January,February,March,April,May,June,July,August,September,October,November,December" />
<c:forEach var="m" items="${fn:split(months, ',')}">
    <option value="${m}">${m}</option>
</c:forEach>
            </select>

            <label>Task Title</label>
            <input type="text" name="title" id="title" class="input-field" required>

            <label>Description</label>
            <textarea name="description" id="description" rows="3" required></textarea>

            <label>Materials / Finish</label>
            <textarea name="materialsFinish" id="materialsFinish" rows="2"></textarea>

            <label>Task Image URL (Optional)</label>
            <input type="text" name="taskImage" id="taskImage" class="input-field">

            <button type="button" class="btn" onclick="submitTask()">Next ➜</button>
        </form>
    </div>

    <!-- STEP 2: Task Steps Form -->
    <div id="stepSection">
        <h3>Add Steps for Task</h3>
        <div id="stepsContainer">
            <div class="step-group">
                <label>Step Order</label>
                <input type="number" name="steps[0].stepOrder" value="1" required>

                <label>Step Text</label>
                <textarea name="steps[0].stepText" required></textarea>

                <label>Step Image URL (Optional)</label>
                <input type="text" name="steps[0].stepImage" class="input-field" placeholder="Enter image URL">

                <div class="action-icons">
                    <span class="add-step" onclick="addStep()">+</span>
                    <span class="remove-step" onclick="removeStep(this)">−</span>
                </div>
            </div>
        </div>

        <div style="margin-top:15px;">
            <button type="button" class="btn" onclick="submitSteps()">Submit Task ✅</button>
            <button type="button" class="btn cancel-btn" onclick="cancelStep()">Cancel</button>
        </div>
    </div>
</div>

<script>
let taskId = null;
let stepCount = 1;

// ✅ STEP 1 - Submit basic task info
async function submitTask() {
    const form = document.getElementById("taskForm");
    const formData = new FormData(form);

    const response = await fetch("${pageContext.request.contextPath}/admin/save-task-basic", {
        method: "POST",
        body: formData
    });

    const result = await response.json();
    if (result.success) {
        taskId = result.taskId;
        document.getElementById("taskSection").style.display = "none";
        document.getElementById("stepSection").style.display = "block";
    } else {
        alert("⚠️ " + result.message);
    }
}

// ✅ Add new step dynamically
function addStep() {
    const container = document.getElementById("stepsContainer");
    const newDiv = document.createElement("div");
    newDiv.className = "step-group";
    newDiv.innerHTML = `
        <label>Step Order</label>
        <input type="number" name="steps[${stepCount}].stepOrder" value="${stepCount + 1}" required>
        <label>Step Text</label>
        <textarea name="steps[${stepCount}].stepText" required></textarea>
        <label>Step Image URL (optional)</label>
        <input type="text" name="steps[${stepCount}].stepImage" class="input-field">
        <div class="action-icons">
            <span class="add-step" onclick="addStep()">+</span>
            <span class="remove-step" onclick="removeStep(this)">−</span>
        </div>`;
    container.appendChild(newDiv);
    stepCount++;
}

function removeStep(btn) {
    const group = btn.closest(".step-group");
    const container = document.getElementById("stepsContainer");
    if (container.children.length > 1) container.removeChild(group);
}

// ✅ STEP 2 - Submit steps
// ✅ STEP 2 - Submit steps (fixed to handle multiple)
async function submitSteps() {
    if (!taskId) {
        alert("❌ Task ID missing.");
        return;
    }

    const stepContainer = document.getElementById("stepsContainer");
    const stepGroups = stepContainer.querySelectorAll(".step-group");

    if (stepGroups.length === 0) {
        alert("⚠️ Please add at least one step.");
        return;
    }

    const formData = new FormData();
    formData.append("taskId", taskId);

    stepGroups.forEach((group, index) => {
        const stepText = group.querySelector("textarea[name^='steps']").value.trim();
        const stepImage = group.querySelector("input[name^='steps'][name$='.stepImage']").value.trim();

        if (stepText !== "") {
            formData.append(`steps[${index}].stepText`, stepText);
            formData.append(`steps[${index}].stepImage`, stepImage);
        }
    });

    const response = await fetch("${pageContext.request.contextPath}/admin/save-task-steps", {
        method: "POST",
        body: formData
    });

    const result = await response.text();
    alert(result);
    if (result.includes("✅")) window.location.reload();
}


// Cancel step section
function cancelStep() {
    document.getElementById("stepSection").style.display = "none";
    document.getElementById("taskSection").style.display = "block";
}
</script>

</body>
</html>
