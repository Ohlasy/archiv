.PHONY: app
all: app
app:
	mkdir -p build
	cp -R static/* build/
	npx elm make src/App.elm --output build/archiv.js
server:
	cd build; python -m SimpleHTTPServer 8080
refresh: app
	open http://localhost:8080
test:
	npx elm-test
clean:
	rm -rf build
