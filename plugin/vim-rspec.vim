"
" Vim Rspec
" Last change: March 5 2009
" Version> 0.0.5
" Maintainer: Eustáquio 'TaQ' Rangel
" License: GPL
" URL: git://github.com/taq/vim-rspec
"
" Script to run the spec command inside Vim
" To install, unpack the files on your ~/.vim directory and source it
"
" The following options can be set/overridden in your .vimrc
"   * g:RspecRBFilePath      :: Path to vim-rspec.rb
"   * g:RspecBin             :: Rspec binary command (in rspec 2 this is 'rspec')
"   * g:RspecOpts            :: Opts to send to rspec call
"   * g:RspecSplitHorizontal :: Set to 0 to cause Vertical split (default:1)

let s:helper_dir = expand("<sfile>:h")

if !exists("g:RspecKeymap")
  let g:RspecKeymap=1
end

runtime! plugin/sources/helpers.vim
runtime! plugin/sources/win_cmd.vim

function! s:RunSpecMain(type)
  let l:bufn = expand("%:p")
  let s:SpecFile = l:bufn

  call g:CheckNokogiri()

  " find the installed rspec command
  let l:default_cmd = ""
  if executable("spec")==1
    let l:default_cmd = "spec"
  elseif executable("rspec")==1
    let l:default_cmd = "rspec"
  end

  " filter
  let l:filter = "ruby ". g:FetchVar("RspecRBPath", s:helper_dir."/vim-rspec.rb")

  " run just the current file
  if a:type=="file"
    if match(l:bufn,'_spec.rb')>=0
      call g:NoticeMsg("Running " . s:SpecFile . "...")
      let l:spec_bin = g:FetchVar("RspecBin",l:default_cmd)
      let l:spec_opts = g:FetchVar("RspecOpts", "")
      let l:spec = l:spec_bin . " " . l:spec_opts . " -f h " . l:bufn
    else
      call g:ErrorMsg("Seems ".l:bufn." is not a *_spec.rb file")
      return
    end
  elseif a:type=="line"
    if match(l:bufn,'_spec.rb')>=0
      let l:current_line = line('.')

      call g:NoticeMsg("Running Line " . l:current_line . " on " . s:SpecFile . " ")
      let l:spec_bin = g:FetchVar("RspecBin",l:default_cmd)
      let l:spec_opts = g:FetchVar("RspecOpts", "")
      let l:spec = l:spec_bin . " " . l:spec_opts . " -l " . l:current_line . " -f h " . l:bufn
    else
      call g:ErrorMsg("Seems ".l:bufn." is not a *_spec.rb file")
      return
    end
  elseif a:type=="rerun"
    if exists("s:spec")
      let l:spec = s:spec
    else
      call g:ErrorMsg("No rspec run to repeat")
      return
    end
  else
    let l:dir = expand("%:p:h")
    if isdirectory(l:dir."/spec")>0
      call g:NoticeMsg("Running spec on the spec directory ...")
    else
      " try to find a spec directory on the current path
      let l:tokens = split(l:dir,"/")
      let l:dir = ""
      for l:item in l:tokens
        call remove(l:tokens,-1)
        let l:path = "/".join(l:tokens,"/")."/spec"
        if isdirectory(l:path)
          let l:dir = l:path
          break
        end
      endfor
      if len(l:dir)>0
        call g:NoticeMsg("Running spec with on the spec directory found (".l:dir.") ...")
      else
        call g:ErrorMsg("No ".l:dir."/spec directory found")
        return
      end
    end
    if isdirectory(l:dir)<0
      call g:ErrorMsg("Could not find the ".l:dir." directory.")
      return
    end
    let l:spec = g:FetchVar("RspecBin", l:default_cmd) . g:FetchVar("RspecOpts", "")
    let l:spec = l:spec . " -f h " . l:dir . " -p **/*_spec.rb"
  end
  let s:spec = l:spec

  " run the spec command
  let s:cmd  = l:spec." | ".l:filter

  "put the result on a new buffer
  call g:CreateOutputWin()
  setl buftype=nofile
  silent exec "r! ".s:cmd
  setl syntax=vim-rspec
  silent exec "nnoremap <buffer> <cr> :call <SID>TryToOpen()<cr>"
  silent exec 'nnoremap <silent> <buffer> n /\/.*spec.*\:<cr>:call <SID>TryToOpen()<cr>'
  silent exec 'nnoremap <silent> <buffer> N ?/\/.*spec.*\:<cr>:call <SID>TryToOpen()<cr>'
  silent exec "nnoremap <buffer> q :q<CR>:wincmd p<CR>"
  setl nolist
  setl foldmethod=expr
  setl foldexpr=getline(v:lnum)=~'^\+'
  setl foldtext=\"+--\ \".string(v:foldend-v:foldstart+1).\"\ passed\ \"
  call cursor(1,1)
endfunction

function! RunSpec()
  call s:RunSpecMain("file")
endfunction

function! RunSpecLine()
  call s:RunSpecMain("line")
endfunction

function! RunSpecs()
  call s:RunSpecMain("dir")
endfunction

function! RerunSpec()
  call s:RunSpecMain("rerun")
endfunction

command! RunSpec  call RunSpec()
command! RerunSpec  call RerunSpec()
command! RunSpecs  call RunSpecs()
command! RunSpecLine  call RunSpecLine()

if g:RspecKeymap==1
  " Cmd-Shift-R for RSpec
  nmap <D-R> :RunSpec<CR>
  " Cmd-Shift-L for RSpec Current Line
  nmap <D-L> :RunSpecLine<CR>
  " Cmd-Shift-E for RSpec previous spec
  nmap <D-E> :RerunSpec<CR>
endif
