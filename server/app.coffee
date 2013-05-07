Server = require './net/server'

# can add stuff to webserver, debug visualisations etc here
class App

	webserver: null
	server: null

	constructor: (@webserver) ->
		@server = new Server webserver

module.exports = App