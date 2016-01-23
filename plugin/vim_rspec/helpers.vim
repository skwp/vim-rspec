function! vim_rspec#helpers#check_nokogiri()
  let s:nokogiri = s:find_nokogiri()
  let s:nokogiri = match(s:nokogiri,'true') >= 0
  if !s:nokogiri
    throw("You need the `nokogiri` gem to run this script.")
  end
endfunction

function! vim_rspec#helpers#error_msg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction

function! vim_rspec#helpers#notice_msg(msg)
  echohl MoreMsg
  echo a:msg
  echohl None
endfunction

function! vim_rspec#helpers#fetch_var(varname, default)
  if exists("g:".a:varname)
    return eval("g:".a:varname)
  else
    return a:default
  endif
endfunction

function! vim_rspec#helpers#find_rspec_executable()
  if executable("spec") == 1
    return "spec"
  elseif executable("rspec") == 1
    return "rspec"
  end
  return ""
endfunction

function! vim_rspec#helpers#build_filter_command(plugin_dir)
  let default_filter_cmd = a:plugin_dir . "/vim-rspec.rb"
  let rb_path = vim_rspec#helpers#fetch_var("RspecRBPath", default_filter_cmd)
  return "ruby" . rb_path
endfunction

"======
" Local functions
"======
function! s:find_nokogiri()
  return system("gem search -i nokogiri &> /dev/null && echo true")
endfunction
