" =============================================================================
" File:          autoload/ctrlp/cmdpalette.vim
" Description:   cmdpalette extension for ctrlp.vim, based on code from the
"                plugins at github.com/sgur/ctrlp-extensions.vim
" =============================================================================

" Change the name of the g:loaded_ variable to make it unique
if ( exists('g:loaded_ctrlp_cmdpalette') && g:loaded_ctrlp_cmdpalette )
	\ || v:version < 700 || &cp
	finish
endif
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
	\ 'type': 'line',
	\ 'sort': 0,
	\ }


" Append s:cmdpalette_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:cmdpalette_var)
else
	let g:ctrlp_ext_vars = [s:cmdpalette_var]
endif


" Provide a list of strings to search in
"
" Return: command
function! ctrlp#cmdpalette#init()
python << endofpython
import vim
vim.command('redir => commands_list')
vim.command('silent command')
vim.command('redir END')
commands = [x[4:].split(' ')[0]
            for x in vim.eval('commands_list').split('\n')
            if x.strip()]

vim.command('return split("%s")' % ' '.join(commands))
endofpython
endfunction


" The action to perform on the selected string.
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#cmdpalette#accept(mode, str)
  call ctrlp#exit()
  call feedkeys(':')
  call feedkeys(a:str)
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#cmdpalette#id()
  return s:id
endfunction


" vim:fen:fdl=0:ts=2:sw=2:sts=2
