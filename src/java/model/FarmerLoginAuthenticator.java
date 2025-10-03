/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import db.DBConnector;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class FarmerLoginAuthenticator
{
    public boolean isLogin(String email,String password)
    {
        String tablePassword="";
        try
        {
            Statement st= DBConnector.getStatement(); 
            String query="SELECT password FROM farmerregistration WHERE email='"+email+"'";
            System.out.println("query="+query);
            ResultSet rs=st.executeQuery(query);
            if(rs.next())
            {
               tablePassword=rs.getString(1);
            }
            else
            {
                return false;
            }
           
            
          }
         catch(SQLException e)
            {
               System.out.println(e);        
            }
        
        if(email!=null && password!=null && !email.trim().equals("") && !password.trim().equals("") && password.equals(tablePassword))
        {
               return true;        
        }
        return false;
    }
    
}