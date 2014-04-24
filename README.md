network-layer
=============

This is a simple network overlay for the ufo network.

[![GithubTag](http://img.shields.io/github/tag/ufojs/network-layer.svg)](https://github.com/ufojs/network-layer)
[![Build Status](https://travis-ci.org/ufojs/network-layer.svg?branch=master)](https://travis-ci.org/ufojs/network-layer)
[![devDependency Status](https://david-dm.org/ufojs/network-layer/dev-status.svg)](https://david-dm.org/ufojs/network-layer#info=devDependencies)
[![Stories in Ready](https://badge.waffle.io/ufojs/network-layer.png?label=ready&title=Ready)](https://waffle.io/ufojs/network-layer)
[![Gittip](http://img.shields.io/gittip/b3by.svg)](https://www.gittip.com/b3by/)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://badges.mit-license.org)

Usage
-----
Clone the repo, install what is needed, then run all tests.

```
git clone https://github.com/ufojs/network-layer.git
npm install
npm test
```

If you want to clean the project, simply run ```npm clean```.

If you love the boar, feel free to use Grunt instead of npm:

```
grunt installDeps
grunt integration-test
grunt karma
...
grunt clean
```

Classes
-------

```Client``` : performs the actual communication with the application

```Peer``` : manages the underlying WebRTC layer

```List``` : simple peer container used by the client
