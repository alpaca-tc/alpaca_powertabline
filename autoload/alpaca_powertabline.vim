"=============================================================================
" FILE: alpaca_powertabline.vim
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

let s:sep = ''

" Generating powertabline
function! alpaca_powertabline#create_tabline() "{{{
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

" Generating powerline highlight
function! alpaca_powertabline#initialize() " {{{
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
