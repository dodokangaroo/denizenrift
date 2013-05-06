Jobs = require '../data/jobs'

class CmdSetJob 

	constructor: (@user, @server) ->

		user.socket.on 'setjob', (job) =>
			user.job = Jobs[job]
			user.socket.broadcast.emit 'setjob', user.id, job

module.exports = CmdSetJob