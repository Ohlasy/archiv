.PHONY: app
all: app
app:
	mkdir -p build
	cp -R static/* build/
	npx elm make src/App.elm --output build/archiv.js
open: app
	(sleep 1; open http://localhost:8080)&
	cd build; python -m SimpleHTTPServer 8080
test:
	npx elm-test
testw:
	find src tests | entr -c npx elm-test
clean:
	rm -rf build
