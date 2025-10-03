/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import db.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Asus
 */
public class UpdateFarmerProfile extends HttpServlet {

   
     public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("FarmerRegistration.html");
    }
     public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          String email = request.getParameter("email"); // read-only in form
    String fname = request.getParameter("first-name");
    String lname = request.getParameter("last-name");
    String gender = request.getParameter("gender");
    String cropgrown = request.getParameter("crop-grown");
    String farmsize = request.getParameter("farmsize");
    String mobile = request.getParameter("mobile");
   
    String street = request.getParameter("street");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postal = request.getParameter("postal");
    String country = request.getParameter("country");
  try{
    Statement st = DBConnector.getStatement();
    // WARNING: This approach is vulnerable to SQL Injection - better to sanitize inputs if used in production!
    String sql = "UPDATE farmerregistration SET " +
            "fname='" + fname + "', " +
            "lname='" + lname + "', " +
            "gender='" + gender + "', " +
            "cropGrown='" + cropgrown + "', " +
            "farmSize='" + farmsize + "', " +
            "mobile='" + mobile + "', " +
            "street='" + street + "', " +
            "city='" + city + "', " +
            "state='" + state + "', " +
            "pin='" + postal + "', " +
            "country='" + country + "' " +
          
            "WHERE email='" + email + "'";
    int rows = st.executeUpdate(sql);
    System.out.println("query:"+sql);
  
  
    if (rows > 0) {
        request.setAttribute("message", "Profile updated successfully!");
        request.setAttribute("messageType", "success");
        response.sendRedirect("FarmerProfile.jsp");
    } else {
        request.setAttribute("message", "Update failed. Please try again.");
        request.setAttribute("messageType", "error");
    }
  }
   catch (SQLException e) {
        e.printStackTrace();
        out.println("Database error: " + e.getMessage());
    }
  

    // Forward back to the JSP page so the user sees the updated data & message
   
         
     }
        
      
    
   
}

