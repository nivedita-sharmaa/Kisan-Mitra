package controller;

import db.DBConnector;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FarmerRegistrationChecker extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("FarmerRegistration.html");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        String firstname = request.getParameter("first-name");
        String lastname = request.getParameter("last-name");
        String gender = request.getParameter("gender");
//        String cropgrown = request.getParameter("crop-grown");
//        String farmsize = request.getParameter("farmsize");
//        System.out.println("farmsize:"+farmsize);
        String mobile = request.getParameter("mobile");
        String email=request.getParameter("email");
        String password=request.getParameter("password");
        String confirmpassword=request.getParameter("confirm-password");
        String street=request.getParameter("street");
        String city=request.getParameter("city");
        String state=request.getParameter("state");
        String postal=request.getParameter("postal");
        String country=request.getParameter("country");
        String terms=request.getParameter("terms");
        PrintWriter out = response.getWriter();
        int i = 0;

        try {
        Statement st = DBConnector.getStatement();
        String query2 = "INSERT INTO farmerregistration (fname, lname, gender, mobile, email, password, confirm, street, city, state, pin, country) VALUES ('" + firstname + "', '" + lastname + "', '" + gender + "',  '" + mobile + "','" + email + "','" + password + "','" + confirmpassword + "','" + street + "','" + city + "','" + state + "','" + postal + "','" + country + "')";
        System.out.println(query2);
        i = st.executeUpdate(query2);

        if (i > 0) {
            // ✅ Redirect to Thank You page
            response.sendRedirect("Thankyou.html");
        } else {
            out.println("Registration failed. Please try again.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Database error: " + e.getMessage());
    }
}
}