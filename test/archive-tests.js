var buster = require("buster")
var ohlasy = require("../src/ohlasy.js")

var assert = buster.referee.assert

var articles = [
    {"author": "Miles", "title": "Foo"},
    {"author": "Miles", "title": "Bar"},
    {"author":  "Monk", "title": "Baz"}
]

buster.testCase("Archive", {
    "create": function() {
        assert.isObject(new ohlasy.Archive())
    },
    "enumerate property values": function() {
        var archive = new ohlasy.Archive(articles)
        assert.equals(archive.allValuesForField("author"), ["Miles", "Monk"])
        assert.equals(archive.allValuesForField("title"), ["Foo", "Bar", "Baz"])
    },
    "filter": function() {
        var archive = new ohlasy.Archive(articles)
        assert.equals(archive.allArticles, articles)
        assert.equals(archive.filteredArticles(), articles)
        var authorFilter = archive.filterForField("author")
        assert.isObject(authorFilter)
        authorFilter.currentValue = "Miles"
        archive.filters = [authorFilter]
        assert.equals(archive.filteredArticles(), [
            {"author": "Miles", "title": "Foo"},
            {"author": "Miles", "title": "Bar"}
        ])
        authorFilter.currentValue = "Monk"
        assert.equals(archive.filteredArticles(), [
            {"author":  "Monk", "title": "Baz"}
        ])
        assert.equals(archive.allArticles, articles)
    }
});
