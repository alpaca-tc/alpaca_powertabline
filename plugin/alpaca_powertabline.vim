"=============================================================================
" FILE: alpaca_powertabline
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-04-15
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if exists('g:loaded_alpaca_powertabline') || has("gui_running")
  finish
endif
let g:loaded_alpaca_powertabline = 1

let s:save_cpo = &cpo
set cpo&vim

" initialize"{{{
function! s:define_default_variable(name, value) "{{{
  let value = type(a:value) == type('') ? "'".a:value."'" : a:value

  if !exists(a:name)
    execute join(['let', a:name, '=', value], " ")
  endif
endfunction "}}}

call s:define_default_variable('g:alpaca_powertabline_time_format', "%H:%M:%S")
call s:define_default_variable('g:alpaca_powertabline_sep1', ' ')
call s:define_default_variable('g:alpaca_powertabline_sep2', '  ')
call s:define_default_variable('g:alpaca_powertabline_colors', {
        \   "base" : {
        \     "bg" : 240,
        \     "fg" : 255,
        \   },
        \   "sel" : {
        \     "bg": 75,
        \     "fg": 255,
        \   },
        \   "passive": {
        \     "bg": 236,
        \     "fg": 245,
        \   },
        \ })
"}}}

augroup AlpacaTabline
  autocmd!
  autocmd VimEnter,ColorScheme * call alpaca_powertabline#initialize()
        \| set tabline=%!alpaca_powertabline#create_tabline()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
