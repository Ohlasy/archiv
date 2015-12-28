all: client/bundle.js
client/bundle.js: src/*.js
	browserify -t [ babelify --presets [ react ] ] src/main.js -o $@
