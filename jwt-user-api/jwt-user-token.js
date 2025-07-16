const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();
// Middleware to parse JSON bodies
app.use(express.json());

const secretKey = 'EvkZteEII1cfvDExdY3mBq4O7jQgHh88';

const users = [
    { id: 1, name: 'Jawn', email: 'jawn@abc.com' },
    { id: 2, name: 'Ibnu', email: 'ibnu@abc.com' },
    { id: 3, name: 'Patrick', email: 'patrick@abc.com' }
];

// Middleware to authenticate token
function authenticateToken(req, res, next) {
    const token = req.headers['authorization'];
    if (!token) {
        return res.status(403).send('A token is required for authentication');
    }
    try {
        const decoded = jwt.verify(token.replace('Bearer ', ''), secretKey);
        req.user = decoded;
        next();
    } catch (err) {
        return res.status(401).send('Invalid Token');
    }
}

// Route to login and generate token
app.post('/login', (req, res) => {
    const { email } = req.body;

    // Find the user with the provided email
    const user = users.find(u => u.email === email);
    if (!user) {
        return res.status(404).send('User not found');
    }

    // Generate JWT Token with user ID and email as payload
    const token = jwt.sign({ id: user.id, email: user.email }, secretKey, { expiresIn: '1h' });

    // Return the token
    res.status(200).json({ token });
});

// Get users (public, no authentication)
app.get('/users', (req, res) => {
    const userIds = users.map(user => ({ id: user.id }));
    res.status(200).json(userIds);
});

// Get specific user (protected, authentication required)
app.get('/users/:id', authenticateToken, (req, res) => {
    const user = users.find(u => u.id === parseInt(req.params.id));
    if (user) {
        res.status(200).json(user);
    } else {
        res.status(404).send('User not found');
    }
});

// Create a new user (protected, authentication required)
app.use(express.json()); 

app.post('/users', authenticateToken, (req, res) => {
    const { id, name, email } = req.body;

    // Validate if all required fields are provided
    if (!id || !name || !email) {
        return res.status(400).send('ID, name, and email are required');
    }

    // Check if the user ID or email already exists
    const userExists = users.some(user => user.id === id || user.email === email);
    if (userExists) {
        return res.status(409).send('User ID or email already exists');
    }

    // Add the new user to the array
    const newUser = { id, name, email };
    users.push(newUser);

    // Respond with the updated user list
    res.status(201).json(newUser);
});

// Start the server
app.listen(3002, () => {
    console.log('Server running on port 3002');
});
