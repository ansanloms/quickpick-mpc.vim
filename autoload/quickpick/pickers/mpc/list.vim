vim9script

import mpc from "../mpc.vim"

var selectedType: string

def quickpick#pickers#mpc#list#open(type: string): void
  selectedType = type
  call quickpick#pickers#mpc#open("list", [type], {}, {
    on_accept: function("s:on_accept"),
    key: null,
  })
enddef

def s:on_accept(data: dict<list<string>>, name: string): void
  call quickpick#close()
  call system(mpc .. " findadd " .. selectedType .. " " .. shellescape(data["items"][0]))
enddef
