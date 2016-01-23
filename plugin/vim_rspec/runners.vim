function! vim_rspec#runners#file()
  call s:check_is_buffer_spec_file()

  call vim_rspec#helpers#notice_msg("Running " . s:buffer_name() . "...")
  return s:fetch_spec_bin() . " " . s:fetch_spec_opts() . " -f h " . s:buffer_name()
endfunction

function! vim_rspec#runners#line()
  call s:check_is_buffer_spec_file()

  let l:current_line = line('.')
  call vim_rspec#helpers#notice_msg("Running Line " . l:current_line . " on " . s:buffer_name() . " ")
  return s:fetch_spec_bin() . " " . s:fetch_spec_opts() . " -l " . l:current_line . " -f h " . s:buffer_name()
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

function! s:fetch_spec_bin()
  return vim_rspec#helpers#fetch_var("RspecBin", vim_rspec#helpers#find_rspec_executable())
endfunction

function! s:fetch_spec_opts()
  return vim_rspec#helpers#fetch_var("RspecOpts", "")
endfunction
