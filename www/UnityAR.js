var exec = require("cordova/exec");

var UnityAR = {
  launchUnity: function (arg0, success, error) {
    exec(success, error, "UnityAR", "launchUnity", [arg0]);
  },
  launchWithMessage:function(gameObject,method,argument,success,error){
    var arg = {"gameobject":gameObject,"method":method,"argument":argument};
    exec(success,error,"UnityAR","launchwithMessage",[arg]);
  }
};

module.exports = UnityAR;
