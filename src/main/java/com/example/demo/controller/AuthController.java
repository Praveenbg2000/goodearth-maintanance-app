package com.example.demo.controller;

import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.AddedUser;
import com.example.demo.model.User;
import com.example.demo.repository.AddedUserRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.EmailService;
import com.example.demo.service.OtpService;

@Controller
public class AuthController {

    private final UserRepository userRepository;
    private final AddedUserRepository addedUserRepository;
    private final EmailService emailService;
    private final OtpService otpService;

    public AuthController(UserRepository userRepository,
                          AddedUserRepository addedUserRepository,
                          EmailService emailService,
                          OtpService otpService) {
        this.userRepository = userRepository;
        this.addedUserRepository = addedUserRepository;
        this.emailService = emailService;
        this.otpService = otpService;
    }

    @GetMapping("/")
    public String SplashPage() { return "index"; }
    
    @GetMapping("/manage")
    public String ManagePage() {
    	return "manage";
    }

    @GetMapping("/login")
    public String loginPage() { return "login"; }
    
    @PostMapping("/request-otp")
    public String requestOtp(@RequestParam String email, Model model, HttpSession session) {
        // check owner first
        Optional<User> ownerOpt = userRepository.findByEmail(email);
        if (ownerOpt.isPresent()) {
            String otp = otpService.generateOtp(email);
            emailService.send(email, "Login OTP", "Your OTP is: " + otp);
            session.setAttribute("loginEmail", email);
            session.setAttribute("loginType", "owner");
            model.addAttribute("message", "OTP sent to owner's email.");
            return "otp";
        }

        // check added user
        Optional<AddedUser> addedOpt = addedUserRepository.findByEmail(email);
        if (addedOpt.isPresent()) {
            String otp = otpService.generateOtp(email);
            emailService.send(email, "Login OTP", "Your OTP is: " + otp);
            session.setAttribute("loginEmail", email);
            session.setAttribute("loginType", "added");
            session.setAttribute("loginAddedUserId", addedOpt.get().getId());
            session.setAttribute("loginOwnerId", addedOpt.get().getOwner().getId());
            model.addAttribute("message", "OTP sent to your email.");
            return "otp";
        }

        // not found
        model.addAttribute("error", "Your email ID is not registered. Please contact CRM.");
        return "login";
    }

    @PostMapping("/verify-otp")
    public String verifyOtp(@RequestParam String otp, HttpSession session, Model model) {
        String email = (String) session.getAttribute("loginEmail");
        String loginType = (String) session.getAttribute("loginType");
        if (email == null || loginType == null) {
            model.addAttribute("error", "Session expired. Start again by entering email.");
            return "login";
        }

        boolean valid = otpService.validateOtp(email, otp);
        if (!valid) {
            model.addAttribute("error", "Invalid or expired OTP.");
            return "otp";
        }

        if ("owner".equals(loginType)) {
            // owner login
            User user = userRepository.findByEmail(email).get();
            session.setAttribute("userId", user.getId());          // owner id
            session.setAttribute("username", user.getUsername()); // viewer's name (owner)
            session.setAttribute("isOwner", Boolean.TRUE);
            // remove temp login attrs
            session.removeAttribute("loginEmail");
            session.removeAttribute("loginType");
            return "redirect:/user/dashboard";
        } else {
            // added-user login
            Long addedId = (Long) session.getAttribute("loginAddedUserId");
            Long ownerId = (Long) session.getAttribute("loginOwnerId");
            AddedUser addedUser = addedUserRepository.findById(addedId).get();

            // set session so controller knows viewer is an added-user
            session.setAttribute("addedUserId", addedUser.getId());
            session.setAttribute("viewerName", addedUser.getName()); // greeting shows added user's name
            session.setAttribute("ownerId", ownerId);
            session.setAttribute("isOwner", Boolean.FALSE);

            // cleanup temp attrs
            session.removeAttribute("loginEmail");
            session.removeAttribute("loginType");
            session.removeAttribute("loginAddedUserId");
            session.removeAttribute("loginOwnerId");

            return "redirect:/user/dashboard";
        }
    }

    @GetMapping("/logout-all")
    public String logoutAll(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}