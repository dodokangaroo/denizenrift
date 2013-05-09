## Denizen Rift

An HTML5 Multiplayer Game built with.

* NodeJS
* CoffeeScript
* Jade
* Stylus
* WS
* Express
* Browserify
* Oryx LOFI Sprites CC (http://forums.tigsource.com/index.php?topic=8970.0)

## Installing

sudo ./install.sh

## Running

sudo ./run.sh

Windows:
	
	Open two terminals and run:

	> wr -v --exec "browserify -t coffeeify ./client/app.coffee > ./webserver/assets/js/app.js" client &
	> coffee webserver/app.coffee

## Structure

All the client code is in the client folder, it is written in coffee-script
and compiled with browserify into a single file. This file gets placed into
webserver/assets/app.js

The server code is found in the server folder and it is written in coffee-script
and uses WS to handle websocket connections and data. It is loaded by 
the webserver and listens on the same port.

The webserver is started at webserver/app.coffee, it is a simple webserver
which provides all the game images, js, css etc.