vim9script

import {mpc, format} from "../mpc.vim"

def quickpick#pickers#mpc#playlist#open(): void
  call quickpick#pickers#mpc#open("playlist", [], {
    format: {
      view: format,
      position: "%position%",
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
    "play",
    shellescape(data["items"][0]["position"])
  ], " "))
enddef
