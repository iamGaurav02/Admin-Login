<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.driver.OracleDriver"%>

<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "8520");

        // Check if the username already exists
        pstmt = conn.prepareStatement("SELECT * FROM admin WHERE username = ?");
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            response.getWriter().println("Username '" +username+ "' exists. Try any other username.");
        } else {
            // Insert new user if username doesn't exist
            pstmt = conn.prepareStatement("INSERT INTO admin(username, email, password) VALUES (?, ?, ?)");
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, password);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("show.jsp");
            } else {
                response.getWriter().println("Failed to insert user.");
            }
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
