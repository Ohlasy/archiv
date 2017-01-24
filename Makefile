.PHONY: app
all: app
app:
	mkdir build
	cp analytics.js index.html style.css build/
	elm-make src/App.elm --output build/archiv.js
clean:
	rm -rf build
