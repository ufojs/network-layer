all: npmInstall test

npmInstall:
	npm install

test:
	PATH="$(PATH):./node_modules/.bin/" mocha --reporter spec --compilers coffee:coffee-script/register

develop: npmInstall
	fswatch "./src/:./test/" "make test"

.PHONY: all npmInstall test develop
