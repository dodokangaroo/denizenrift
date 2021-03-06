require './ui.coffee'
require './game.coffee'
require './data/config.coffee'
require './net/cmdhandler.coffee'
require './net/connection.coffee'
require './net/cmds.coffee'

class App

	ui: null
	con: null
	user: null

	constructor: ->
		# page load
		$().ready =>

			@ui = new UI
			# disable mouse dragging the canvas
			@ui.disableDrag()

			# show connecting anim
			@ui.showSpinner()
			
			console.log 'Connecting'
			# connect websocket
			@connect =>

				console.log 'Connected'

				# wait for server to send us cmd list
				@getCmdList =>
					
					@ui.hideSpinner()
					@ui.showLogin()

					@login()

	connect: (fn) ->
		@con = new Connection
		@con.connect Config.Server, =>
			fn() fn?
		, =>
			# just reload page on disconnect for now
			document.location.reload()

	getCmdList: (fn) ->
		handler = new CmdHandler @, @con
		# this is to receive updated cmd list from server
		handler.setHandlers CmdHandler.Factory.startHandlers()
		# set handler
		@con.handler = handler

		# wait for cmd list from server
		handler.intercept = (id) =>
			# make sure it's the correct msg"
			if id is CMD.SC.SET_CMDS
				handler.intercept = null
				handler.setHandlers CmdHandler.Factory.mainHandlers()
				fn() if fn?

	login: =>

		$(document).keydown (e) =>
			if e.which is Key.ENTER
				@ui.login.btnLogin.click()

		@ui.login.btnLogin.click =>

			user = @ui.login.txtUsername.val()
			pass = @ui.login.txtPassword.val()

			@ui.login.txtUsername.removeClass 'error'
			@ui.login.txtPassword.removeClass 'error'

			err = false

			@ui.login.txtStatus.html ''

			if user.length < 4
				err = true
				@ui.login.txtUsername.addClass 'error'
				@ui.login.txtStatus.append '<p>Username must be 4 or more chars</p>'
			if pass.length < 6
				err = true
				@ui.login.txtPassword.addClass 'error'
				@ui.login.txtStatus.append '<p>Password must be 6 or more chars</p>'

			if !err
				@ui.hideLogin()
				@ui.showSpinner()

				@ui.login.txtPassword.val ''

				console.log 'Logging in'

				@con.send [CMD.CS.LOGIN, user, pass]

	loginSuccess: (@user) ->
		console.log 'Login success'
		@ui.hideSpinner()
		$(document).unbind 'keydown'
		@ui.login.btnLogin.unbind 'click'

		@lobby()

	loginFailed: ->
		console.log 'Login failed'
		@ui.hideSpinner()
		@ui.showLogin()
		$('.spinner').addClass 'invisible'
		@ui.login.txtStatus.html 'Authentication failed'

	lobby: ->
		@ui.showLobby()

		@ui.lobby.btnFindGame.click =>

			@ui.hideLobby()
			@ui.showSpinner()
			# find a 5v5 game
			@con.send [CMD.CS.FIND_GAME, 10]

	joinedRoom: (roomID, users) ->
		@ui.hideSpinner()
		@ui.showPreGameLobby()

		@ui.initPreGameLobbyHeroes Config.Jobs

		@ui.preGameLobby.me.name.html @user.name

		@ui.heroBoxes().live 'click', (e) =>
			heroID = $(e.currentTarget).attr 'value'
			#@ui.heroBoxes().unbind 'click'

			herobox = @ui.preGameLobby.me.hero
			# remove all classes
			herobox.removeClass()
			herobox.addClass 'portrait'
			herobox.addClass "hero#{heroID}"

# begin
new App