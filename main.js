var React = require('react')
var ReactDOM = require('react-dom')
var ohlasy = require("./lib/ohlasy.js")
var views = require("./lib/views.js")

$.getJSON('http://ohlasy.info/api/articles.js', function(articles) {
    var archive = new ohlasy.Archive(articles)
    archive.filters = [
        archive.filterForField("author", "Autor"),
        archive.filterForField("category", "Rubrika"),
        archive.filterForField("serial", "Seriál"),
    ]
    ReactDOM.render(
        <views.ArchiveView archive={archive} />,
        document.getElementById('archive')
    );
})
