var React = require('react')
var ReactDOM = require('react-dom')
var ohlasy = require("./ohlasy.js")
var views = require("./views.js")

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
}).fail(function() {
    $('#progress').html('Při načítání seznamu článků došlo k chybě. Obětujte kohouta a zkuste to znovu, případně později.')
})
