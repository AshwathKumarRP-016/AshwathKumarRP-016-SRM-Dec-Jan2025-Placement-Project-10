<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View All Books - Library</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            color: #333;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .actions {
            display: flex;
            gap: 15px;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(to right, #00b894, #00a085);
            color: white;
        }
        
        .btn-secondary {
            background: #636e72;
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .stat-card {
            flex: 1;
            min-width: 200px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 5px solid #667eea;
        }
        
        .stat-card h3 {
            color: #555;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: #333;
        }
        
        .table-container {
            overflow-x: auto;
            margin: 30px 0;
            border-radius: 10px;
            border: 1px solid #eee;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .price {
            color: #00b894;
            font-weight: bold;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .action-btn {
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .edit-btn {
            background: #ffd166;
            color: #333;
        }
        
        .delete-btn {
            background: #ef476f;
            color: white;
        }
        
        .view-btn {
            background: #118ab2;
            color: white;
        }
        
        .action-btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        
        .no-books {
            text-align: center;
            padding: 60px 20px;
        }
        
        .no-books .icon {
            font-size: 80px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .no-books h2 {
            color: #666;
            margin-bottom: 10px;
        }
        
        .footer {
            text-align: center;
            color: white;
            margin-top: 30px;
            padding: 20px;
            font-size: 14px;
        }
        
        
        .search-filter {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .search-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 1;
            min-width: 300px;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        
        .filter-select {
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            background: white;
        }
        
        .search-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <i class="fas fa-book-reader"></i>
                Library Books Collection
            </h1>
            
            <div class="actions">
                <a href="Add-Book.html" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i> Add New Book
                </a>
                <a href="Dashboard.html" class="btn btn-secondary">
                    <i class="fas fa-home"></i> Dash board
                </a>
            </div>
        </div>
        
        <%
            
            String Url = "jdbc:mysql://localhost:3306/library_db";
            String Username = "root";
            String Password = "root"; 
            
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;
            
            try {
                
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                
                connection = DriverManager.getConnection(Url, Username, Password);
                
                // Get filter parameters
                String search = request.getParameter("search");
                String sortBy = request.getParameter("sort");
                
                
                String sql = "SELECT * FROM books";
                
                if (search != null && !search.trim().isEmpty()) {
                    sql += " WHERE title LIKE '%" + search + "%' OR author LIKE '%" + search + "%'";
                }
                
                if (sortBy != null) {
                    switch (sortBy) {
                        case "price_asc":
                            sql += " ORDER BY price ASC";
                            break;
                        case "price_desc":
                            sql += " ORDER BY price DESC";
                            break;
                        case "title":
                            sql += " ORDER BY title ASC";
                            break;
                        case "newest":
                            sql += " ORDER BY created_at DESC";
                            break;
                        default:
                            sql += " ORDER BY id DESC";
                    }
                } else {
                    sql += " ORDER BY id DESC";
                }
                
                statement = connection.createStatement();
                resultSet = statement.executeQuery(sql);
        %>
        
        <div class="content">
            <!-- Search and Filter Section -->
            <div class="search-filter">
                <form method="GET" action="ViewBook.jsp">
                    <div class="search-group">
                        <input type="text" 
                               name="search" 
                               placeholder="Search by title or author..." 
                               class="search-input"
                               value="<%= search != null ? search : "" %>">
                        
                        <select name="sort" class="filter-select">
                            <option value="">Sort by</option>
                            <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Newest First</option>
                            <option value="title" <%= "title".equals(sortBy) ? "selected" : "" %>>Title A-Z</option>
                            <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Price: Low to High</option>
                            <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Price: High to Low</option>
                        </select>
                        
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i> Search
                        </button>
                        
                        <a href="ViewBook.jsp" class="btn btn-secondary">
                            <i class="fas fa-redo"></i> Reset
                        </a>
                    </div>
                </form>
            </div>
            
            <!-- Statistics -->
            <%
                
                Statement countStmt = connection.createStatement();
                ResultSet countRs = countStmt.executeQuery("SELECT COUNT(*) as total, AVG(price) as avg_price, SUM(price) as total_value FROM books");
                countRs.next();
                int totalBooks = countRs.getInt("total");
                double avgPrice = countRs.getDouble("avg_price");
                double totalValue = countRs.getDouble("total_value");
                countRs.close();
                countStmt.close();
            %>
            
            <div class="stats-bar">
                <div class="stat-card">
                    <h3><i class="fas fa-book"></i> Total Books</h3>
                    <div class="value"><%= totalBooks %></div>
                </div>
                
                <div class="stat-card">
                    <h3><i class="fas fa-rupee-sign"></i> Average Price</h3>
                    <div class="value">₹<%= String.format("%.2f", avgPrice) %></div>
                </div>
                
                <div class="stat-card">
                    <h3><i class="fas fa-chart-line"></i> Total Value</h3>
                    <div class="value">₹<%= String.format("%.2f", totalValue) %></div>
                </div>
                
                <div class="stat-card">
                    <h3><i class="fas fa-database"></i> Database</h3>
                    <div class="value" style="color: #00b894;">Connected</div>
                </div>
            </div>
            
            <!-- Books Table -->
            <div class="table-container">
                <% if (totalBooks == 0) { %>
                    <div class="no-books">
                        <div class="icon"><i class="fas fa-book"></i></div>
                        <h2>No Books Found</h2>
                        <p>Your library is empty. Add some books to get started!</p>
                        <a href="Add-Book.html" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fas fa-plus"></i> Add First Book
                        </a>
                    </div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Cover</th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Price (₹)</th>
                                <th>Added On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
                                int count = 0;
                                
                                while (resultSet.next()) {
                                    count++;
                                    int id = resultSet.getInt("id");
                                    String title = resultSet.getString("title");
                                    String author = resultSet.getString("author");
                                    double price = resultSet.getDouble("price");
                                    java.sql.Timestamp createdAt = resultSet.getTimestamp("created_at");
                                    String isbn = resultSet.getString("isbn");
                            %>
                            <tr>
                                <td><%= id %></td>
                                <td>
                                    <div style="width: 40px; height: 50px; background: #667eea; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: white;">
                                        <i class="fas fa-book"></i>
                                    </div>
                                </td>
                                <td>
                                    <strong><%= title %></strong>
                                    <% if (isbn != null && !isbn.isEmpty()) { %>
                                        <br><small style="color: #666;">ISBN: <%= isbn %></small>
                                    <% } %>
                                </td>
                                <td><%= author %></td>
                                <td class="price">₹<%= String.format("%.2f", price) %></td>
                                <td><%= dateFormat.format(createdAt) %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                    
                    <!-- Pagination Info -->
                    <div style="padding: 15px; background: #f8f9fa; text-align: right; font-size: 14px; color: #666;">
                        Showing <%= count %> of <%= totalBooks %> books
                    </div>
                <% } %>
            </div>
            
            <!-- Export Options -->
            <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                <button class="btn btn-primary" onclick="printTable()">
                    <i class="fas fa-print"></i> Print List
                </button>
                <button class="btn btn-secondary" onclick="exportToExcel()">
                    <i class="fas fa-file-excel"></i> Export to Excel
                </button>
            </div>
        </div>
        
        <%
            } catch (ClassNotFoundException e) {
                out.println("<div style='background: #ffe6e6; padding: 20px; border-radius: 10px; margin: 20px 0; color: #cc0000;'>");
                out.println("<h2><i class='fas fa-exclamation-triangle'></i> Database Driver Error</h2>");
                out.println("<p>MySQL JDBC Driver not found!</p>");
                out.println("</div>");
                e.printStackTrace();
            } catch (SQLException e) {
                out.println("<div style='background: #ffe6e6; padding: 20px; border-radius: 10px; margin: 20px 0; color: #cc0000;'>");
                out.println("<h2><i class='fas fa-exclamation-triangle'></i> Database Error</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
                e.printStackTrace();
            } finally {
                // Close resources
                try {
                    if (resultSet != null) resultSet.close();
                    if (statement != null) statement.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
    
    
    <script>
        function printTable() {
            window.print();
        }
        
        function exportToExcel() {
            alert('Export to Excel feature would be implemented here!');
            // In real implementation, this would generate an Excel file
        }
        
        // Search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.querySelector('.search-input');
            if (searchInput) {
                searchInput.focus();
            }
        });
    </script>
</body>
</html>