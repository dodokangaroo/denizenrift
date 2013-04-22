express = require 'express'
http = require 'http'
gzippo = require 'gzippo'
sio = require 'socket.io'

app = express()

#change root directory updating all uris etc
root = ''
title = 'Denizen Rift'

app.configure ->
	app.set 'views', __dirname + '/views'
	app.set 'view engine', 'jade'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser()
	app.use express.session
		secret: 'catsridingdodokangaroos'
	app.use require('connect-assets') 
		build:false
	app.use app.router
	app.use express.static(__dirname + '/assets')
	app.locals 
		layout: false
		pretty: true
		root: root
		title: title

app.configure 'development', ->
	app.use express.errorHandler 
		dumpExceptions: true
		showStack: true

app.configure 'production', ->
	oneYear = 31557600000
	app.use express.static(__dirname + '/public', maxAge: oneYear)
	app.use express.errorHandler()

server = app.listen 80, =>
	console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

io = sio.listen server
io.set 'log level', 1

app.get root + '/', require('./routes/index')

Server = require './server/server'
new Server server, io
