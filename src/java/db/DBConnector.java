package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

/**
 * Database Connector with proper connection management
 */
public class DBConnector {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/kisanmitra";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    private static final String DB_DRIVER = "com.mysql.jdbc.Driver";
    
    static {
        try {
            Class.forName(DB_DRIVER);
            System.out.println("Driver Loaded");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver loading failed: " + e);
            e.printStackTrace();
        }
    }
    
    /**
     * Get a new database connection
     * Each call creates a fresh connection
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("New connection created");
            return conn;
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e);
            throw e;
        }
    }
    
    /**
     * Create a statement from a new connection
     * WARNING: Use this carefully - always close the connection after use
     */
    @Deprecated
    public static Statement getStatement() throws SQLException {
        Connection conn = getConnection();
        Statement st = conn.createStatement();
        System.out.println("New statement created");
        return st;
    }
}