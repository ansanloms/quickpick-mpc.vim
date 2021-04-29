vim9script

import {mpc, format} from "../mpc.vim"

var selectedType: string

def quickpick#pickers#mpc#list#open(type: string): void
  selectedType = type
  call quickpick#pickers#mpc#open("list", [type], {}, {
    on_accept: function("s:OnAccept"),
    key: null,
  })
enddef

def OnAccept(data: dict<list<string>>, name: string): void
  call quickpick#close()

  call quickpick#pickers#mpc#open("find", [
    selectedType,
    shellescape(data["items"][0]),
  ], {
    format: {
      view: format,
      file: "%file%",
    },
  }, {
    on_accept: function("s:OnAdd"),
    key: "view",
    items: [{
      view: "-- All play",
      file: "",
      query: data["items"][0],
    }],
  })
enddef

def OnAdd(data: dict<list<dict<string>>>, name: string): void
  call quickpick#close()

  if match(keys(data["items"][0]), "query") != -1
    call system(join([
      mpc,
      "findadd",
      selectedType,
      shellescape(data["items"][0]["query"]),
    ], " "))
  else
    call system(join([
      mpc,
      "add",
      shellescape(data["items"][0]["file"]),
    ], " "))
  endif
enddef
