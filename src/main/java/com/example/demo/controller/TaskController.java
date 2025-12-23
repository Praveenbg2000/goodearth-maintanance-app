package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.AdminTask;
import com.example.demo.model.Task;
import com.example.demo.model.UserTaskProgress;
import com.example.demo.repository.AdminTaskRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserTaskProgressRepository;

/**
 * ✅ Handles:
 *  - User maintenance dashboard (monthly tasks)
 *  - Real-time user task progress (WebSocket)
 *  - Legacy AdminTask management (separate from new Task + TaskStep system)
 */
@Controller
public class TaskController {

    @Autowired
    private AdminTaskRepository adminTaskRepository;

    @Autowired
    private UserTaskProgressRepository userTaskProgressRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    // ----------------------------------------------------------
    // 🔹 USER DASHBOARD (Dynamic Maintenance Tasks)
    // ----------------------------------------------------------

    @GetMapping("/user/maintenance-dashboard")
    public String showMaintenanceDashboard(@RequestParam(defaultValue = "January") String month, Model model) {
        List<Task> tasks = taskRepository.findByMonthIgnoreCase(month);
        model.addAttribute("tasks", tasks);
        model.addAttribute("selectedMonth", month);
        return "workin";
    }

    @GetMapping("/user/maintenance-tasks")
    @ResponseBody
    public List<Task> getMaintenanceTasks(@RequestParam(required = false) String month) {

        // 1️⃣ Check if month is provided
        if (month == null || month.trim().isEmpty()) {
            return List.of();
        }

        // 2️⃣ Normalize input (case-insensitive)
        String formattedMonth = month.trim().toLowerCase();

        // 3️⃣ Optional: log what’s in DB for debugging
        List<Task> allTasks = taskRepository.findAll();
        System.out.println("🔍 All months in DB: " + allTasks.stream()
                .map(Task::getMonth)
                .filter(m -> m != null)
                .toList());

        // 4️⃣ Filter tasks case-insensitively (safe even if DB mismatch)
        List<Task> filteredTasks = allTasks.stream()
                .filter(t -> t.getMonth() != null && t.getMonth().trim().toLowerCase().equals(formattedMonth))
                .toList();

        return filteredTasks;
    }


    // ----------------------------------------------------------
    // 🔹 USER TASK PROGRESS UPDATE (Real-time via WebSocket)
    // ----------------------------------------------------------

    @PostMapping("/user/maintenance/update-progress")
    @ResponseBody
    public ResponseEntity<?> updateTaskProgress(@RequestBody UserTaskProgress progress) {
        UserTaskProgress updated = userTaskProgressRepository.save(progress);

        // Notify via WebSocket
        if (updated.getUserId() != null) {
            messagingTemplate.convertAndSend("/topic/user-tasks/" + updated.getUserId(), updated);
        } else {
            messagingTemplate.convertAndSend("/topic/task-updates/" + updated.getTaskId(), updated);
        }

        return ResponseEntity.ok(updated);
    }

    // ----------------------------------------------------------
    // 🔹 LEGACY ADMIN TASK MANAGEMENT (Old AdminTask Table)
    // ----------------------------------------------------------

    /**
     * This section is for older AdminTask model.
     * Renamed routes to avoid conflict with /admin/add-task (new Task system)
     */

    @GetMapping("/admin/legacy-task")
    public String showLegacyTaskPage(Model model) {
        List<AdminTask> tasks = adminTaskRepository.findAll();
        model.addAttribute("tasks", tasks);
        return "admin/legacy-task";
    }

    @PostMapping("/admin/legacy-task")
    public String addLegacyTask(@RequestParam("title") String title,
                                @RequestParam("description") String description,
                                @RequestParam("howTo") String howTo,
                                @RequestParam("materials") String materials,
                                @RequestParam("notes") String notes,
                                @RequestParam(value = "image", required = false) MultipartFile image,
                                Model model) {
        try {
            AdminTask task = new AdminTask();
            task.setTitle(title);
            task.setDescription(description);
            task.setHowTo(howTo);
            task.setMaterials(materials);
            task.setNotes(notes);

            if (image != null && !image.isEmpty()) {
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                Path filePath = Paths.get(uploadDir, fileName);
                Files.copy(image.getInputStream(), filePath);
                task.setImageUrl(fileName);
            }

            adminTaskRepository.save(task);
            model.addAttribute("success", "✅ Task added successfully!");
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("error", "❌ Error uploading image: " + e.getMessage());
        }

        model.addAttribute("tasks", adminTaskRepository.findAll());
        return "admin/legacy-task";
    }

    @GetMapping("/admin/legacy-delete")
    public String deleteLegacyTask(@RequestParam("id") Long id, Model model) {
        adminTaskRepository.deleteById(id);
        model.addAttribute("success", "🗑️ Task deleted successfully!");
        model.addAttribute("tasks", adminTaskRepository.findAll());
        return "admin/legacy-task";
    }
}
