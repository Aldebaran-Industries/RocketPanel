// RocketPanel.js

// Imports
const express = require('express');
const compression = require('compression');
const cookieParser = require('cookie-parser');

// Create a new express app
const app = express();
const port = process.env.PORT || 3000;  // Use the PORT environment variable or default to 3000

// Middleware
app.use(compression());
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set('trust proxy', true);

// Routes
app.get('*', (request, response, next) => {
    // Check if the installation was successful- if not then start the installation.
    // If the installation was successful, return a success message.
    // TODO: Implement logic to check for installation success. For now, always return a success message.
    // Example:
    // const installationSuccessful = await checkInstallationSuccess();
    // if (!installationSuccessful) {
    //     startInstallation();
    // }
    response.status(200).json({
        status: 200,
        message: 'OK',
        data: {
            message: 'RocketPanel is preparing to LAUNCH!'
        }
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });