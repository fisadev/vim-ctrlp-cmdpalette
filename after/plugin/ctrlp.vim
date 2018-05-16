if !exists('g:loaded_ctrlp') || !g:loaded_ctrlp
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! CtrlPCmdPalette call ctrlp#init(ctrlp#cmdpalette#id())
command! -nargs=0 CmdPaletteReload call ctrlp#cmdpalette#load_commands_info()

let &cpo = s:save_cpo
unlet s:save_cpo
