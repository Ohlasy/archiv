var React = require('react')

var DateView = React.createClass({
    render: function() {
        var jekyllDateString = this.props.dateString
        var JSCompatibleDateString = jekyllDateString.replace(" +0000", "").replace(" ", "T")
        var date = new Date(JSCompatibleDateString)
        var monthNames = ["ledna", "února", "března", "dubna", "května", "června",
            "července", "srpna", "září", "října", "listopadu", "prosince"]
        return (
            <span>{date.getUTCDate() + ". " + monthNames[date.getUTCMonth()]
                + " " + date.getUTCFullYear()}</span>
        )
    }
})

var ArticleView = React.createClass({
    render: function() {
        var article = this.props.article
        return (
            <div className="article-preview">
            <a href={article.relativeURL}>
                <h2>{article.title}</h2>
                <p className="article-perex">{article.perex}</p>
                <p className="text-muted article-meta">{article.author} / 
                    <DateView dateString={article.pubDate}/></p>
            </a>
            </div>
        )
    }
})

var FilterView = React.createClass({
    noFilterPlaceholder: "nehraje roli",
    didChangeSelection: function(sender) {
        var selectedValue = sender.target.value
        var filterValue = (selectedValue == this.noFilterPlaceholder) ? null : selectedValue
        this.props.filter.currentValue = filterValue
        this.props.updateHandler()
    },
    render: function() {
        var filter = this.props.filter
        return (
            <div className="archive-filter-select">
            <label>{filter.label}</label>
            <select onChange={this.didChangeSelection}>
                <option>{this.noFilterPlaceholder}</option>
                {filter.possibleValues.map(function(value, i) {
                    return <option key={i}>{value}</option>
                })}
            </select>
            </div>
        );
    }
})

var ArchiveView = React.createClass({
    getInitialState: function() {
        return {'articles': this.props.archive.filteredArticles()}
    },
    updateHandler: function() {
        this.setState({"articles": this.props.archive.filteredArticles()})
    },
    render: function() {
        var articles = this.state.articles
        var filters = this.props.archive.filters
        return (
            <div className="archive">
                <div className="controls">{
                filters.map(function(f, i) {
                    return <FilterView filter={f} key={i}
                        updateHandler={this.updateHandler}/>
                }, this)
                }</div>
                <div className="article-results">{
                articles.map(function(article, i) {
                    return <ArticleView article={article} key={i}/>
                })
                }</div>
            </div>
        )
    }
})

module.exports.ArchiveView = ArchiveView
module.exports.FilterView = FilterView
module.exports.ArticleView = ArticleView