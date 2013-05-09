express = require 'express'
http = require 'http'
gzippo = require 'gzippo'

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

app.get '/', require("#{__dirname}/routes/index")

console.log 'Starting Denizen Rift Server'

Server = require '../server/app'
new Server server, app