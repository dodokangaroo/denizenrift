Handler = require './handler'
CMD = require '../cmds'
Jobs = require '../../data/jobs'

class CmdSetJob extends Handler

	constructor: (@server, @connection) ->
		super @server, @connection

	handle: (data) ->

		if data.length is 2
			job = data[1]
			@connection.user.job = job
			@connection.broadcast [CMD.SC.SET_JOB, user.id, job]

module.exports = CmdSetJob