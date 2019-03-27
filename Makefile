.PHONY: app
all: app
app:
	mkdir -p build
	cp -R static/* build/
	npx elm make src/App.elm --output build/archiv.js
test:
	npx elm-test
testw:
	find src tests | entr -c npx elm-test
clean:
	rm -rf build
