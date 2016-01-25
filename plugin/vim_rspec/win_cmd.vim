function! vim_rspec#win_cmd#create_output_win()
  let isSplitHorizontal = vim_rspec#helpers#fetch_var("RspecSplitHorizontal", 1)
  let splitDirCommand = isSplitHorizontal == 1 ? 'new' : 'vnew'

  let splitLocation = "botright "
  let splitSize = 15

  if bufexists('RSpecOutput')
    silent! bw! RSpecOutput
  end

  silent! exec splitLocation . ' ' . splitSize .  ' ' . splitDirCommand
  silent! exec "edit RSpecOutput"
endfunction

function! vim_rspec#win_cmd#try_to_open(spec_file)
  " Search up to find '*_spec.rb'
  call search("_spec","bcW")
  let l:line = getline(".")
  if match(l:line,'^  .*_spec.rb')<0
    call vim_rspec#helpers#error_msg("No spec file found.")
    return
  end
  let l:tokens = split(l:line,":")

  " move back to the other window, if available
  call s:SwitchToWindowByName(a:spec_file)

  " open the file in question (either in the split)
  " that was already open, or in the current win
  exec "e ".substitute(l:tokens[0],'/^\s\+',"","")
  call cursor(l:tokens[1],1)
endfunction

"======
" Local functions
"======
function! s:SwitchToWindowByName(buffername)
  let l:windowNumber = s:FindWindowByBufferName(a:buffername)
  call s:SwitchToWindowNumber(l:windowNumber)
endfunction

function! s:FindWindowByBufferName(buffername)
  let l:windowNumberToBufnameList = map(range(1, winnr('$')), '[v:val, bufname(winbufnr(v:val))]')
  let l:arrayIndex = match(l:windowNumberToBufnameList, a:buffername)
  let l:windowNumber = windowNumberToBufnameList[l:arrayIndex][0]
  return l:windowNumber
endfunction

function! s:SwitchToWindowNumber(number)
  exe a:number . "wincmd w"
endfunction


