var Filter = function(propertyName, possibleValues, label) {

    this.propertyName = propertyName
    this.possibleValues = possibleValues
    this.label = label || propertyName
    this.currentValue = null

    this.predicate = function(candidate) {
        return (this.currentValue == null) ? true :
            candidate[propertyName] == this.currentValue
    }
}

var Archive = function(articles) {

    this.allArticles = articles
    this.filters = []

    this.allValuesForField = function(fieldName) {
        var values = []
        this.allArticles.forEach(function(article) {
            values[article[fieldName]] = 1
        })
        return Object.keys(values)
    }

    this.filteredArticles = function() {
        var survivors = this.allArticles
        this.filters.forEach(function(f) {
            survivors = survivors.filter(f.predicate.bind(f))
        })
        return survivors
    }

    this.filterForField = function(fieldName, label) {
        return new Filter(fieldName, this.allValuesForField(fieldName), label || fieldName)
    }
}

module.exports.Archive = Archive
module.exports.Filter = Filter
