all: npmInstall test compile

npmInstall:
	npm install

test:
	PATH="$(PATH):./node_modules/.bin/" mocha --reporter spec --compilers coffee:coffee-script/register

compile:
	mkdir -p lib
	PATH="$(PATH):./node_modules/.bin/" browserify -t coffeeify --extension=".coffee" src/p2pPacket.coffee > lib/p2pPacket.bundle.js
	PATH="$(PATH):./node_modules/.bin/" uglifyjs lib/p2pPacket.bundle.js -o lib/p2pPacket.bundle.min.js

develop: npmInstall
	fswatch "./src/:./test/" "make test"

clean:
	rm -rf node_modules lib

.PHONY: all npmInstall test compile develop clean
