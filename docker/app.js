const express = require('express');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Sample data
let books = [
    { id: 1, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald' },
    { id: 2, title: '1984', author: 'George Orwell' }
];

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'Welcome to the Book API' });
});

// Get all books
app.get('/api/books', (req, res) => {
    res.json(books);
});

// Get book by id
app.get('/api/books/:id', (req, res) => {
    const book = books.find(b => b.id === parseInt(req.params.id));
    if (!book) return res.status(404).json({ message: 'Book not found' });
    res.json(book);
});

// Create new book
app.post('/api/books', (req, res) => {
    const book = {
        id: books.length + 1,
        title: req.body.title,
        author: req.body.author
    };
    books.push(book);
    res.status(201).json(book);
});

// Delete book
app.delete('/api/books/:id', (req, res) => {
    const book = books.find(b => b.id === parseInt(req.params.id));
    if (!book) return res.status(404).json({ message: 'Book not found' });
    
    const index = books.indexOf(book);
    books.splice(index, 1);
    res.json({ message: 'Book deleted' });
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
