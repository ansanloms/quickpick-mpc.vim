let s:mpc = get(g:, "quickpick_mpc_command", "mpc")
let s:format = get(g:, "quickpick_mpc_format", "%file%")
let s:maxheight = get(g:, "quickpick_mpc_maxheight", 10)

let s:file = "%file%"
let s:delimiter = "_____delimiter_____"

function! quickpick#pickers#mpc#list#open() abort
  call quickpick#open({
  \ "items": s:get_items(),
  \ "on_accept": function("s:on_accept"),
  \ "on_change": function("s:on_change"),
  \ "key": "view",
  \ "maxheight": s:maxheight,
  \})
endfunction

function! s:get_items(...) abort
  let l:query = get(a:000, 0, v:null)
  let l:format = s:file . s:delimiter . s:format
  let l:command = s:mpc . " --format " . shellescape(l:format) . " " . (empty(l:query) ? "listall" : "search any " . shellescape(l:query))

  return map(
  \ split(system(l:command), "\n"),
  \ {
  \   v -> call(
  \     {
  \       l -> {
  \         "view": l[1],
  \         "file": l[0],
  \       }
  \     },
  \     [split(v:val, s:delimiter)],
  \   )
  \ }
  \)
endfunction

function! s:on_accept(data, name) abort
  call quickpick#close()
  call system(s:mpc . " add " . shellescape(a:data["items"][0]["file"]))
endfunction

function! s:on_change(data, name) abort
  return s:get_items(a:data["input"])
endfunction
