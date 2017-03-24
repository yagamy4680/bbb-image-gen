#!/usr/bin/env lsc
#
require! <[fs path]>

parse-pkg-list = (filepath) ->
  data = fs.readFileSync filepath
  return null unless data?
  text = data.to-string!
  xs = text.split '\n'
  xs = [ x.split '\t' for x in xs ]
  xs = { [x[0], x[1]] for x in xs }
  return xs

[interpreter, script, file1, file2] = process.argv
xs = parse-pkg-list file1
ys = parse-pkg-list file2
return console.log "failed to parse #{file1}" unless xs?
return console.log "failed to parse #{file2}" unless ys?
xs-keys = [ k for k, v of xs ]
ys-keys = [ k for k, v of ys ]

file1 = path.basename file1
file2 = path.basename file2

only-in-file1 = [ k for k, v of xs when not (k in ys-keys) ]
only-in-file2 = [ k for k, v of ys when not (k in xs-keys) ]
differences = [ k for k, v of xs when xs[k] isnt ys[k] ]

if only-in-file1.length > 0
  console.log "### Packages in #{file1}"
  [ console.log "  - #{x}: `#{xs[x]}`" for x in only-in-file1 ]
  console.log ""

if only-in-file2.length > 0
  console.log "### Packages in #{file2}"
  [ console.log "  - #{y}: `#{ys[y]}`" for y in only-in-file2 ]
  console.log ""

return unless differences.length > 0
console.log """
### Differences between #{file1} and #{file2}

| name | #{file1} | #{file2} |
|---|---|---|
"""
[ console.log "| #{d} | `#{xs[d]}` | `#{ys[d]}` |" for d in differences ]

# [ console.log "- #{d}\n  - #{xs[d]}\n  - #{ys[d]}" for d in differences ]

