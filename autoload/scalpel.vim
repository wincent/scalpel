" Does the heavy-lifting for the quick find-and-replace command (:Substitute).
function! scalpel#substitute(patterns) abort
  if match(a:patterns, '\v^/[^/]*/[^/]*/$') != 0
    echomsg 'Invalid patterns: ' . a:patterns
    echomsg 'Expected patterns of the form "/foo/bar/".'
    return
  endif
  if getregtype('s') != ''
    let l:register=getreg('s')
  endif
  normal! qs
  redir => l:replacements
  try
    execute ',$s' . a:patterns . 'gce#'
  catch /^Vim:Interrupt$/
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
      " Loop around to top of file and continue.
      " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
      if line("''") > 1
        " Drop c flag.
        1,''-&ge
      endif
     return
    endif
  endif

  " Loop around to top of file and continue.
  " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
  if line("''") > 1
    1,''-&gce
  endif
endfunction
