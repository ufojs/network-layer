all: npmInstall test compile

npmInstall:
	npm install

test:
	PATH="$(PATH):./node_modules/.bin/" mocha --reporter spec --compilers coffee:coffee-script/register

compile:
	mkdir -p lib
	PATH="$(PATH):./node_modules/.bin/" browserify -t coffeeify --extension=".coffee" src/ufoPacket.coffee -s ufo > lib/ufoPacket.bundle.js
	PATH="$(PATH):./node_modules/.bin/" uglifyjs lib/ufoPacket.bundle.js -o lib/ufoPacket.bundle.min.js

develop: npmInstall
	fswatch "./src/:./test/" "make test"

clean:
	rm -rf node_modules lib

.PHONY: all npmInstall test compile develop clean
