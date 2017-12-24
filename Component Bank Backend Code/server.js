var express       = require('express');           // Experss JS Framework
var app           = express();
var morgan        = require('morgan');            // Import Morgan Package
var port          = process.env.PORT||8800;       // Setting Server Port
var mongoose      = require('mongoose');          // HTTP request logger middleware for Node.js
var bodyParser    = require('body-parser');       // (Middleware) Parses incoming request bodies in a middleware before your handlers
var router        = express.Router();             // Importing Router
var approutes     = require('./backend/routes/api')(router); //calling api from routes
var path          = require('path');              // Inbuilt feature



app.use(morgan('dev'));                             // Morgan Middleware
app.use(bodyParser.json());                         // Body-parser middleware
app.use(bodyParser.urlencoded({ extended: true })); // For parsing application/x-www-form-urlencoded
app.use('/api',approutes);                          // Using api from routes folder in app(backend route)


//------------------------ Database connection with server--------------------------------------

mongoose.connect('mongodb://techloop:nTDDF5Ag7QZC5S0El8g3oKg12NAxKdsXlHoPrfrE8nzKKVCgsV4Kpkd5l1nEwFSilTugMUtgKFSzOiOdpcGP2g==@techloop.documents.azure.com:10255/?ssl=true&replicaSet=globaldb', function(err) {
    if (err)
        console.log('Not connected to the database: ' + err); // Console msg if unable to connect to database
     else
        console.log('Successfully connected to MongoDB');     // Console meg if able to connect to database
});
/*
mongoose.connect('mongodb://localhost:27017/ieeecomponentbank', function(err) {
    if (err) {
        console.log('Not connected to the database: ' + err); // Console msg if unable to connect to database
    } else {
        console.log('Successfully connected to MongoDB');     // Console meg if able to connect to database
    }
});*/

//Start of a server
app.listen(port,function() {                                // Server is working on this port config
    console.log('Running the server on port ' + port);
});