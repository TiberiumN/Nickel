import macros
import strutils
import command

var count {.compiletime.} = 1


macro command*(cmds: varargs[string], body: untyped): untyped =
  let 
    # Unique name for each handler procedure
    uniqName = newIdentNode("handler"& $count)
  var 
    usage = ""
    moduleUsages: seq[string] = @[]
    procBody = newStmtList()
  # If we have `usage = something`
  if body[0].kind == nnkAsgn:
    let text = body[0][1]
    
    # If it's an array like ["a", "b"]
    if text.kind == nnkBracket:
      for i in 0..<len(text):
        moduleUsages.add(text[i].strVal)
    # If it's a string or a triple-quoted string
    elif text.kind == nnkStrLit or text.kind == nnkTripleStrLit:
      procBody = newStmtList()
      usage = text.strVal
    # Add actual handler code except line with usage
    for i in 1..<body.len:
      procBody.add body[i]
  # Add to global usages only if usage is not an empty string
  if len(usage) > 0:
    usages.add(usage)
  #result = quote do:
  #  const usage = `usage` 
  # If there's some strings in moduleUsages
  if moduleUsages != @[]:
    for x in moduleUsages:
      # Add to global usages
      if x != "": usages.add(x)
  # Increment counter for unique procedure names
  inc count

  let 
    api = newIdentNode("api")
    msg = newIdentNode("msg")
  result = quote do:
    proc `uniqName`(`api`: VkApi, `msg`: Message) {.async.} = 
      `procBody`
    # Commands for this handler
    const cmds = `cmds`
    # Call proc.handle(cmds) from command.nim
    handle(`uniqName`, cmds)

macro module*(name: string, body: untyped): untyped = 
  modules.add(name.strVal)
  result = newStmtList()
  for i in 0..<len(body):
    result.add(body[i])
  
#[ 
macro vk*(b: untyped): untyped = 
  var apiCall = ""
  for i in 0..<b[0].len:
    let part = b[0][i]
    apiCall &= $part & "."
  # Remove `.` at the end
  apiCall = apiCall[0..^1]
  result = quote do:
    api.callMethod(`apiCall`, )
]#