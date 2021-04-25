let s:mpc = get(g:, "quickpick_mpc_command", "mpc")
let s:format = get(g:, "quickpick_mpc_format", "%file%")
let s:maxheight = get(g:, "quickpick_mpc_maxheight", 10)

let s:position = "%position%"
let s:delimiter = "_____delimiter_____"

function! quickpick#pickers#mpc#playlist#open() abort
  call quickpick#open({
  \ "items": s:get_items(),
  \ "on_accept": function("s:on_accept"),
  \ "key": "view",
  \ "maxheight": s:maxheight,
  \})
endfunction

function! s:get_items() abort
  let l:format = s:position . s:delimiter . s:format
  let l:command = s:mpc . " --format " . shellescape(l:format) . " playlist"

  return map(
  \ split(system(l:command), "\n"),
  \ {
  \   v -> call(
  \     {
  \       l -> {
  \         "view": l[1],
  \         "position": l[0],
  \       }
  \     },
  \     [split(v:val, s:delimiter)],
  \   )
  \ }
  \)
endfunction

function! s:on_accept(data, name) abort
  call quickpick#close()
  call system(s:mpc . " play " . shellescape(a:data["items"][0]["position"]))
endfunction
