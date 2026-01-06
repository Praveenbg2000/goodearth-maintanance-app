package com.example.demo.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.Admin;
import com.example.demo.model.ClientHome;
import com.example.demo.model.Task;
import com.example.demo.model.TaskStep;
import com.example.demo.model.User;
import com.example.demo.repository.AddedUserRepository;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.ClientHomeRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.TaskStepRepository;
import com.example.demo.repository.UserRepository;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminRepository adminRepository;
    private final UserRepository userRepository;
    
    @Autowired
    private AddedUserRepository addedUserRepository;

    @Autowired
    private ClientHomeRepository clientHomeRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private TaskStepRepository taskStepRepository;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    public AdminController(AdminRepository adminRepository, UserRepository userRepository) {
        this.adminRepository = adminRepository;
        this.userRepository = userRepository;
    }

    // 🔹 Admin Login
    @GetMapping("/login")
    public String showLogin() {
        return "admin/login";
    }
    
    @GetMapping("/manage")
    public String manageAdmins(HttpSession session, Model model) {

        String email = (String) session.getAttribute("adminEmail");

        if (email == null || 
            !email.equalsIgnoreCase("marketing@goodearth.org.in")) {
            return "redirect:/admin/dashboard";
        }

        model.addAttribute("admins", adminRepository.findAll());
        return "admin/manageadmin";
    }
    
    
    @PostMapping("/delete-admin")
    @ResponseBody
    public ResponseEntity<String> deleteAdmin(@RequestParam Long id) {

        if (!adminRepository.existsById(id)) {
            return ResponseEntity.badRequest().body("Admin not found");
        }

        adminRepository.deleteById(id);
        return ResponseEntity.ok("Deleted");
    }



    @PostMapping("/update-admin")
    @ResponseBody
    public ResponseEntity<String> updateAdmin(
            @RequestParam Long id,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password) {

        Admin admin = adminRepository.findById(id).orElse(null);

        if (admin == null) {
            return ResponseEntity.badRequest().body("Admin not found");
        }

        admin.setName(name);
        admin.setEmail(email);
        admin.setPassword(password); // ❌ no encryption (as requested)

        adminRepository.save(admin);
        return ResponseEntity.ok("Updated");
    }

    
    @PostMapping("/add-admin")
    @ResponseBody
    public ResponseEntity<String> addAdmin(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password) {


        Admin admin = new Admin();
        admin.setName(name);
        admin.setEmail(email);

        // ❌ NO ENCRYPTION
        admin.setPassword(password);

        adminRepository.save(admin);

        return ResponseEntity.ok("Admin added");
    }

    

    @PostMapping("/login")
    public String doLogin(@RequestParam String email,
                          @RequestParam String password,
                          HttpSession session,
                          Model model) {

        var opt = adminRepository.findByEmail(email);

        if (opt.isPresent() && opt.get().getPassword().equals(password)) {

            session.setAttribute("adminId", opt.get().getId());
            session.setAttribute("adminName", opt.get().getName());

            // ✅ ADD THIS LINE (CRITICAL)
            session.setAttribute("adminEmail", opt.get().getEmail());

            return "redirect:/admin/dashboard";
        } else {
            model.addAttribute("error", "Invalid credentials");
            return "admin/login";
        }
    }


    // 🔹 Admin Dashboard
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (session.getAttribute("adminId") == null) {
            return "redirect:/admin/login";
        }
        model.addAttribute("users", userRepository.findAll());
        return "admin/dashboard";
    }

    // 🔹 Add User Page
    @GetMapping("/add-user")
    public String addUserPage(HttpSession session) {
        if (session.getAttribute("adminId") == null) {
            return "redirect:/admin/login";
        }
        return "admin/addUser";
    }

    // 🔹 Add User (AJAX)
    @PostMapping("/add-user")
    @ResponseBody
    public ResponseEntity<String> addUser(@RequestParam("username") String username,
                                          @RequestParam("community") String community,
                                          @RequestParam("homeName") String homeName,
                                          @RequestParam("email") String email,
                                          @RequestParam("phone") String phone,
                                          @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto) {
        try {
            User user = new User();
            user.setUsername(username);
            user.setCommunity(community);
            user.setHomeName(homeName);
            user.setEmail(email);
            user.setPhone(phone);

            if (profilePhoto != null && !profilePhoto.isEmpty()) {
                File uploadFolder = new File(uploadDir);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();

                String fileName = UUID.randomUUID() + "_" + profilePhoto.getOriginalFilename();
                Path filePath = Paths.get(uploadDir, fileName);
                Files.copy(profilePhoto.getInputStream(), filePath);

                user.setProfilePhoto(fileName);
            }

            userRepository.save(user);
            return ResponseEntity.ok("User added successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Failed to add user or user added already please check once again all fields : " + e.getMessage());
        }
    }

    // 🔹 Serve uploaded profile photos dynamically
    @GetMapping("/uploads/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> getFile(@PathVariable String filename) throws IOException {
        Path filePath = Paths.get(uploadDir).resolve(filename);
        Resource resource = new UrlResource(filePath.toUri());

        if (!resource.exists()) {
            return ResponseEntity.notFound().build();
        }

        String contentType = Files.probeContentType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .body(resource);
    }

    // 🔹 Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("adminId");
        session.removeAttribute("adminName");
        return "redirect:/admin/login";
    }

    // 🔹 Save Homes
    @PostMapping("/save-homes")
    @ResponseBody
    public ResponseEntity<String> saveClientHomes(
            @RequestParam("userId") Long userId,
            @RequestParam(value = "homes[]", required = false) List<String> homes1,
            @RequestParam(value = "homes", required = false) List<String> homes2) {

        List<String> homes = (homes1 != null && !homes1.isEmpty()) ? homes1 : homes2;

        if (homes == null || homes.isEmpty()) {
            return ResponseEntity.badRequest().body("No homes provided");
        }

        Optional<User> opt = userRepository.findById(userId);
        if (opt.isEmpty()) {
            return ResponseEntity.badRequest().body("User not found");
        }

        User user = opt.get();
        for (String homeName : homes) {
            if (homeName != null && !homeName.trim().isEmpty()) {
                ClientHome home = new ClientHome();
                home.setHomeName(homeName.trim());
                home.setUser(user);
                clientHomeRepository.save(home);
            }
        }

        return ResponseEntity.ok("Homes added successfully!");
    }

    // ==========================================================
    // 🔹 Monthly Maintenance Task Management (Task + TaskStep)
    // ==========================================================

    @GetMapping("/add-task")
    public String showAddTaskPage(HttpSession session, Model model) {
        if (session.getAttribute("adminId") == null) {
            return "redirect:/admin/login";
        }
        return "admin/add-task";
    }

    @GetMapping("/check-task")
    @ResponseBody
    public String checkTaskExists(@RequestParam String title, @RequestParam String month) {
        Optional<Task> existing = taskRepository.findByTitleAndMonth(title, month);
        return existing.isPresent() ? "true" : "false";
    }

    @PostMapping("/save-task-basic")
    @ResponseBody
    public ResponseEntity<?> saveTaskBasic(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("month") String month,
            @RequestParam(value = "materialsFinish", required = false) String materialsFinish,
            @RequestParam(value = "taskImage", required = false) String taskImage) {

        Optional<Task> existing = taskRepository.findByTitleAndMonth(title, month);
        if (existing.isPresent()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Task already exists for this month"));
        }

        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setMonth(month);
        task.setMaterialsFinish(materialsFinish);
        task.setTaskImage(taskImage);

        Task saved = taskRepository.saveAndFlush(task);
        return ResponseEntity.ok(Map.of("success", true, "taskId", saved.getTaskId()));
    }

    // ✅ FIXED VERSION (no NumberFormatException / 500 error)
    @PostMapping("/save-task-steps")
    @ResponseBody
    public ResponseEntity<String> saveTaskSteps(@RequestParam("taskId") Long taskId,
                                                @RequestParam MultiValueMap<String, String> formData) {
        try {
            Optional<Task> taskOpt = taskRepository.findById(taskId);
            if (taskOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("❌ Task not found for ID: " + taskId);
            }

            Task task = taskOpt.get();
            List<TaskStep> steps = new ArrayList<>();
            int order = 1; // ✅ Auto-increment order number

            // ✅ Extract each step in sequence
            for (String key : formData.keySet()) {
                if (key.startsWith("steps[") && key.endsWith("].stepText")) {
                    int index;
                    try {
                        index = Integer.parseInt(key.substring(6, key.indexOf("]")));
                    } catch (Exception e) {
                        continue;
                    }

                    String stepText = formData.getFirst("steps[" + index + "].stepText");
                    String stepImage = formData.getFirst("steps[" + index + "].stepImage");

                    if (stepText == null || stepText.trim().isEmpty()) continue;

                    TaskStep step = new TaskStep();
                    step.setTask(task);
                    step.setStepText(stepText.trim());
                    step.setStepOrder(order++); // ✅ auto-numbered sequence
                    step.setStepImage((stepImage != null && !stepImage.trim().isEmpty()) ? stepImage.trim() : null);
                    steps.add(step);
                }
            }

            if (steps.isEmpty()) {
                return ResponseEntity.badRequest().body("⚠️ No valid steps provided.");
            }

            taskStepRepository.saveAll(steps);
            return ResponseEntity.ok("✅ Steps saved successfully for task ID: " + taskId);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("❌ Error: " + e.getMessage());
        }
    }

    @PostMapping("/delete-user")
    @ResponseBody
    public ResponseEntity<String> deleteUser(@RequestParam String email,
                                             @RequestParam String homeName) {
        try {
            addedUserRepository.deleteByEmail(email);
            clientHomeRepository.deleteByHomeName(homeName);

            userRepository.findByEmail(email)
                    .ifPresent(userRepository::delete);

            return ResponseEntity.ok("success");
        } catch (Exception e) {
            e.printStackTrace(); // IMPORTANT for debugging
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("error");
        }
    }


    // SUSPEND USER
    @PostMapping("/suspend-user")
    @ResponseBody
    public ResponseEntity<String> suspendUser(@RequestParam String email,
                                              @RequestParam boolean status) {
        try {
            userRepository.updateSuspendStatus(email, status);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("error");
        }
    }


    @PostMapping("/delete-task")
    public String deleteTask(@RequestParam("title") String title,
                             @RequestParam("month") String month,
                             Model model,
                             HttpSession session) {

        if (session.getAttribute("adminId") == null) {
            return "redirect:/admin/login";
        }

        Optional<Task> taskOpt = taskRepository.findByTitleAndMonth(title, month);
        if (taskOpt.isEmpty()) {
            model.addAttribute("message", "⚠️ Task not found.");
            return "admin/add-task";
        }

        Task task = taskOpt.get();
        taskStepRepository.deleteByTask_TaskId(task.getTaskId());
        taskRepository.delete(task);

        model.addAttribute("message", "🗑️ Task deleted successfully!");
        return "admin/add-task";
    }
}
