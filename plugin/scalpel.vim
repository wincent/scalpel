" Copyright 2016-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

""
" @header
"
" @image https://raw.githubusercontent.com/wincent/scalpel/media/scalpel.png center
" @image https://raw.githubusercontent.com/wincent/scalpel/media/scalpel.gif center
"
"
""
" @plugin scalpel Scalpel plug-in for Vim
"
" Intro                                                            *scalpel-intro*
"
" Scalpel provides a streamlined shortcut for replacing all instances of the
" word currently under the cursor throughout a file.
"
" In normal mode pressing `<Leader>e` (mnemonic: "edit") will display a prompt
" pre-populated with the current word and with the cursor placed so that you
" can start typing the desired replacement:
" >
"     :Scalpel/\v<foo>//
" <
" Press `<Enter>` and Scalpel will prompt to confirm each substitution, starting
" at the current word (unlike a normal `:%s` command, which starts at the top of
" the file).
"
" Scalpel works similarly in visual mode with three different map behaviors. See
" |scalpel-mappings| or |scalpel-configuration| for more information.
"
" Screencasts that show Scalpel in action:
"
" - https://youtu.be/YwMgnmZNWXA: "Vim screencast #13: Multiple Cursors"
" - https://youtu.be/7Bx_mLDBtRc: "Vim screencast #14: *Ncgn"
" - https://youtu.be/iNVyCPPYFzc: "Vim screencast #21: Scalpel update"
"
" Note that `:Scalpel` just calls through to an underlying `scalpel#substitute`
" function that does the real work, ultimately calling Vim's own `:substitute`.
" As such, be aware that whatever changes you make to the command-line prior
" to pressing `<Enter>` must keep it a valid pattern, or bad things will happen.
"
" Installation                                              *scalpel-installation*
"
" To install Scalpel, use your plug-in management system of choice.
"
" If you don't have a "plug-in management system of choice" and your version
" of Vim has `packages` support (ie. `+packages` appears in the output of
" `:version`) then you can simply place the plugin at a location under your
" `'packpath'` (eg. `~/.vim/pack/bundle/start/scalpel` or similar).
"
" For older versions of Vim, I recommend
" [Pathogen](https://github.com/tpope/vim-pathogen) due to its simplicity and
" robustness. Assuming that you have Pathogen installed and configured, and
" that you want to install Scalpel into `~/.vim/bundle`, you can do so with:
" >
"     git clone https://github.com/wincent/scalpel.git ~/.vim/bundle/scalpel
" <
" Alternatively, if you use a Git submodule for each Vim plug-in, you could do
" the following after `cd`-ing into the top-level of your Git superproject:
" >
"     git submodule add https://github.com/wincent/scalpel.git ~/vim/bundle/scalpel
"     git submodule init
" <
" To generate help tags under Pathogen, you can do so from inside Vim with:
" >
"     :call pathogen#helptags()
" <
"
" Configuration                                            *scalpel-configuration*
"
" The default mappings can be suppressed by setting:
" >
"     let g:ScalpelMap=0
" <
" Or overridden:
" >
"     " Use <Leader>s instead of default <Leader>e:
"     nmap <Leader>s <Plug>(Scalpel)
" <
" In any case, Scalpel won't overwrite any pre-existing mapping that you might
" have defined for `<Leader>e`, nor will it create an unnecessary redundant
" mapping if you've already mapped something to `<Plug>(Scalpel)`.
"
" The `:Scalpel` command name can be overridden if desired. For example, you
" could shorten it to `:S` with:
" >
"     let g:ScalpelCommand='S'
" <
" Then your Scalpel prompt would look like:
" >
"     :S/\v<foo>//
" <
" The command can be entirely suppressed by setting `g:ScalpelCommand` to an
" empty string:
" >
"     let g:ScalpelCommand=''
" <
" The default visual mode behavior restricts substituion to the selection range.
" This is the |<Plug>(ScalpelVisual)| map. An additional visual mode map is
" available, which pulls the visual selection in as the substitution match
" pattern. This is the |<Plug>(ScalpelVisualSelection)| map. The command can be
" mapped to complement the default visual mode behavior. For example:
" >
"     vnormap <leader>x <Plug>(ScalpelVisualSelection)
" <
" You might alternatively replace the default visual mode behavior by overriding
" the default maps lhs. For example:
" >
"     vnormap <leader>e <Plug>(ScalpelVisualSelection)
" <
" Finally, all plug-in functionality can be deactivated by setting:
" >
"     let g:ScalpelLoaded=1
" <
" in your `~/.vimrc`.
"
" Mappings                                                      *scalpel-mappings*
"
" <Plug>(Scalpel)<<Plug>(Scalpel)
"
" Displays a prompt pre-populated with the current word and with the cursor
" placed so that you can start typing the desired replacement:
" >
"     :Scalpel/\v<foo>//
" <
" Press `<Enter>` and Scalpel will prompt to confirm each substitution, starting
" at the current word (unlike a normal `:%s` command, which starts at the top of
" the file).
"
" Default map: <leader>e.
"
" <Plug>(ScalpelVisual)
"
" Works similarly to |<Plug>(Scalpel)|, except that it scopes itself to the current
" visual selection rather than operating over the entire file.
"
" Default map: <leader>e
"
" <Plug>(ScalpelVisualSelection)
"
" Works similarly to |<Plug>(Scalpel)|, except that it populates the match pattern
" with the visual selection rather than <cword>.
"
" Unmapped by default. Example map:
" >
"     vnoremap <leader>x <Plug>(ScalpelVisualSelection)
" <
"
" <Plug>(ScalpelVisualSmart)
"
" Works similarly to |<Plug>(ScalpelVisualSelection)|, except that when the visual
" selection is only a single character, it falls back on <cword>-like behavior to
" assume a substitution pattern when the character is alphanumeric, an
" underscore, a hyphen, or a period.
"
" Unmapped by default. Example map:
" >
"     vnoremap <leader>y <Plug>(ScalpelVisualSelection)
" <
"
" FAQ                                                                *scalpel-faq*
"
" Why use Scalpel rather than a built-in alternative? ~
"
" Scalpel is a lightweight plug-in that provides subtle but valuable
" improvements to the experience you'd get by using Vim's built-in
" functionality.
"
" Compared to writing a |:substitute| command manually:
"
" - Scalpel is quickly activated by a mapping.
" - Scalpel prepopulates the search pattern with the word currently under the
"   cursor.
" - Scalpel avoids a jarring jump to the top of the file, instead starting
"   replacements at the current location.
"
" Compared to a mapping such as "*Ncgn":
"
" - Scalpel allows you to preview the location at which each change will occur
"   instead of performing the change blindly.
"
" Website                                                        *scalpel-website*
"
" The official Scalpel source code repo is at:
"
" http://git.wincent.com/scalpel.git
"
" Mirrors exist at:
"
" - https://github.com/wincent/scalpel
" - https://gitlab.com/wincent/scalpel
" - https://bitbucket.org/ghurrell/scalpel
"
" Official releases are listed at:
"
" http://www.vim.org/scripts/script.php?script_id=5381
"
" License                                                        *scalpel-license*
"
" Copyright (c) 2016-present Greg Hurrell
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" Development                                                *scalpel-development*
"
" Contributing patches ~
"
" Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests
" at: https://github.com/wincent/scalpel/pulls
"
" Cutting a new release ~
"
" At the moment the release process is manual:
"
" - Perform final sanity checks and manual testing.
" - Update the [scalpel-history](#user-content-scalpel-history) section of the
"   documentation.
" - Regenerate the documentation:
" >
"     docvim README.md doc/scalpel.txt
" <
" - Verify clean work tree:
" >
"     git status
" <
" - Tag the release:
" >
"     git tag -s -m "$VERSION release" $VERSION
" <
" - Publish the code:
" >
"     git push origin master --follow-tags
"     git push github master --follow-tags
" <
" - Produce the release archive:
" >
"     git archive -o scalpel-$VERSION.zip HEAD -- .
" <
" - Upload to http://www.vim.org/scripts/script.php?script_id=5381
"
" Authors                                                        *scalpel-authors*
"
" Scalpel is written and maintained by Greg Hurrell <greg@hurrell.net>.
"
" Other contributors that have submitted patches include (in alphabetical
" order):
"
" - Keng Kiat Lim
"
" This list produced with:
" >
"     :read !git shortlog -s HEAD | grep -v 'Greg Hurrell' | cut -f 2-3 | sed -e 's/^/- /'
" <
" History                                                        *scalpel-history*
"
" 1.1 (12 June 2020) ~
"
" - Automatically escape characters that may have special meaning for |/\v|
"   (patch from Keng Kiat Lim, https://github.com/wincent/scalpel/pull/11).
"
" 1.0.1 (6 March 2019) ~
"
" - Prefer |execute()| when available to avoid potential nested |:redir| issues.
"
" 1.0 (3 January 2019) ~
"
" - Perform multiple replacements per line even when |'gdefault'| is on.
"
" 0.5 (28 July 2018) ~
"
" - Fix problem with |Visual| mode operation on older versions of Vim (GitHub
"   issue #8).
"
" 0.4 (23 July 2018) ~
"
" - Fix problem with replacement patterns containing the number 1 (GitHub
"   issue #7).
"
" 0.3 (10 May 2018) ~
"
" - Fix compatibility with older versions of Vim that don't implement
"   |getcurpos()|.
"
" 0.2 (13 June 2016) ~
"
" - Support visual mode.
" - Do not show "N substitutions on N lines" messages.
"
" 0.1 (29 April 2016) ~
"
" - Initial release.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:ScalpelLoaded') || &compatible || v:version < 700
  finish
