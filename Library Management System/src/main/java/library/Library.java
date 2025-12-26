package library;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.sql.*;

@SuppressWarnings("serial")
@WebServlet("/LibraryServlet")
public class Library extends HttpServlet {
	 
    private Connection connection = null;
    private String Url = "jdbc:mysql://localhost:3306/library_db";
    private String Username = "root";
    private String Password = "root"; 
    
    //inti() - method
    
    @Override
    public void init() throws ServletException {
        try {
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            
            connection = DriverManager.getConnection(Url, Username, Password);
            
            
            createBooksTable();
            
            
            
        } catch (ClassNotFoundException e) {
            throw new ServletException(" MySQL JDBC Driver not found!", e);
        } catch (SQLException e) {
            throw new ServletException(" Failed to connect to database!", e);
        }
    }
    
    
    private void createBooksTable() throws SQLException {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS books (" +
                               "id INT AUTO_INCREMENT PRIMARY KEY, " +
                               "title VARCHAR(200) NOT NULL, " +
                               "author VARCHAR(100) NOT NULL, " +
                               "price DECIMAL(10, 2) NOT NULL, " +
                               "isbn VARCHAR(20), " +
                               "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                               ")";
        
        try (Statement stmt = connection.createStatement()) {
            stmt.executeUpdate(createTableSQL);
            System.out.println("Books table created/verified successfully!");
        }
    }
    
    //service() - method
    
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();
        
        
        generateHTMLHeader(out);
        
        if (action == null || !action.equals("add")) {
            showErrorPage(out, "Invalid action!");
            generateHTMLFooter(out);
            out.close();
            return;
        }
        
        try {
            handleAddBook(request, out);
        } catch (SQLException e) {
            showErrorPage(out, "Database Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        
        generateHTMLFooter(out);
        out.close();
    }
    
    // Handles adding a new book
     
    private void handleAddBook(HttpServletRequest request, PrintWriter out) throws SQLException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String priceStr = request.getParameter("price");
        
        
        if (title == null || title.trim().isEmpty() || 
            author == null || author.trim().isEmpty() || 
            priceStr == null || priceStr.trim().isEmpty()) {
            
            out.println("<div class='error'>");
            out.println("<h2><i class='fas fa-exclamation-triangle'></i> Validation Error</h2>");
            out.println("<p>All fields are required!</p>");
            out.println("<a href='Add-Book.html' class='btn'><i class='fas fa-arrow-left'></i> Go Back</a>");
            out.println("</div>");
            return;
        }
        
        try {
            double price = Double.parseDouble(priceStr);
            
            
            String insertSQL = "INSERT INTO books (title, author, price) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = connection.prepareStatement(insertSQL)) {
                pstmt.setString(1, title);
                pstmt.setString(2, author);
                pstmt.setDouble(3, price);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if (rowsAffected > 0) {
                   
                    out.println("<div class='success'>");
                    out.println("<div class='icon'>");
                    out.println("<i class='fas fa-check-circle'></i>");
                    out.println("</div>");
                    out.println("<h2>Book Added Successfully!</h2>");
                    out.println("<div class='book-details'>");
                    out.println("<p><strong>Title:</strong> " + title + "</p>");
                    out.println("<p><strong>Author:</strong> " + author + "</p>");
                    out.println("<p><strong>Price:</strong> ₹" + String.format("%.2f", price) + "</p>");
                    out.println("<p><strong>Added On:</strong> " + 
                               new SimpleDateFormat("dd MMM yyyy HH:mm").format(new java.util.Date()) + "</p>");
                    out.println("</div>");
                    out.println("<div class='btn-group'>");
                    out.println("<a href='Add-Book.html' class='btn'><i class='fas fa-plus'></i> Add Another Book</a>");
                    out.println("<a href='ViewBook.jsp' class='btn'><i class='fas fa-list'></i> View All Books</a>");
                    out.println("<a href='Dashboard.html' class='btn'><i class='fas fa-home'></i> Dashboard</a>");
                    out.println("</div>");
                    out.println("</div>");
                } else {
                    showErrorPage(out, "Failed to add book to database!");
                }
            }
            
        } catch (NumberFormatException e) {
            out.println("<div class='error'>");
            out.println("<h2><i class='fas fa-exclamation-triangle'></i> Invalid Price</h2>");
            out.println("<p>Please enter a valid price (numbers only)!</p>");
            out.println("<a href='Add-Book.html' class='btn'><i class='fas fa-arrow-left'></i> Go Back</a>");
            out.println("</div>");
        }
    }
    
    
    private void generateHTMLHeader(PrintWriter out) {
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Library Management System</title>");
        out.println("<style>");
        out.println("* { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }");
        out.println("body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }");
        out.println(".container { max-width: 600px; width: 100%; }");
        out.println(".content { background: white; border-radius: 20px; padding: 40px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }");
        
        out.println(".success { text-align: center; padding: 40px; }");
        out.println(".success .icon { font-size: 80px; color: #00b894; margin-bottom: 20px; }");
        out.println(".success h2 { color: #333; margin-bottom: 20px; }");
        out.println(".book-details { background: #f8f9fa; padding: 25px; border-radius: 10px; margin: 30px 0; text-align: left; }");
        out.println(".book-details p { margin: 10px 0; }");
        
        out.println(".error { background: #ffe6e6; padding: 30px; border-radius: 10px; text-align: center; margin: 20px 0; }");
        out.println(".error h2 { color: #cc0000; }");
        
        out.println(".btn-group { display: flex; gap: 15px; justify-content: center; margin-top: 30px; flex-wrap: wrap; }");
        out.println(".btn { display: inline-block; padding: 12px 30px; background: linear-gradient(to right, #667eea, #764ba2); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; transition: all 0.3s; }");
        out.println(".btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }");
        
        out.println("</style>");
        out.println("<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css'>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<div class='content'>");
    }
    private void showErrorPage(PrintWriter out, String message) {
        out.println("<div class='error'>");
        out.println("<h2><i class='fas fa-exclamation-triangle'></i> Error</h2>");
        out.println("<p>" + message + "</p>");
        out.println("<div class='btn-group'>");
        out.println("<a href='Add-Book.html' class='btn'><i class='fas fa-arrow-left'></i> Go Back</a>");
        out.println("<a href='Dashboard.html' class='btn'><i class='fas fa-home'></i> Dashboard</a>");
        out.println("</div>");
        out.println("</div>");
    }

    private void generateHTMLFooter(PrintWriter out) {
        out.println("</div>"); 
        out.println("</div>"); 
        out.println("</body>");
        out.println("</html>");
    }
    
    //destroy() - method
    
    @Override
    public void destroy() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("✅ Database connection closed successfully!");
            }
        } catch (SQLException e) {
            System.err.println("❌ Error closing database connection: " + e.getMessage());
        }
    }
	
}
