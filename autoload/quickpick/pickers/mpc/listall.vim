vim9script

import {mpc, format} from "../mpc.vim"

def quickpick#pickers#mpc#listall#open(): void
  call quickpick#pickers#mpc#open("listall", [], {
    format: {
      view: format,
      file: "%file%",
    }
  }, {
    on_accept: function("s:on_accept"),
    key: "view"
  })
enddef

def s:on_accept(data: dict<list<dict<string>>>, name: string): void
  call quickpick#close()
  call system(mpc .. " add " .. shellescape(data["items"][0]["file"]))
enddef
