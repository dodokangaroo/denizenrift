module.exports = 

	login: (user, pass, fn) ->
		fn 
			user:
				name: user
			success: true

	register: (user, pass, fn) ->
		fn 
			success: true