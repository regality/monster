log = (args...) ->
  message = args.join(' ')
  $(".logs div:gt(10)").remove()
  div = $ "<div/>"
  div.text message
  $(".logs").prepend div

$("#donut").donutchart
  size: 300
  fgColor: "#F52887"

lastPercent = 0
progress = (percent) ->
  percent = Math.round(percent * 100)
  if percent != lastPercent
    if percent > lastPercent
      $("#donut").donutchart("animate", lastPercent, percent)
    else
      $("#donut").donutchart("animate", 0, percent)
    lastPercent = percent

finishBatch = (batch) ->
  $.ajax '/finish',
    type: 'POST'
    data:
      results: JSON.stringify(batch.results)
    success: ->
      progress 1
      log "done with batch", batch.batch
      setTimeout ->
        do fetchNextBatch
      , 500

fetchNextBatch = ->
  log "fetching next batch"
  progress 0
  $.ajax '/jobs',
    success: processBatch

processBatch = (batch) ->
  batch.current = if batch.current is undefined then 0 else batch.current + 1
  progress batch.current / batch.jobs.length
  batch.results ?= []

  if batch.current is batch.jobs.length
    return finishBatch batch

  job = batch.jobs[batch.current]
  processNext job, (err, result) ->
    if err
      batch.results.push
        error: err
    else
      batch.results.push
        n: job.n
        result: result
    # don't let call stack get too tall
    if batch.current % 1000 is 0
      setTimeout ->
        processBatch batch
      , 0
    else
      processBatch batch

processNext = (data, cb) ->
  # log "processing job number", data.n
  processJob data.n, data.job, cb

processJob = window.process

do fetchNextBatch
