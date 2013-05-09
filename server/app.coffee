Server = require './net/server'

debug = true

# can add stuff to webserver, debug visualisations etc here
class App

	webserver: null
	server: null

	constructor: (@webserver, @express) ->
		@server = new Server @webserver

		if debug?
			require('./debug/debugger') @express, @server

module.exports = App