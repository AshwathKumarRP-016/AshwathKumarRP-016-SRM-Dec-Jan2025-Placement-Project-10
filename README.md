# 📚 **Library Book Manager**  

CLICK Library Management System-> CLICK src --> CLICK main --> CLICK java -->library --> SERVLET Library.java FILE  | CLICK webapp ---> Dashboard.html -->AddBook.html--> ViewBook.jsp


## ⚡ **What's This?**  
A **complete library management system** built with Java Servlets + JSP + MySQL! Add books, view collections, search, sort - all in one beautiful dashboard.

## 🎯 **Core Features**
```
📥 ADD BOOKS → Admin enters book details (Title, Author, Price)
📊 VIEW ALL → Beautiful table with all books
🔍 SEARCH → Find books by title/author
📈 STATS → Total books, average price, collection value
🛠️ ACTIONS → View, Edit, Delete options for each book
```

## 🏗️ **Architecture**
```
[HTML Forms] → [Java Servlet] → [MySQL Database] ← [JSP Pages]
       ↑              ↑               ↑               ↑
    Add Book       Processes       Stores Data    Displays Books
```


## 📁 **Project Structure**
```
LibrarySystem/
├── 📋 index.html              # Dashboard
├── ➕ add-book.html           # Add book form
├── 📖 view-books.jsp          # View all books (JSP)
├── ⚙️ LibraryServlet.java     # Servlet (Adds books)
├── 🗄️ library_db.sql         # Database setup
└── ⚙️ web.xml                # Configuration
```

## 🔄 **Servlet Lifecycle Magic**
```java
init()     → "Hello Database!" 🤝
service()  → "Processing request..." ⚙️  
destroy()  → "Goodbye Database!" 👋
```


## 🎨 **UI Highlights**
- **Gradient Backgrounds** 🌈
- **Interactive Tables** 📊
- **Hover Effects** ✨
- **Responsive Design** 📱💻
- **Icons Everywhere** 🎯

## 🧪 **Test It!**
1. **Add a Book**: "Harry Potter", "J.K. Rowling", ₹699
2. **View All**: Click "View Books" button
3. **Search**: Try "Potter" in search box
4. **Sort**: Click price column header
5. **Stats**: Check the statistics panel


## 🎬 **Demo Flow**
```
1. Open dashboard (index.html)
2. Click "Add New Book"
3. Fill form → Submit
4. See success message
5. Click "View All Books"
6. Browse, search, sort!
```

