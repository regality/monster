Monster = require("../index")

# returns the next job
getJob = (n, cb) ->
  cb n

# handle a job when it comes back
processJob = (n, job, done) ->
  l = Math.floor(Math.sqrt(n))

  for i in [2..l]
    return done(null, false)  if n % i is 0
  done null, true

# function to take care of job when it is done
finishJob = (n, job, isPrime) ->
  # only print a few, so we don't block the cpu
  if Math.floor(Math.random() * 1e5 % 500) is 0
    console.log job + " is prime"  if isPrime

# max time before we assume a job is lost
timeout = 10000

# start listening
monster = new Monster(getJob, processJob, finishJob)
monster.setTimeout timeout
monster.setN 1000000
monster.batch 200000
monster.listen 8080
