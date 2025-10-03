/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import db.DBConnector;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.FarmerLoginAuthenticator;
import model.BuyerLoginAuthenticator;


/**
 *
 * @author mitesh
 */
public class FarmerLoginChecker extends HttpServlet 
{
   public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
   {
      response.sendRedirect("Home.html");
   }
     
   public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
   {
       String email = request.getParameter("email");
       String password = request.getParameter("password");
       String fname="";
       try
        {
            Statement st= DBConnector.getStatement(); 
            String query="SELECT first name FROM farmerregistration WHERE email='"+email+"'";
            System.out.println("query="+query);
            ResultSet rs=st.executeQuery(query);
            if(rs.next())
            {
               fname=rs.getString(1);
            }
           
           
            
          }
         catch(SQLException e)
            {
               System.out.println(e);                                
            }
       
       FarmerLoginAuthenticator l1= new FarmerLoginAuthenticator();
       boolean login = l1.isLogin(email, password);
       
       
       if(login)
       {
           HttpSession session= request.getSession(true);
           session.setAttribute("email", email);
           session.setAttribute("fname", fname);
           response.sendRedirect("FarmerProfile.html");
       }
       else
       {
           response.sendRedirect("LoginFail.html");
       }
 
   }
}