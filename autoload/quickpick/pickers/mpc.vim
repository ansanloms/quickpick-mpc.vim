vim9script

export const mpc = get(g:, "quickpick_mpc_command", "mpc")
export const format = get(g:, "quickpick_mpc_format", "%flie%")
export const maxheight = get(g:, "quickpick_mpc_maxheight", 10)

const delimiter = "_____delimiter_____"

def quickpick#pickers#mpc#open(
  command: string,
  subcommands: list<string>,
  options: dict<any>,
  quickpickOptions: dict<any>,
): void
  var items = GetItems(command, subcommands, options)
  if match(keys(quickpickOptions), "items") != -1
    echo quickpickOptions["items"]
    items = quickpickOptions["items"] + items
    unlet quickpickOptions["items"]
  endif

  call quickpick#open(extend(quickpickOptions, { items: items }))
enddef

def GetCommand(
  command: string,
  subcommands: list<string>,
  options: dict<any>,
): string
  return join([
    mpc,
    command,
    join(values(mapnew(options, (i, v) => "--" .. i .. "=" .. shellescape(i == "format" ? join(values(mapnew(v, (i2, v2) => i2 .. ":" .. v2)), delimiter) : v))), " "),
    join(subcommands, " "),
  ], " ")
enddef

def GetItems(
  command: string,
  subcommands: list<string>,
  options: dict<any>,
): list<any>
  const execute = split(system(GetCommand(
    command,
    subcommands,
    options,
  )), "\n")

  if match(keys(options), "format") != -1
    const result = []
    for line in mapnew(execute, (i, v) => split(v, delimiter))
      var record = {}
      for item in mapnew(line, (i, v) => split(v, ":", 1))
        record[item[0]] = join(item[1 :], ":")
      endfor
      call add(result, record)
    endfor
    return result
  else
    return execute
  endif
enddef
