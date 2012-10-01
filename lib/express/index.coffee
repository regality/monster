express = require("express")
http = require("http")
path = require("path")
app = express()

app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", (req, res, next) ->
  res.locals
    process: do app.monster.processJob.toString
  res.render("index")

app.get "/job", (req, res, next) ->
  app.monster.next (err, n, job) ->
    res.json
      n: n
      job: job

app.get "/jobs", (req, res, next) ->
  app.monster.nextBatch (err, jobs) ->
    res.json
      jobs: jobs
      batch: Math.floor(jobs[0].n / jobs.length)

app.post "/finish", (req, res, next) ->
  results = JSON.parse(req.body.results)
  for result in results
    app.monster.finish result.n, result.result
  res.json
    ok: true

module.exports =
  monster: (monster) ->
    app.monster = monster
    @

  listen: (port, cb) ->
    app.set "port", port
    http.createServer(app).listen app.get("port"), =>
      console.log "Express server listening on port " + app.get("port")
      @

