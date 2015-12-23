var buster = require("buster");
var assert = buster.referee.assert;
var refute = buster.referee.refute;

buster.testCase("Buster", {
    "works": function () {
        assert(true);
    }
});
