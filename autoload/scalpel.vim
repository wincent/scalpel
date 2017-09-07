" Copyright 2016-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

function! scalpel#cword(curpos) abort
  " <cword> Doesn't work usefully in visual mode (always returns first word),
  " so fake it.
  let l:line=getline(a:curpos[1])
  let l:col=a:curpos[2]
  let l:chars=split(l:line, '\zs')
  let l:word=[]

  " Look for keyword characters rightwards.
  for l:char in l:chars[l:col:]
    if match(l:char, '\k') != -1
      call add(l:word, l:char)
    else
      break
    endif
  endfor

  " Look for keyword characters leftwards.
  for l:char in reverse(l:chars[:l:col - 1])
    if match(l:char, '\k') != -1
      call insert(l:word, l:char, 0)
    else
      break
    endif
  endfor

  return join(l:word, '')
endfunction

function! scalpel#substitute(patterns, line1, line2, count) abort
  if a:count == -1
    " No range supplied, operate on whole buffer.
    let l:currentline=a:line1
    let l:firstline=1
    let l:lastline=line('$')
  else
    let l:firstline=a:line1 <= a:line2 ? a:line1 : a:line2
    let l:lastline=a:line2 >= a:line2 ? a:line2 : a:line1
    let l:currentline=l:firstline
  endif

  " As per `:h E146`, can use any single-byte non-alphanumeric character as
  " delimiter except for backslash, quote, and vertical bar.
  "
  " Note there seems to be a bug in the Vim regex implementation (present in
  " both versions of the engine; see `:h two-engines`) wherein the presence of a
  " backslash anywhere in the text causes the pattern not to match. Happens in
  " both Vim and Neovim. Backslashes are common (consider \v) so this is a big
  " deal.
  "
  " Workaround is to use less precise .* in the pattern instead of [^\1]*
  " Note that the second instance of [^\1]* works fine; only the first needs to
  " be replaced.
  if match(a:patterns, '\v^([^"\\|A-Za-z0-9 ]).*\1[^\1]*\1$') != 0
    echomsg 'Invalid patterns: ' . a:patterns
    echomsg 'Expected patterns of the form "/foo/bar/".'
    return
  endif
  if getregtype('s') != ''
    let l:register=getreg('s')
  endif
  normal! qs
  redir => l:replacements
  let l:report=&report
  try
    set report=10000
    execute l:currentline . ',' . l:lastline . 's' . a:patterns . 'gce#'
  catch /^Vim:Interrupt$/
    execute 'set report=' . l:report
    return
  finally
    normal! q
    let l:transcript=getreg('s')
    if exists('l:register')
      call setreg('s', l:register)
    endif
  endtry
  redir END
  if len(l:replacements) > 0
    " At least one instance of pattern was found.
    let l:last=strpart(l:transcript, len(l:transcript) - 1)
    if l:last ==# 'l' || l:last ==# 'q' || l:last ==# ''
      " User bailed.
      return
    elseif l:last ==# 'a'
      " Loop around to top of range/file and continue.
      " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
      if l:currentline > l:firstline
        " Drop c flag.
        execute l:firstline . ',' . l:currentline . '-&gce'
      endif
     return
    endif
  endif

  " Loop around to top of range/file and continue.
  " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
  if l:currentline > l:firstline
    execute l:firstline . ',' . l:currentline . '-&gce'
    execute 'set report=' . l:report
  endif
endfunction
