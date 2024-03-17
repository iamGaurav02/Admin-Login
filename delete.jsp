<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.driver.OracleDriver"%>

<%
    String username = request.getParameter("username");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "8520");

        pstmt = conn.prepareStatement("DELETE FROM admin WHERE username = ?");
        pstmt.setString(1, username);  

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.getWriter().println("Deleted " + username + "'s account successfully!");
        } else {
            response.getWriter().println("Username " + username + " not found.");        
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().println("SQL Error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        response.getWriter().println("Driver Error: " + e.getMessage());
    } finally {
        // Close resources
        try {
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error closing resources: " + e.getMessage());
        }
    }
%>
