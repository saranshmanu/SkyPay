/**
 * Created by abhi on 25-Oct-17.
 */

var mongoose = require('mongoose');             // Import Mongoose Package
var Schema   = mongoose.Schema;                 // Assign Mongoose Schema function to variable
var bcrypt   = require('bcrypt-nodejs');        // Import Bcrypt Package



// IEEE Memeber Mongoose Schema
var ComponentSchema = new Schema({ //component details
    name:           { type: String, required: true },
    code:           { type: String, required: true },
    quantity:       { type: String, default:"0"},
    value:          { type: String, required: true},
    issuedBy:
            [{ //issuer details
            name:  { type: String, default:"" },
            regnum:  { type: String, default:"" },
            phonenum:  { type: String, default:"" },
            email:  { type: String, default:"" },
            issuedOn:  { type: String, default:"" },
            quantity: {type: String, default: ""},
            returned:  { type: Boolean }
            }]
});

module.exports = mongoose.model('component',ComponentSchema, "components");