<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.driver.OracleDriver"%>

<%
    String old_username = request.getParameter("old-username");
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");

        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "8520");

        pstmt = conn.prepareStatement("UPDATE admin SET username = NVL(?,username),  email = NVL(?, email), password = NVL(?, password) WHERE username = ?");
        pstmt.setString(1, username);
        pstmt.setString(2, email);
        pstmt.setString(3, password);
        pstmt.setString(4, old_username);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected == 0) {
            response.getWriter().println(old_username + " not found.");
        }
        else {
        out.println("Update " + old_username + "'s account successfully!");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Error : " + e.getMessage());
    } finally {
        try {
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
