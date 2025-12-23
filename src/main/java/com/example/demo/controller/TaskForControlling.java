package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.Task;
import com.example.demo.service.TaskService;

@Controller
public class TaskForControlling {
	
    @Autowired
    private TaskService taskService;

    @GetMapping("/user")
    public String index(Model model) {
        String[] months = {
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        };
        model.addAttribute("months", months);
        return "index"; // index.jsp
    }

    // ✅ Add this exact mapping for AJAX fetch
    @GetMapping("/tasks")
    public String getTasksByMonth(@RequestParam("month") String month, Model model) {
        List<Task> tasks = taskService.getTasksByMonth(month);
        model.addAttribute("tasks", tasks);
        return "tasks"; // tasks.jsp
    }

}
