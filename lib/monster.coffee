waitress = require('waitress')

class Monster
  constructor: (nextJob, processJob, finishJob) ->
    @nextJob = nextJob
    @processJob = processJob
    @finishJob = finishJob
    @timeout = 1000
    @pending = {}
    @n = 0
    @batchSize = 1

  batch: (size) ->
    @batchSize = size

  setN: (n) ->
    @n = n

  setTimeout: (timeout) ->
    @timeout = timeout

  nextN: (cb) ->
    @n += 1
    cb @n

  next: (cb) ->
    @nextN (n) =>
      job = @nextJob n, (job) =>
        @pending[n] = job
        cb null, n, job

  nextBatch: (cb) ->
    done = waitress @batchSize, cb
    for i in [1..@batchSize]
      @next (err, n, job) ->
        done null,
          n: n
          job: job

  process: (n, job) ->
    progress = ->
    @processJob n, job, progress, (result) =>
      @finish n, result

  finish: (n, result) ->
    job = @pending[n]
    delete @pending[n]
    @finishJob(n, job, result)

  listen: (port, cb) ->
    require('./express')
      .monster(@)
      .listen(port, cb)

module.exports = Monster
