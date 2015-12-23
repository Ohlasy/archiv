var buster = require("buster")
var ohlasy = require("../lib/Ohlasy.js")

var assert = buster.referee.assert
var refute = buster.referee.refute

buster.testCase("Filter", {
    "create": function() {
        assert.isObject(new ohlasy.Filter())
    },
    "predicate": function() {
        var filter = new ohlasy.Filter("author", ["Miles", "Monk"])
        assert.isNull(filter.currentValue)
        assert.isTrue(filter.predicate("anything"))
        filter.currentValue = "Miles"
        assert.isFalse(filter.predicate("anything"))
        assert.isFalse(filter.predicate({"author": "Monk"}))
        assert.isTrue(filter.predicate({"author": "Miles"}))
    }
});
