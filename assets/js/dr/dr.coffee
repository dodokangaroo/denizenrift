#= require game

$().ready ->

	login (user) ->
		selectHero user, (hero) ->
			game = new Game user, hero
			game.run()

login = (fn) ->

	#show spinner while nowjs connects
	$('.login').removeClass 'invisible'

	now.ready ->

		$('.input').removeClass 'invisible'
		$('.spinner').addClass 'invisible'

		$(document).keydown (e) =>
			if e.which is Key.ENTER
				$('.btnlogin').click()

		$('.btnlogin').click =>

			user = $('.txtusername').val()
			pass = $('.txtpassword').val()

			$('.txtusername').removeClass 'error'
			$('.txtpassword').removeClass 'error'

			err = false

			$('.txtstatus').html ''

			if user.length < 4
				err = true
				$('.txtusername').addClass 'error'
				$('.txtstatus').append '<p>Username must be 4 or more chars</p>'
			if pass.length < 6
				err = true
				$('.txtpassword').addClass 'error'
				$('.txtstatus').append '<p>Password must be 6 or more chars</p>'

			if !err
				$('.input').addClass 'invisible'
				$('.spinner').removeClass 'invisible'

				$('.txtpassword').val ''

				now.login user, pass, (res) =>
					
					if res.success
						$('.login').addClass 'invisible'

						$(document).unbind 'keydown'
						$('.btnlogin').unbind 'click'


						fn res.user
					else
						$('.input').removeClass 'invisible'
						$('.spinner').addClass 'invisible'
						$('.txtstatus').html 'Authentication failed'

selectHero = (user, fn) ->

	$('.selecthero').removeClass 'invisible'

	for i, hero of Config.Classes
		$('.selectherobox').append """
									<div class='herobox' value='#{i}'>
										<div class='portrait hero#{i}'></div>
										<div class='name unselectable'>#{hero.Name}</div>
									</div>
								   """

	$('.herobox').live 'click', (e) =>

		$('.selecthero').addClass 'invisible'

		heroIndex = $(e.currentTarget).attr 'value'

		$('.herobox').unbind 'click'

		fn heroIndex