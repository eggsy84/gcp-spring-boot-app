package uk.co.eggsylife.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String showHomePage() {
        return "<h2>Hello Continuous Lifecycle London</h2><h3>Version 1.0.0 of the Application</h3>";
    }
}
