"==============
" Checks `nokogiri` gem availability
function! g:CheckNokogiri()
  let s:nokogiri = s:find_nokogiri()
  let s:nokogiri = match(s:nokogiri,'true') >= 0
  if !s:nokogiri
    throw("You need the `nokogiri` gem to run this script.")
  end
endfunction

function! s:find_nokogiri()
  return system("( gem search -i nokogiri &> /dev/null && echo true )")
endfunction

function! g:ErrorMsg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction

function! g:NoticeMsg(msg)
  echohl MoreMsg
  echo a:msg
  echohl None
endfunction

function! g:FetchVar(varname, default)
  if exists("g:".a:varname)
    return eval("g:".a:varname)
  else
    return a:default
  endif
endfunction

