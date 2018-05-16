" =============================================================================
" File:          autoload/ctrlp/cmdpalette.vim
" Description:   cmdpalette extension for ctrlp.vim.
"                Some of the code is based on the code of the
"                plugins at github.com/sgur/ctrlp-extensions.vim
" =============================================================================

let g:loaded_ctrlp_cmdpalette = 1

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
let s:cmdpalette_var = {
	\ 'init': 'ctrlp#cmdpalette#init()',
	\ 'accept': 'ctrlp#cmdpalette#accept',
	\ 'lname': 'cmdpalette',
	\ 'sname': 'cmdp',
	\ 'type': 'tabs',
	\ 'sort': 0,
	\ }


" Pre-load the vim commands list
let s:cmdpalette_commands = []

if !exists('g:ctrlp_cmdpalette_execute')
  let g:ctrlp_cmdpalette_execute = 0
endif

" inspired by the same done in the python-mode plugin
if has('python')
  let s:python_cmd = "python"
elseif has('python3')
  let s:python_cmd = "python3"
else
  echo "Could't initialize CtrlP CmdPalette: needs a python interpreter in vim"
  finish
endif

let s:path_to_commands = printf("%s/%s", expand("<sfile>:p:h"), "internal_commands.txt")

function! ctrlp#cmdpalette#load_commands_info()

execute s:python_cmd . "<< endofpython"
import vim
import json

# obtain the internal commands (file distributed with the plugin)
path_to_script = vim.eval('expand("<sfile>:p")')
path_to_commands = vim.eval('s:path_to_commands')
with open(path_to_commands) as commands_file:
    internal_commands = [l.strip() for l in commands_file.readlines()]

# obtain the custom commands
vim.command('redir => custom_commands')
vim.command('silent command')
vim.command('redir END')

# convert to list, remove empties, discard 4 first columns and take first word
custom_commands = [x[4:].split()[0] + '\t(custom command)'
                   for x in vim.eval('custom_commands').split('\n')
                   if x.strip()]
# remove header
if custom_commands[0].split('\t')[0] == 'Name':
    del custom_commands[0]

vim.command('let s:cmdpalette_commands = %s' % json.dumps(internal_commands + custom_commands))

endofpython

endfunction

call ctrlp#cmdpalette#load_commands_info()

" Append s:cmdpalette_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:cmdpalette_var)
else
  let g:ctrlp_ext_vars = [s:cmdpalette_var]
endif


" This will be called by ctrlp to get the full list of elements
" where to look for matches
function! ctrlp#cmdpalette#init()
  return s:cmdpalette_commands
endfunction


" This will be called by ctrlp when a match is selected by the user
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#cmdpalette#accept(mode, str)
  call ctrlp#exit()
  redraw
  let g:ctrlp_open_mode = a:mode
  let g:ctrlp_open_cmd = a:str
  call feedkeys(':', 'n')
  call feedkeys(split(a:str, '\t')[0], 'n')
  if a:mode == 'e' && g:ctrlp_cmdpalette_execute == 1
    call feedkeys("\<CR>", 'n')
  else
    call feedkeys(" ", 'n')
  endif
  call remove(s:cmdpalette_commands, index(s:cmdpalette_commands, a:str))
  call insert(s:cmdpalette_commands, a:str)
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#cmdpalette#id()
  return s:id
endfunction


" vim:fen:fdl=0:ts=2:sw=2:sts=2