endif
let g:ScalpelLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

let s:command=get(g:, 'ScalpelCommand', 'Scalpel')
if s:command ==# ''
  finish
elseif match(s:command, '\v\C^[A-Z][A-Za-z]*$') == -1
  echoerr 'g:ScalpelCommand must contain only letters and start with a ' .
        \ 'capital letter'
  finish
endif
execute 'command! -nargs=1 -range '
      \ . s:command
      \ . ' call scalpel#substitute(<q-args>, <line1>, <line2>, <count>)'

function! s:GetCurposCompat()
  if exists('*getcurpos')
    return getcurpos()
  else
    return getpos('.')
  endif
endfunction

" Need to remember last-seen cursor position because `getcurpos()` is not useful
" in VISUAL modes.
let s:curpos=s:GetCurposCompat()
augroup Scalpel
  autocmd!
  autocmd CursorMoved * let s:curpos=s:GetCurposCompat()
augroup END

" Local accessor so that we can reference the script-local variable from inside
" a mapping (as per http://superuser.com/questions/566720).
function! s:GetCurpos()
  return s:curpos
endfunction

function! s:TransformSelection(selection)
    if len(a:selection) == 1 && match(a:selection, '\v^([A-Za-z0-9_.-])$') == 0
        return '<' . scalpel#cword(<SID>GetCurpos()) . '>'
    endif
    return a:selection
