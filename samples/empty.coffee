monster = require("../index")

# returns the next job
getJob = (n) ->
  # function body

# function to take care of job when it is done
finishJob = (n, data) ->
  # function body

# handle a job when it comes back
progress = (n, job, data) ->
  # function body

# max time before we assume a job is lost
timeout = 10000

# start listening
monster(getJob, processJob, finishJob, timeout).listen 8080
