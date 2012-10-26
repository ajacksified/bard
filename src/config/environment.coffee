# This was basically lifted from the Mincer docuemntation. It handles setting
# up the compilation for js, css, etc. You shouldn't have to do annything here.
#
# I added automatic template bundling, since Mincer doesn't have Mustache
# support baked in. Like the others, you'll call it once to compile everything.

UglifyJS = require('uglify-js')
Csso = require('csso')
Mincer = require('mincer')
path = require('path')
fs = require('fs')

Mincer.logger.use(console)

module.exports = (app) ->
  templateCache = {}

  is_production = app.config.environment == "production"

  environment = new Mincer.Environment(__dirname + "/..")

  assetPath = app.config.assetPath || "assets"
  environment.appendPath(app.config.jsPath || 'assets/js')
  environment.appendPath(app.config.cssPath || 'assets/css')
  environment.appendPath(app.config.imgPath || 'assets/img')

  environment.registerHelper('asset_path', (logicalPath) ->
    console.warn("looking for#{logicalPath}")

    asset = environment.findAsset(logicalPath)

    unless asset
      throw new Error("File " + logicalPath + " not found")

    return "/#{assetPath}/" + asset.digestPath
  )

  rewrite_extension = (source, ext) ->
    source_ext = path.extname(source)

    if source_ext == ext
      source
    else
      if is_production
        (source + ext).replace(/(\.less|\.coffee)/, "")
      else
        source + ext

  find_asset_paths = (logicalPath, ext) ->
    asset = environment.findAsset(logicalPath)
    paths = []

    unless asset
      return null

    if !is_production && asset.isCompiled
      asset.toArray().forEach((dep) ->
        paths.push("/#{assetPath}/" + rewrite_extension(dep.logicalPath, ext) + '?body=1')
      )
    else
      paths.push("/#{assetPath}/" + rewrite_extension(asset.digestPath, ext))

    return paths

  viewHelpers = {}

  viewHelpers.javascript = javascript = (logicalPath) -> 
    paths = find_asset_paths(logicalPath, '.js')

    unless paths
      return '<script type="application/javascript">alert("Javascript file ' +
             JSON.stringify(logicalPath).replace(/"/g, '\\"') +
             ' not found.")</script>'

    return paths.map((path) ->
      return '<script type="application/javascript" src="' + path + '"></script>'
    ).join('\n')


  viewHelpers.stylesheet = stylesheet = (logicalPath) ->
    paths = find_asset_paths(logicalPath, '.css')

    unless paths
      return '<script type="application/javascript">alert("Stylesheet file ' +
             JSON.stringify(logicalPath).replace(/"/g, '\\"') +
             ' not found.")</script>'

    return paths.map((path) ->
      return '<link rel="stylesheet" type="text/css" href="' + path + '" />'
    ).join('\n')


  walk = (dir, done) ->
    results = []

    fs.readdir dir, (err, list) ->

      return done(err)  if err

      pending = list.length

      return done(null, results)  unless pending

      list.forEach (file) ->
        file = dir + "/" + file
        fs.stat file, (err, stat) ->
          if stat and stat.isDirectory()
            walk file, (err, res) ->
              results = results.concat(res)
              done null, results  unless --pending
          else
            results.push file
            done null, results  unless --pending

  loadTemplate = (logicalPath) ->
    try
      str = fs.readFileSync(__dirname + "/../#{app.config.templatePath}/#{logicalPath}.mustache", 'utf8')
      templateCache[logicalPath] = str

    return str

  viewHelpers.template = template = (logicalPath) ->
    return templateCache[logicalPath] if templateCache[logicalPath]
    return loadTemplate(logicalPath)

  viewHelpers.cacheTemplates = (fn) ->
    walk "#{__dirname}/../#{app.config.templatePath}", (err, results) ->
      for r in results
        relativePath = r.split(app.config.templatePath + "/")[1].replace(/\.mustache/,'')
        template(relativePath)

      try
        fs.mkdirSync("#{__dirname}/../#{app.config.jsPath}/build", (err) ->)

      fs.writeFileSync("#{__dirname}/../#{app.config.jsPath}/build/templates.js", "window.templates=" + JSON.stringify(templateCache))

      fn(templateCache)

  viewHelpers.returnTemplateCache = ->
    templateCache

  environment.viewHelpers = viewHelpers

  if is_production
    environment.jsCompressor = (context, data, callback) ->
      try
        ast = UglifyJS.parser.parse(data)

        ast = UglifyJS.uglify.ast_mangle(ast)
        ast = UglifyJS.uglify.ast_squeeze(ast)

        callback(null, UglifyJS.uglify.gen_code(ast))
      catch err 
        callback(err)

    environment.cssCompressor = (context, data, callback) ->
      try
        callback(null, Csso.justDoIt(data))
       catch err
        callback(err)

  environment
