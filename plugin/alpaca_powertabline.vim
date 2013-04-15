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
let s:sep = ''
"}}}

" Generating powerline highlight
function! s:highlight() " {{{
  let c = g:alpaca_powertabline_colors
  let define_list = {
        \ "Tabline": {"bg": c.base.bg, "fg": c.base.fg, "cterm": "NONE"},
        \ "TabLineSel": {"bg": c.sel.bg, "fg": c.sel.fg, "cterm": "bold"},
        \ "TablineFill": {"bg": c.passive.bg, "fg": c.base.fg, "cterm": "NONE"},
        \ "ActiveTabLine": {"bg": c.sel.bg, "fg": c.sel.fg, "cterm": "NONE"},
        \ "ActiveTabLineBG": {"bg": c.passive.bg, "fg": c.sel.bg, "cterm": "NONE"},
        \ "ActiveTabLineBGL": {"bg": c.passive.bg, "fg": c.sel.bg, "cterm": "NONE"},
        \ "PassiveTabLine": {"bg": c.passive.bg, "fg": c.passive.fg, "cterm": "NONE"},
        \ "PassiveTabLineBG": {"bg": c.passive.bg, "fg": c.passive.bg, "cterm": "NONE"},
        \ "PassiveTabLineRightIsActive": {"bg": c.sel.bg, "fg": c.passive.bg, "cterm": "NONE"},
        \ }
  for [name, highlight] in items(define_list)
    call alpaca_powertabline#utils#set_highlight(name, highlight)
  endfor
endfunction"}}}

" Get buffer name
function! s:get_info() "{{{
  " XXX とりあえず
  return ""

  if exists('g:alpaca_powertabline_info') && g:alpaca_powertabline_info != ""
    return '%=' . g:alpaca_powertabline_info
  endif

  let info = ""
  let pwd = '%=' . fnamemodify(getcwd(), ":~") . '  '
  if exists('t:tabline_extra')
    let info .= t:tabline_extra . sep
  endif

  return info . pwd
endfunction"}}}

function! MakeAlpacaTabLine() "{{{
  if !exists('s:initialize_highlight')
    call s:highlight()
  endif

  let title_array = map(range(1, tabpagenr('$')), 'alpaca_powertabline#getinfo#buffer_into_tab(v:val)')
  " => [[1, ".vimrc"], [2, "~/.zshrc"]]

  let titles = map(copy(title_array), 'alpaca_powertabline#getinfo#tabpage_label(v:val[0], v:val[1], v:val[2])')
  " => ['%1T%#PassiveTabLine#1  .vimrc%#PassiveTabLineRightIsActive# %#ActiveTabLine#%T%#TabLineFill#', '%2T%#ActiveTabLine#2  ~/.zshrc%#ActiveTabLineBGL# %#TabLineFill#%T%#Tab LineFill#']

  let titles_len = len(join(title_array, ""))
  let tabs = join(titles, s:sep) . '%#TabLineFill#%T'

  " XXX 他の人用にとりあえず
  " return ' ' . tabs

  " let info = s:get_info()

  " 中央寄せ
  let space_len = (&columns / 2) - (titles_len / 2)
  let space_len = space_len > 0 ? space_len : 1

  let first = "%#TabLineFill#"
  for i in range(1, space_len)
    let first .= " "
  endfor
  let fill_space   = alpaca_powertabline#utils#label2powerline(first, 0)
  return fill_space . tabs

  return fill_space . tabs . '%=' . info
endfunction"}}}

augroup AlpacaTabline
  autocmd!
  autocmd ColorScheme * let s:initialize_highlight = 0
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo


