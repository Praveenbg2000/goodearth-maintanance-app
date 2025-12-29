package com.example.demo.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dto.TaskDto;
import com.example.demo.model.AddedUser;
import com.example.demo.model.Task;
import com.example.demo.model.User;
import com.example.demo.model.UserTask;
import com.example.demo.repository.AddedUserRepository;
import com.example.demo.repository.ClientHomeRepository;
import com.example.demo.repository.TaskRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.UserTaskRepository;


@Controller
@RequestMapping("/user")
public class UserController {

    private final UserRepository userRepository;
    private final ClientHomeRepository clientHomeRepository;
    private final AddedUserRepository addedUserRepository;
    private final JavaMailSender mailSender;
    private final String uploadDir = "uploads";
    
    @Autowired
    private TaskRepository taskRepository;


    @Autowired
    private UserTaskRepository userTaskRepository;

    public UserController(UserRepository userRepository,
                          ClientHomeRepository clientHomeRepository,
                          AddedUserRepository addedUserRepository,
                          JavaMailSender mailSender) {
        this.userRepository = userRepository;
        this.clientHomeRepository = clientHomeRepository;
        this.addedUserRepository = addedUserRepository;
        this.mailSender = mailSender;
    }

    /* ==========================================================
       ✅ DASHBOARD DISPLAY
    ========================================================== */
    @GetMapping("/dashboard")
    @Transactional
    public String dashboard(HttpSession session, Model model) {
    	String[] months = {
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            };
            model.addAttribute("months", months);
        String selectedHome = (String) session.getAttribute("selectedHome");

        // 🔹 Recover selectedHome if missing
        if (selectedHome == null) {
            Boolean isOwner = (Boolean) session.getAttribute("isOwner");
            Long userId = (Long) session.getAttribute("userId");
            Long addedUserId = (Long) session.getAttribute("addedUserId");

            if (Boolean.TRUE.equals(isOwner) && userId != null) {
                userRepository.findById(userId).ifPresent(u -> session.setAttribute("selectedHome", u.getHomeName()));
            } else if (Boolean.FALSE.equals(isOwner) && addedUserId != null) {
                addedUserRepository.findById(addedUserId).ifPresent(added -> {
                    User owner = added.getOwner();
                    if (owner != null) {
                        var homes = clientHomeRepository.findByUserId(owner.getId());
                        if (!homes.isEmpty()) {
                            session.setAttribute("selectedHome", homes.get(0).getHomeName());
                        } else if (owner.getHomeName() != null) {
                            session.setAttribute("selectedHome", owner.getHomeName());
                        }
                    }
                });
            }
            selectedHome = (String) session.getAttribute("selectedHome");
        }

        model.addAttribute("selectedHome", selectedHome);
        model.addAttribute("viewerName", session.getAttribute("username"));

        // ✅ Always load all master tasks from Task.java
        List<Task> allTasks = taskRepository.findAll();
        model.addAttribute("tasks", allTasks);

        // 🔹 Continue your owner vs. added user logic (unchanged)
        if (Boolean.TRUE.equals(session.getAttribute("isOwner"))) {
            Long userId = (Long) session.getAttribute("userId");
            var opt = userRepository.findById(userId);
            if (opt.isEmpty()) {
                session.invalidate();
                return "redirect:/";
            }

            model.addAttribute("user", opt.get());
            model.addAttribute("canAdd", true);
            return "user/dashboard";
        } 
        else {
            Long addedUserId = (Long) session.getAttribute("addedUserId");
            var aopt = addedUserRepository.findById(addedUserId);
            if (aopt.isEmpty()) {
                session.invalidate();
                return "redirect:/";
            }

            AddedUser added = aopt.get();
            model.addAttribute("user", added.getOwner());
            model.addAttribute("canAdd", false);
            return "user/dashboard";
        }
    }


    @GetMapping("/tasks/month/{month}")
    public List<Task> getTasksByMonth(@PathVariable("month") String month) {
        return taskRepository.findByMonthIgnoreCase(month);
    }


