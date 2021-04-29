vim9script

import {mpc, format} from "../mpc.vim"

def quickpick#pickers#mpc#listall#open(): void
  call quickpick#pickers#mpc#open("listall", [], {
    format: {
      view: format,
      file: "%file%",
    }
  }, {
    on_accept: function("s:OnAccept"),
    key: "view",
  })
enddef

def OnAccept(data: dict<list<dict<string>>>, name: string): void
  call quickpick#close()

  call system(join([
    mpc,
    "add",
    shellescape(data["items"][0]["file"]),
  ], " "))
enddef
