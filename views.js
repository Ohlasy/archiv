function renderArticlePreview(article) {
    var link = $('<a/>', { 'href': 'http://ohlasy.info' + article.relativeURL })
    var div = $('<div/>', {'class': 'article'})
    link.append($('<h2/>').html(article.title))
    div.append(link)
    div.append($('<p/>').html(article.perex))
    return div
}

function renderSearchResults(results) {
    var container = $('<div/>')
    if (results.length > 0) {
        results.forEach(function(article) {
            container.append(renderArticlePreview(article))
        })
    } else {
        container.append($('<p/>').html("Této kombinaci neodpovídá žádný článek."))
    }
    return container
}
