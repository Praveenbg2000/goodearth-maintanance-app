package com.example.demo.service;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import javax.mail.internet.MimeMessage;

import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    // ✅ HTML OTP email (WAR/JAR SAFE)
    public void sendOtpHtml(String to, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper =
                    new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());

            helper.setTo(to);
            helper.setSubject("Login OTP");

            // ✅ Load HTML template SAFELY
            ClassPathResource resource = new ClassPathResource("email/otp-email.html");

            String html;
            try (InputStream is = resource.getInputStream()) {
                html = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            }

            html = html.replace("{{OTP}}", otp);

            helper.setText(html, true); // HTML enabled
            mailSender.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
