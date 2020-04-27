var args = {  }
var fs = require('fs');
var sourceMap = require('source-map');

process.argv.slice(2).forEach(arg=>{
  var [key,value] = arg.split("=")
  args[key] = value || true
})

const start = async function(){
  let map = fs.readFileSync(args['map'], 'utf8')

  const consumer = await new sourceMap.SourceMapConsumer(map);
  let result = consumer.originalPositionFor({ line: args['line'], column: args['column'] })

  console.log(result)
}

start()
