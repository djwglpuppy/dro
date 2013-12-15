express = require('express')
app = express()
stylus = require('stylus')

app.configure ->
    @set('views', __dirname + '/views')
    @set('view engine', 'jade')

app.configure "development", ->
    @use(express.logger("dev"))
    @use stylus.middleware
        src: __dirname + '/views'
        dest: __dirname + '/static'
        debug: true
        force: true
        compile: (str, path) -> 
            stylus(str)
            .set('filename', path)
            .set('compress', true)
            .use(require("nib")())
            .import('nib')

    @use(express.static(__dirname + '/static'))

app.configure "production", ->
    @use(express.static(__dirname + '/static'))

app.get '/', (req, res) ->
    res.render('root')

if app.settings.env is "development"
    app.listen(3000)
    console.log "Starting in Development Node"

console.log app.settings.env