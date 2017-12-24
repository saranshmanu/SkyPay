/**
 * Created by abhi on 25-Oct-17.
 */

var mongoose = require('mongoose');             // Import Mongoose Package
var Schema   = mongoose.Schema;                 // Assign Mongoose Schema function to variable
var bcrypt   = require('bcrypt-nodejs');        // Import Bcrypt Package
var titlize  = require('mongoose-title-case');  // Importing Mongo name title plugin
var validate = require('mongoose-validator');   // Importing Mongoose Validator Plugin



// IEEE Member Mongoose Schema
var MemberSchema = new Schema({
    name:     { type: String, required: true, validator: nameValidator },
    regno:    { type: String, required: true, validator: regnoValidator, unique: true },
    password: { type: String, required: true, validator: passwordValidator},
    email:    { type: String, required: true, validator: emailValidator, lowercase: true, unique: true },
    phoneno:  { type: String, required: true, validator: phonenoValidator},
    componentsIssued: [{
        name: {type:String},
        code: {type: String},
        quantity:{type:String},
        date: {type:String},
        returned: {type:String, default: false}
    }]
});

// All the validators
// User Name Validation
var nameValidator = [
    validate({
        validator: 'matches',
        arguments: /^(([a-zA-Z]{3,30})+[ ]+([a-zA-Z]{3,30})+)+$/,
        message: 'Name must be at least 3 characters, max 30, no special characters or numbers, must have space in between name.'
    }),
    validate({
        validator: 'isLength',
        arguments: [3, 30],
        message: 'Name should be between {ARGS[0]} and {ARGS[1]} characters'
    })
];

// User E-mail Validator
var emailValidator = [
    validate({
        validator: 'matches',
        arguments: /^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,4}$/,
        message: 'Name must be at least 3 characters, max 40, no special characters or numbers, must have space in between name.'
    }),
    validate({
        validator: 'isLength',
        arguments: [3, 50],
        message: 'Email should be between {ARGS[0]} and {ARGS[1]} characters'
    })
];

// Registration Number Validator (Reg expression to be made)
var regnoValidator = [
    validate({
        validator: 'isLength',
        message: 'Registration number should be of 9 characters'
    }),
    validate({
        validator: 'matches',
        arguments: '/^[\w\-\s]+$/',
        message:   'Enter valid VIT Registration number.'
    })
];
// Phoneno Validator
var phonenoValidator = [
    validate({
        validator: 'matches',
        arguments: /^[\s()+-]*([0-9][\s()+-]*){6,20}$/,
        message: 'Should not contain alphabets or special characters'
    }),
    validate({
        validator: 'isLength',
        arguments: [6, 20],
        message: 'Password should be between {ARGS[0]} and {ARGS[1]} characters'
    })
];

// Password Validator
var passwordValidator = [
    validate({
        validator: 'matches',
        arguments: /^(?=.*?[A-Z])(?=.*?[\d]).{8,25}$/,
        message: 'Password needs to have at least one uppercase, one number and must be at least 8 characters but no more than 25.'
    }),
    validate({
        validator: 'isLength',
        arguments: [8, 25],
        message: 'Password should be between {ARGS[0]} and {ARGS[1]} characters'
    })
];

// Mongoose Plugin to change fields to title case after saved to database (ensures consistency)
MemberSchema.plugin(titlize, {
    paths: ['name']
});


MemberSchema.pre('save', function(next) {
    var user = this;
    bcrypt.hash(user.password, null, null, function (err, hash) {
        if (err)
            return next(err);
        user.password=hash;
        next();

    });
});

//All the models from MemberSchema will be saved in the collection named "members" in the database
module.exports = mongoose.model('member',MemberSchema, 'members');