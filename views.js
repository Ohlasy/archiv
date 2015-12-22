function parseJekyllDate(dateString) {
    var JSCompatibleDateString = dateString.replace(" +0000", "").replace(" ", "T")
    return new Date(JSCompatibleDateString)
}

function renderDate(date) {
    var monthNames = ["ledna", "února", "března", "dubna", "května",
        "června", "července", "srpna", "září", "října", "listopadu", "prosince"]
    return date.getUTCDate() + ". " + monthNames[date.getUTCMonth()] + " " + date.getUTCFullYear()
}

function renderArticlePreview(article) {
    var link = $('<a/>', { 'href': 'http://ohlasy.info' + article.relativeURL })
    var div = $('<div/>', {'class': 'article-preview'})
    var dateStamp = renderDate(parseJekyllDate(article.pubDate))
    link.append($('<h2/>').html(article.title))
    link.append($('<p/>', {'class': 'article-perex'}).html(article.perex))
    link.append($('<p/>', {'class': 'article-meta text-muted'}).html(article.author + " / " + dateStamp))
    div.append(link)
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
