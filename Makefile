.PHONY: app
all: app
app:
	mkdir -p build
	cp -R static/* build/
	npx elm make $(FLAGS) src/App.elm --output build/archiv.js
production: FLAGS=--optimize
production: app
server:
	cd build; python -m SimpleHTTPServer 8080
refresh: app
	open http://localhost:8080
test:
	npx elm-test
clean:
	rm -rf build
