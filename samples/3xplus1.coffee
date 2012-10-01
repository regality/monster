Monster = require("../index")

# returns the next job
getJob = (n, cb) ->
  cb n

# handle a job when it comes back
processJob = (n, job, done) ->
  while job isnt 1
    if job % 2 is 0 # even
      job /= 2
    else
      job = 3 * job + 1
  done null, true

# function to take care of job when it is done
finishJob = (n, job, passed) ->
  unless passed
    console.log "found one!"
    console.log job

# start listening
monster = new Monster(getJob, processJob, finishJob)
monster.setN 2
monster.batch 100000
monster.listen 8080
