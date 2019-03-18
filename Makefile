.PHONY: app
all: app
app:
	mkdir -p build
	cp -R img/ analytics.js index.html style.css build/
	npx elm make src/App.elm --output build/archiv.js
clean:
	rm -rf build