endfunction

" For escaping any characters which could have special meaning under \v (very
" magic) semantics ie. all ASCII characters except '0'-'9', 'a'-'z', 'A'-'Z'
" and '_'.
let g:magic_chars='"' . escape("!\"#$%&'()*+,-./:;<=>?@[\\]^`{|}~", '"/\|') . '"'

" Change all instances of current word (mnemonic: edit).
execute 'nnoremap <Plug>(Scalpel) :' .
      \ s:command .
      \ "/\\v<<C-R>=escape(expand('<cword>'), " . g:magic_chars . ")<CR>>//<Left>"
execute 'vnoremap <Plug>(ScalpelVisual) :' .
      \ s:command .
      \ "/\\v<<C-R>=escape(scalpel#cword(<SID>GetCurpos()), " . g:magic_chars . ")<CR>>//<Left>"

" Change all instances of selection
""
" @mapping <Plug>(ScalpelVisualSelection)
"
" Works similarly to <Plug>(Scalpel), except that it populates the match
" pattern with the visual selection rather than <cword>. Unmapped by default.
" Example map:
"
" ```
" vnoremap <leader>x <Plug>(ScalpelVisualSelection)
" ```
execute 'vnoremap <Plug>(ScalpelVisualSelection) :<C-u>' .
      \ s:command .
      \ "/\\v<C-R>=escape(scalpel#get_visual_selection(), " . g:magic_chars . ")<CR>//<Left>"
""
" @mapping <Plug>(ScalpelVisualSmart)
"
" Works similarly to <Plug>(ScalpelVisualSelection), except that when the
" visual selection is only a single character, it falls back on <cword>-like
" behavior to assume a substitution pattern when the character is
" alphanumeric, an underscore, a hyphen, or a period.  Example map:
"
" ```
" vnoremap <leader>y <Plug>(ScalpelVisualSmart)
" ```
execute 'vnoremap <Plug>(ScalpelVisualSmart) :<C-u>' .
    \ s:command .
    \ "/\\v<C-R>=escape(<SID>TransformSelection(scalpel#get_visual_selection()), " . g:magic_chars . ")<CR>//<Left>"

let s:map=get(g:, 'ScalpelMap', 1)
if s:map
  if !hasmapto('<Plug>(Scalpel)') && maparg('<leader>e', 'n') ==# ''
    ""
    " @mapping <Plug>(Scalpel)
    "
    " Scalpel maps <leader>e to |<Plug>(Scalpel)|, which displays a prompt
    " pre-populated with the current word and with the cursor placed so that
    " you can start typing the desired replacement:
    " >
    "     :Scalpel/\v<foo>//
    " <
    " Press `<Enter>` and Scalpel will prompt to confirm each substitution,
    " starting at the current word (unlike a normal `:%s` command, which
    " starts at the top of the file).
    "
    " ```
    " " Instead of <leader>e, use <leader>x.
    " nmap <leader>x <Plug>(Scalpel)
    " ```
    nmap <unique> <Leader>e <Plug>(Scalpel)
  endif
  if !hasmapto('<Plug>(ScalpelVisual)') && maparg('<leader>e', 'v') ==# ''
    ""
    " @mapping <Plug>(ScalpelVisual)
    "
    " Works similarly to <Plug>(Scalpel), except that it scopes itself to the
    " current visual selection rather than operating over the entire file.
    "
    " ```
    " " Instead of <leader>e, use <leader>y.
    " nmap <leader>y <Plug>(ScalpelVisual)
    " ```
    vmap <unique> <Leader>e <Plug>(ScalpelVisual)
  endif
endif

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
