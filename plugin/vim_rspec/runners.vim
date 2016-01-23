function! vim_rspec#runners#file()
  call s:check_is_buffer_spec_file()
  call vim_rspec#helpers#notice_msg("Running " . s:buffer_name() . "...")
  let l:spec_bin = vim_rspec#helpers#fetch_var("RspecBin", vim_rspec#helpers#find_rspec_executable())
  let l:spec_opts = vim_rspec#helpers#fetch_var("RspecOpts", "")
  return l:spec_bin . " " . l:spec_opts . " -f h " . s:buffer_name()
endfunction

"======
" Local functions
"======
function! s:check_is_buffer_spec_file()
  let l:bufn = s:buffer_name()
  if match(l:bufn,'_spec.rb') <= 0
    throw("Seems ".l:bufn." is not a *_spec.rb file")
  endif
endfunction

function! s:buffer_name()
  return expand("%:p")
endfunction