    /* ==========================================================
       ✅ PROFILE DISPLAY
    ========================================================== */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        if (Boolean.TRUE.equals(session.getAttribute("isOwner"))) {
            Long userId = (Long) session.getAttribute("userId");
            var opt = userRepository.findById(userId);
            if (opt.isEmpty()) { session.invalidate(); return "redirect:/"; }
            model.addAttribute("user", opt.get());
            model.addAttribute("canAdd", true);
            model.addAttribute("addedUsers", opt.get().getAddedUsers());
            return "user/profile";
        }

        if (Boolean.FALSE.equals(session.getAttribute("isOwner"))) {
            Long addedUserId = (Long) session.getAttribute("addedUserId");
            var aopt = addedUserRepository.findById(addedUserId);
            if (aopt.isEmpty()) { session.invalidate(); return "redirect:/"; }
            AddedUser added = aopt.get();
            model.addAttribute("addedUser", added);
            model.addAttribute("owner", added.getOwner());
            model.addAttribute("canAdd", false);
            return "user/profile-added";
        }

        return "redirect:/";
    }

    /* ==========================================================
       ✅ ADD RELATED USER
    ========================================================== */
    @PostMapping("/add-related")
    public String addRelatedUser(HttpSession session,
                                 @RequestParam String name,
                                 @RequestParam String email,
                                 @RequestParam String phone,
                                 @RequestParam String relationship,
                                 @RequestParam("profilePhoto") MultipartFile profilePhoto,
                                 Model model) {

        if (session.getAttribute("userId") == null || !Boolean.TRUE.equals(session.getAttribute("isOwner"))) {
            return "redirect:/user/dashboard";
        }

        Long userId = (Long) session.getAttribute("userId");
        Optional<User> opt = userRepository.findById(userId);
        if (opt.isEmpty()) {
            session.invalidate();
            return "redirect:/";
        }

        User owner = opt.get();
        AddedUser addedUser = new AddedUser();
        addedUser.setName(name);
        addedUser.setEmail(email);
        addedUser.setPhone(phone);
        addedUser.setRelationship(relationship);
        addedUser.setOwner(owner);

        try {
            if (!profilePhoto.isEmpty()) {
                java.io.File folder = new java.io.File(uploadDir);
                if (!folder.exists()) folder.mkdirs();

                String fileName = UUID.randomUUID() + "_" + profilePhoto.getOriginalFilename();
                Path path = Paths.get(uploadDir, fileName);
                Files.copy(profilePhoto.getInputStream(), path);
                addedUser.setProfilePhoto(fileName);
            }
        } catch (Exception e) {
            model.addAttribute("error", "Photo upload failed: " + e.getMessage());
        }

        addedUserRepository.save(addedUser);

        owner = userRepository.findById(userId).get();
        model.addAttribute("user", owner);
        model.addAttribute("addedUsers", owner.getAddedUsers());
        model.addAttribute("message", "Related user added successfully");
        model.addAttribute("viewerName", session.getAttribute("username"));
        model.addAttribute("canAdd", true);
        return "user/profile";
    }

    /* ==========================================================
       ✅ SERVE PROFILE PHOTOS
    ========================================================== */
    @GetMapping("/photo/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> getPhoto(@PathVariable String filename) throws IOException {
        Path filePath = Paths.get(uploadDir).resolve(filename);
        Resource resource = new UrlResource(filePath.toUri());
        if (!resource.exists()) return ResponseEntity.notFound().build();

        String contentType = Files.probeContentType(filePath);
        if (contentType == null) contentType = "application/octet-stream";

        return ResponseEntity.ok().contentType(MediaType.parseMediaType(contentType)).body(resource);
    }

    /* ==========================================================
       ✅ FETCH HOMES FOR DROPDOWN
    ========================================================== */
    @GetMapping("/fetch-homes")
    @ResponseBody
    public List<String> fetchHomes(@RequestParam String email) {
        List<String> homes = new ArrayList<>();

        // 🔹 Check if email belongs to a main user (owner)
        userRepository.findByEmail(email).ifPresent(user -> {
            if (user.getHomeName() != null && !user.getHomeName().isEmpty()) {
                homes.add(user.getHomeName());
            }

            // Fetch all client homes for this user
            clientHomeRepository.findByUserId(user.getId())
                    .forEach(ch -> homes.add(ch.getHomeName()));
        });

        // 🔹 Check if email belongs to an added user
        addedUserRepository.findByEmail(email).ifPresent(addedUser -> {
            Long ownerId = addedUser.getOwner() != null ? addedUser.getOwner().getId() : null;
            if (ownerId != null) {
                userRepository.findById(ownerId).ifPresent(owner -> {
                    if (owner.getHomeName() != null && !owner.getHomeName().isEmpty()) {
                        homes.add(owner.getHomeName());
                    }

                    clientHomeRepository.findByUserId(owner.getId())
                            .forEach(ch -> homes.add(ch.getHomeName()));
                });
            }
        });

        // Remove duplicates
        return homes.stream().distinct().toList();
    }


    /* ==========================================================
       ✅ LOGIN OTP FLOW
    ========================================================== */
    @PostMapping("/request-otp")
    public String requestOtp(@RequestParam String email,
                             @RequestParam(required = false) String selectedHome,
                             HttpSession session, Model model) {
    	
    	session.invalidate(); // ✅ clear everything
    	session = ((HttpServletRequest) session).getSession(true); // create new session

        Optional<User> userOpt = userRepository.findByEmail(email);
        Optional<AddedUser> addedOpt = addedUserRepository.findByEmail(email);

        if (userOpt.isEmpty() && addedOpt.isEmpty()) {
            model.addAttribute("error", "Email not registered.");
            return "login";
        }

        String otp = String.valueOf(new Random().nextInt(900000) + 100000);

        // 🟢 Always re-store these in session before redirecting
        session.setAttribute("loginOtp", otp);
        session.setAttribute("selectedEmail", email);
        session.removeAttribute("selectedHome");
        session.setAttribute("selectedHome", selectedHome);

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Your Login OTP");
            message.setText("Your OTP for login is: " + otp);
            mailSender.send(message);
            model.addAttribute("message", "OTP sent to your email.");
        } catch (Exception e) {
            model.addAttribute("error", "Failed to send OTP.");
        }

        return "verify-otp";
    }


    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String otp, HttpSession session, Model model) {
        String sessionOtp = (String) session.getAttribute("loginOtp");
        String email = (String) session.getAttribute("selectedEmail");
        String selectedHome = (String) session.getAttribute("selectedHome");

        if (sessionOtp == null || !sessionOtp.equals(otp)) {
            model.addAttribute("error", "Invalid OTP. Try again.");
            return "verify-otp";
        }

        Optional<User> userOpt = userRepository.findByEmail(email);
        Optional<AddedUser> addedOpt = addedUserRepository.findByEmail(email);

        // 🟢 Always ensure selectedHome is not null
        if (selectedHome != null && !selectedHome.isBlank()) {
        } else if (userOpt.isPresent()) {
            User u = userOpt.get();
            var homes = clientHomeRepository.findByUserId(u.getId());
            if (!homes.isEmpty()) selectedHome = homes.get(0).getHomeName();
        } else if (addedOpt.isPresent()) {
            AddedUser a = addedOpt.get();
            User owner = a.getOwner();
            if (owner != null) {
                var homes = clientHomeRepository.findByUserId(owner.getId());
                if (!homes.isEmpty()) selectedHome = homes.get(0).getHomeName();
                else selectedHome = owner.getHomeName(); // fallback
            }
        }

        // ✅ Persist all session info before redirect
        session.setAttribute("selectedHome", selectedHome);
        session.setAttribute("selectedEmail", email);

        // 👑 Owner
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("isOwner", true);
        }

        // 👥 Added User
        if (addedOpt.isPresent()) {
            AddedUser addedUser = addedOpt.get();
            session.setAttribute("addedUserId", addedUser.getId());
            session.setAttribute("username", addedUser.getName());
            session.setAttribute("isOwner", false);

            // 🟢 ensure selectedHome persists for subuser's owner
            if (selectedHome == null || selectedHome.isBlank()) {
                User owner = addedUser.getOwner();
                if (owner != null) {
                    var homes = clientHomeRepository.findByUserId(owner.getId());
                    if (!homes.isEmpty()) {
                        selectedHome = homes.get(0).getHomeName();
                        session.setAttribute("selectedHome", selectedHome);
                    }
                }
            }
        }

        return "redirect:/user/dashboard";
    }







    /* ==========================================================
       ✅ LOGOUT
    ========================================================== */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            System.out.println("🧹 Destroying session for user: " + session.getAttribute("username"));
            session.invalidate(); // ✅ This safely destroys the current session
        }

        // ✅ Clear JSESSIONID cookie on the browser
        Cookie cookie = new Cookie("JSESSIONID", "");
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);

        System.out.println("✅ Session destroyed and cookie cleared successfully.");
        return "redirect:/"; // Redirect back to login page
    }





    /* ==========================================================
       ✅ DELETE ADDED USER (EMAIL OTP)
    ========================================================== */
    @PostMapping("/send-delete-otp")
    @ResponseBody
    public ResponseEntity<String> sendDeleteOtp(HttpSession session, @RequestParam("addedUserId") Long addedUserId) {
        String email = null;

        if (Boolean.TRUE.equals(session.getAttribute("isOwner")) && session.getAttribute("userId") != null) {
            Long userId = (Long) session.getAttribute("userId");
            email = userRepository.findById(userId).map(User::getEmail).orElse(null);
        } else if (Boolean.FALSE.equals(session.getAttribute("isOwner")) && session.getAttribute("addedUserId") != null) {
            Long addedId = (Long) session.getAttribute("addedUserId");
            email = addedUserRepository.findById(addedId).map(AddedUser::getEmail).orElse(null);
        }

        if (email == null) return ResponseEntity.badRequest().body("No valid session email found.");

        String otp = String.valueOf(new Random().nextInt(900000) + 100000);
        session.setAttribute("deleteOtp", otp);
        session.setAttribute("deleteUserId", addedUserId);

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("Delete Confirmation OTP");
            message.setText("Your OTP to delete a related user is: " + otp + "\n\nDo not share this code with anyone.");
            mailSender.send(message);
            return ResponseEntity.ok("OTP sent successfully to " + email);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Failed to send OTP: " + e.getMessage());
        }
    }

    @PostMapping("/verify-delete-otp")
    @ResponseBody
    public ResponseEntity<String> verifyDeleteOtp(HttpSession session,
                                                  @RequestParam("otp") String otp,
                                                  @RequestParam("addedUserId") Long addedUserId) {

        String sessionOtp = (String) session.getAttribute("deleteOtp");
        Long sessionUserId = (Long) session.getAttribute("deleteUserId");

        if (sessionOtp == null || !sessionOtp.equals(otp))
            return ResponseEntity.status(400).body("Invalid OTP");

        if (sessionUserId == null || !sessionUserId.equals(addedUserId))
            return ResponseEntity.status(400).body("Invalid delete request");

        try {
            addedUserRepository.deleteById(addedUserId);
            session.removeAttribute("deleteOtp");
            session.removeAttribute("deleteUserId");
            return ResponseEntity.ok("User deleted successfully");
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Failed to delete user: " + e.getMessage());
        }
    }

    /* ==========================================================
       ✅ CLIENT TASKS & TICKETING
    ========================================================== */
    @GetMapping("/client-tasks")
    public String clientTasks() { return "user/ClientTasks"; }

    @GetMapping("/raise-ticket")
    public String raiseTicket(@RequestParam("task") String task, Model model) {
        model.addAttribute("task", task);
        return "user/RaiseTicket";
    }

    @PostMapping("/submit-ticket")
    public String submitTicket(@RequestParam("task") String task,
                               @RequestParam("message") String message,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {

        String username = (String) session.getAttribute("username");
        String selectedHome = (String) session.getAttribute("selectedHome");
        String email;

        if (Boolean.TRUE.equals(session.getAttribute("isOwner"))) {
            Long userId = (Long) session.getAttribute("userId");
            email = userRepository.findById(userId)
                    .map(User::getEmail)
                    .orElse("unknown@domain.com");
        } else {
            Long addedId = (Long) session.getAttribute("addedUserId");
            email = addedUserRepository.findById(addedId)
                    .map(AddedUser::getEmail)
                    .orElse("unknown@domain.com");
        }

        try {
            /* ================= ADMIN EMAIL ================= */
            MimeMessage adminMessage = mailSender.createMimeMessage();
            MimeMessageHelper adminHelper =
                    new MimeMessageHelper(adminMessage, true, "UTF-8");

            adminHelper.setTo("marketing@goodearth.org.in"); // Admin mail
            adminHelper.setSubject("Maintenance Ticket Raised: " + task);

            ClassPathResource resource = new ClassPathResource("email/issue.html");
            String html = new String(resource.getInputStream().readAllBytes(),
                    StandardCharsets.UTF_8);

            html = html.replace("{{USER_NAME}}", username);
            html = html.replace("{{USER_EMAIL}}", email);
            html = html.replace("{{HOME_NO}}", selectedHome);
            html = html.replace("{{TASK_NAME}}", task);
            html = html.replace("{{ISSUE_DESCRIPTION}}", message);

            adminHelper.setText(html, true);
            mailSender.send(adminMessage);

            /* ================= USER CONFIRMATION EMAIL ================= */
            MimeMessage userMessage = mailSender.createMimeMessage();
            MimeMessageHelper userHelper =
                    new MimeMessageHelper(userMessage, true, "UTF-8");

            userHelper.setTo(email);
            userHelper.setSubject("Ticket Raised Successfully – " + task);

            String userMailHtml =
                    "<div style='font-family:Poppins,Arial,sans-serif; padding:20px;'>"
                  + "<h2 style='color:#1f1f1f;'>Ticket Raised Successfully ✅</h2>"
                  + "<p>Dear <strong>" + username + "</strong>,</p>"
                  + "<p>Your maintenance ticket has been raised successfully.</p>"
                  + "<p><strong>Task:</strong> " + task + "<br/>"
                  + "<strong>Home:</strong> " + selectedHome + "</p>"
                  + "<p>Our maintenance team will contact you shortly.</p>"
                  + "<br/>"
                  + "<p style='color:#666;'>Best Regards,<br/>GoodEarth Team</p>"
                  + "</div>";

            userHelper.setText(userMailHtml, true);
            mailSender.send(userMessage);

            redirectAttributes.addFlashAttribute(
                    "success",
                    "✅ Ticket raised successfully for " + task
            );

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute(
                    "error",
                    "❌ Failed to raise ticket. Please try again later."
            );
        }

        return "redirect:/user/dashboard";
    }



    /* ==========================================================
       ✅ USER TASK MANAGEMENT (for dashboard sync)
    ========================================================== */
    @GetMapping("/tasks")
    @ResponseBody
    public List<TaskDto> getUserTasks(HttpSession session) {
        String home = (String) session.getAttribute("selectedHome");
        if (home == null) return List.of();

        List<UserTask> dbTasks = new ArrayList<>();

        // OWNER
        if (Boolean.TRUE.equals(session.getAttribute("isOwner"))) {
            Long userId = (Long) session.getAttribute("userId");
            if (userId != null) {
                dbTasks.addAll(
                    userTaskRepository.findByUserIdAndHomeName(userId, home)
                );
            }
        }

        // ADDED USER
        if (Boolean.FALSE.equals(session.getAttribute("isOwner"))) {
            Long addedUserId = (Long) session.getAttribute("addedUserId");

            if (addedUserId != null) {
                var addedOpt = addedUserRepository.findById(addedUserId);

                if (addedOpt.isPresent()) {
                    Long ownerId = addedOpt.get().getOwner().getId();

                    dbTasks.addAll(
                        userTaskRepository.findByUserIdAndHomeName(ownerId, home)
                    );
                }

                dbTasks.addAll(
                    userTaskRepository.findByAddedUserIdAndHomeName(addedUserId, home)
                );
            }
        }

        // Convert to TaskDto
        return dbTasks.stream()
                .map(t -> new TaskDto(
                    t.getTaskName(),
                    t.getTaskMonth(),
                    t.getTaskYear()
                ))
                .toList();
    }


    @Transactional
    @PostMapping("/update-task")
    @ResponseBody
    public String updateTask(@RequestParam String taskName,
                             @RequestParam boolean completed,
                             @RequestParam String taskMonth,
                             @RequestParam int taskYear,
                             HttpSession session) {

        Boolean isOwner = (Boolean) session.getAttribute("isOwner");
        Long userId = (Long) session.getAttribute("userId");
        Long addedUserId = (Long) session.getAttribute("addedUserId");
        String selectedHome = (String) session.getAttribute("selectedHome");

        if (selectedHome == null || selectedHome.isBlank()) return "error";

        // Case 1: UNCHECK → DELETE
        if (!completed) {
            if (Boolean.TRUE.equals(isOwner) && userId != null) {
                userTaskRepository.deleteByUserIdAndHomeNameAndTaskName(userId, selectedHome, taskName);
            } else if (Boolean.FALSE.equals(isOwner) && addedUserId != null) {
                var addedOpt = addedUserRepository.findById(addedUserId);
                if (addedOpt.isPresent()) {
                    User owner = addedOpt.get().getOwner();
                    if (owner != null) {
                        userTaskRepository.deleteByUserIdAndHomeNameAndTaskName(owner.getId(), selectedHome, taskName);
                    }
                }
                userTaskRepository.deleteByAddedUserIdAndHomeNameAndTaskName(addedUserId, selectedHome, taskName);
            }
            return "deleted";
        }

        // Case 2: CHECK → SAVE
        if (Boolean.TRUE.equals(isOwner) && userId != null) {
            User owner = userRepository.findById(userId).orElse(null);
            if (owner == null) return "error";

            List<AddedUser> relatedUsers = addedUserRepository.findByOwner(owner);

            for (AddedUser au : relatedUsers) {
                UserTask task = new UserTask();
                task.setTaskName(taskName);
                task.setHomeName(selectedHome);
                task.setUserId(userId);
                task.setAddedUserId(au.getId());

                // ⭐ New fields
                task.setTaskMonth(taskMonth);
                task.setTaskYear(taskYear);

                userTaskRepository.save(task);
            }

            if (relatedUsers.isEmpty()) {
                UserTask ownerTask = new UserTask();
                ownerTask.setTaskName(taskName);
                ownerTask.setHomeName(selectedHome);
                ownerTask.setUserId(userId);
                ownerTask.setAddedUserId(userId);

                // ⭐ New fields
                ownerTask.setTaskMonth(taskMonth);
                ownerTask.setTaskYear(taskYear);

                userTaskRepository.save(ownerTask);
            }

        } else if (Boolean.FALSE.equals(isOwner) && addedUserId != null) {
            AddedUser added = addedUserRepository.findById(addedUserId).orElse(null);
            if (added == null) return "error";

            User owner = added.getOwner();

            UserTask subTask = new UserTask();
            subTask.setTaskName(taskName);
            subTask.setHomeName(selectedHome);

            subTask.setUserId(owner != null ? owner.getId() : addedUserId);
            subTask.setAddedUserId(addedUserId);

            // ⭐ New fields
            subTask.setTaskMonth(taskMonth);
            subTask.setTaskYear(taskYear);

            userTaskRepository.save(subTask);

            if (owner != null) {
                UserTask ownerTask = new UserTask();
                ownerTask.setTaskName(taskName);
                ownerTask.setHomeName(selectedHome);
                ownerTask.setUserId(owner.getId());
                ownerTask.setAddedUserId(addedUserId);

                // ⭐ New fields
                ownerTask.setTaskMonth(taskMonth);
                ownerTask.setTaskYear(taskYear);

                userTaskRepository.save(ownerTask);
            }
        }

        return "success";
    }







    @GetMapping("/my-profile")
    public String myProfile(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/";
        var userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) return "redirect:/";
        var user = userOpt.get();

        // Fetch home info
        var homes = clientHomeRepository.findByUserId(userId);
        model.addAttribute("user", user);
        model.addAttribute("homeCount", homes.size());
        model.addAttribute("homeNames", homes.stream().map(h -> h.getHomeName()).toList());
        return "user/MyProfile";
    }

    @GetMapping("/added-users")
    public String addedUsers(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/";
        var userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) return "redirect:/";
        model.addAttribute("addedUsers", userOpt.get().getAddedUsers());
        return "user/AddedUsers";
    }


}
