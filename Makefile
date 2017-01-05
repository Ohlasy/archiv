all: archiv.js
archiv.js: src/App.elm 
	elm-make $< --output $@
