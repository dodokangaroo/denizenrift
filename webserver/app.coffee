express = require 'express'
http = require 'http'
gzippo = require 'gzippo'
sio = require 'socket.io'

require 'coffee-script'

app = express()

title = 'Denizen Rift'

app.configure ->
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'jade'
	app.use require('connect-assets')
		build:false
		src: "#{__dirname}/assets"
	app.use app.router
	app.use express.static("#{__dirname}/assets")
	app.locals 
		layout: false
		pretty: true
		title: title

server = app.listen 80, =>
	console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

io = sio.listen server
io.set 'log level', 1 #disable logging
io.set 'close timeout', 10

app.get '/', require("#{__dirname}/routes/index")

Server = require '../server/server'
new Server server, io
