Vim-CtrlP-CmdPalette
====================

This is an extension for the awesome vim `CtrlP <https://github.com/ctrlpvim/ctrlp.vim>`_ plugin.

This extension adds a new CtrlP command, the ``:CtrlPCmdPalette``, which allows you to find and run vim commands (internal or custom).

Installation
------------

First you will need to have `CtrlP <https://github.com/kien/ctrlp.vim>`_ installed and a vim compiled with python support. Once you have that:

* If you use `Vim-plug <https://github.com/junegunn/vim-plug>`_, add this to your plugins list: ``Plug 'fisadev/vim-ctrlp-cmdpalette'``.
* If you use `Vundle <https://github.com/gmarik/vundle>`_, add this to your bundles list: ``Bundle 'fisadev/vim-ctrlp-cmdpalette'``.
* If you use `Patogen <https://github.com/tpope/vim-pathogen>`_, clone this repo inside your bundles dir.

Done! Now you can call ``:CtrlPCmdPalette``, or map it to a keybinding :)

Options
-------
If you want the selected command to be executed by default, add this to your .vimrc

``let g:ctrlp_cmdpalette_execute = 1``

Thanks
------
Special thanks to the creator of `this plugin <https://github.com/sgur/ctrlp-extensions.vim>`_, which allowed me to learn how to extend CtrlP.

