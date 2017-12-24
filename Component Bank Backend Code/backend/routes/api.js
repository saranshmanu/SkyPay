/**
 * Created by abhi on 25-Oct-17.
 */

var member        = require('../model/member');
var component     = require('../model/component');
var jwt           = require('jsonwebtoken');
var secret        = "asdfghjklpoiuytrewqzxcvbnmmmmmmmmuytrdftyghuytfdrtj";
var bcrypt        = require('bcrypt-nodejs');


module.exports = function (router) {

    //Route for login authentication
    router.post('/login', function(req, res){
        member.findOne({email: req.body.email}, function(err, output){
            if (err){
                console.log(err);
                res.json({success: false, message: "An error occured"});
            } else {
                if (!output)
                    res.json({success:false, message:"No user exists with these details"});
                else{
                    if (!bcrypt.compareSync(req.body.password, output.password))
                        res.json({success:false, message:"Wrong password entered"});
                    else
                        res.json({success:true, message:"User authenticated successfully", name: output.name, regnum: output.regno, email: output.email, phonenum: output.phoneno});
                }
            }
        });
    });

    //Route for registering a user
    router.post('/register', function(req, res){
        var newMember = new member({
            name: req.body.name,
            regno: req.body.username,
            email: req.body.email,
            password: req.body.password,
            phoneno: req.body.phoneno
        });

        // Creating an empty object at the time of registration to avoid the NullPointerException in Android java
        newMember.componentsIssued.push({
            name: "",
            code: "",
            quantity:"",
            date: ""
        });

        //Saving the member in the database after checking whether the email already exists or not
        newMember.save(function(err){
            if (err){
                console.log(err);
                if (err.code == 11000)
                    res.json({success: false, message:"A user with same details already exists"});
                else
                    res.json({success: false, message:"An error occured"});
            } else
                res.json({success: true, message: "User registered successfully"});
        });

    });

    //Route for listing the details of the currently issued components of the user which will be displayed in the User Profile Fragment
    router.post('/currentlyIssuedComponents', function(req, res){
        member.findOne({email: req.body.email}).exec(function(err, output){
            if (err){
                console.log(err);
                res.json({success: false, message: "An error occured"});
            } else {
                res.json({success:true, message: "User details displayed successfully", number: output.componentsIssued.length - 1, componentsIssued: output.componentsIssued});
            }
        })
    });

    //profile of the member after login
    router.post('/me',function (req,res) {
        res.send(req.decoded);
    });

    // Route for getting the list of components with all their details
    router.get('/getcomponents',function (req,res) {
        component.find({}).exec(function (err,comp) {
            if(err){
                res.json({success:"false",message:"An error occured while loading the components"});
            }
            else{
                res.json({success:"true",message:"List of components ", components: comp});
            }
        })
    });

    // -----For ADMIN only-------. To register a component
    router.post('/registerComponent',function (req,res) {
        var ieee = new component({
            name: req.body.name,
            code: req.body.code,
            value: req.body.value,
            quantity: req.body.quantity,
            issuedBy:{
                name:"",
                regnum:"",
                phonenum:"",
                email: "",
                issuedOn: "",
                returned: false
            }
        });
    //Checking empty enteries in the form
        if (req.body.name === null || req.body.name === '' || req.body.code === null || req.body.code === ''  ||  req.body.value === null || req.body.value === '') {
            res.json({success:false,message:'Ensure name, code and value were provided'});
        }
        else {
            ieee.save(function (err) {
                if (err) {
                    if(err.errors !== null )
                    {
                        res.json({success:false, message: err.errors});
                    }
                    else if(err){
                        res.json({ success: false, message: "problem occured" }); // Display any other error
                    }
                }
                else {
                    res.send({success:true, message:'Component Registered'});
                }
            });
        }
    });

    // Route for issuing a component by user
    router.post('/issueComponent',function (req,res) {
        component.findOne({code:req.body.componentcode}).exec(function (err,ieee){
            if (err){
                console.log(err);
                res.json({success:false, message: "An error occured"});
            } else {
                var issuer = {
                    name: req.body.issuedbyname,
                    regnum: req.body.issuedbyregnum,
                    phonenum: req.body.issuedbyphonenum,
                    email: req.body.issuedbyemail,
                    issuedOn: req.body.issuedondate,
                    quantity: req.body.number,
                    returned: false
                };

                ieee.issuedBy.push(issuer);
                ieee.quantity = parseInt(ieee.quantity) - parseInt(req.body.number);
                ieee.save(function(err){
                    if (err){
                        console.log(err);
                        res.json({success:false, message:"An error occured"});
                    } else {
                        member.findOneAndUpdate({email:req.body.issuedbyemail},
                            {$push:{
                                componentsIssued:{
                                    name: ieee.name,
                                    code: req.body.componentcode,
                                    quantity: req.body.number,
                                    date: req.body.issuedondate
                                }
                            }
                            }, function(err){
                                if (err){
                                    console.log(err);
                                    res.json({success:false, message: "An error occured"});
                                } else {
                                    res.json({success:true, message: "Component issued successfully"});
                                }
                            });
                    }
                });
            }
        });
    });

    return router;
};