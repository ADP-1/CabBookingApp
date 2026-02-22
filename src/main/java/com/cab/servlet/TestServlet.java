package com.cab.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


@WebServlet("/test")
public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Cab Booking - Test Page</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 50px; background: #f0f0f0; }");
        out.println(".container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); max-width: 600px; margin: 0 auto; }");
        out.println("h1 { color: #4CAF50; }");
        out.println(".success { color: #4CAF50; padding: 10px; background: #e8f5e9; border-radius: 4px; margin: 10px 0; }");
        out.println("ul { list-style: none; padding: 0; }");
        out.println("li { padding: 8px 0; border-bottom: 1px solid #eee; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🚖 Cab Booking Application</h1>");
        out.println("<div class='success'>✅ Servlet is working correctly!</div>");
        out.println("<h3>System Status:</h3>");
        out.println("<ul>");
        out.println("<li>✅ Tomcat Server: Running</li>");
        out.println("<li>✅ Application Deployed: Success</li>");
        out.println("<li>✅ Servlet Container: Active</li>");
        out.println("<li>✅ WAR File: cab-booking.war</li>");
        out.println("</ul>");
        out.println("<h3>Next Steps:</h3>");
        out.println("<ul>");
        out.println("<li>1. Access Login Page: <a href='login.jsp'>login.jsp</a></li>");
        out.println("<li>2. Access Dashboard: <a href='dashboard.jsp'>dashboard.jsp</a></li>");
        out.println("<li>3. View All Rides: <a href='ride?action=viewAll'>View Rides</a></li>");
        out.println("</ul>");
        out.println("<p><small>Server Time: " + new java.util.Date() + "</small></p>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
