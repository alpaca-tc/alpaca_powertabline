let s:sep = g:alpaca_powertabline_sep1
let s:to_powerline = [
      \ [
      \   '%#PassiveTabLine#', '%#PassiveTabLineBG#'.s:sep.'%#PassiveTabLineBG#',
      \   '%#PassiveTabLine#', '%#PassiveTabLineBG#'.s:sep.'%#TabLineFill#',
      \   '%#PassiveTabLine#', '%#PassiveTabLineRightIsActive#'.s:sep.'%#ActiveTabLine#',
      \ ],
      \ [
      \   '%#ActiveTabLine#', '%#ActiveTabLineBG#'.s:sep.'%#PassiveTabLine#',
      \   '%#ActiveTabLine#', '%#ActiveTabLineBGL#'.s:sep.'%#TabLineFill#',
      \ ],
      \ ]

function! alpaca_powertabline#utils#set_highlight(name, highlight) "{{{
  let h = a:highlight
  let highlight = ["highlight", a:name]

  if has_key(h, "bg")
    call add(highlight, "ctermbg=" . h["bg"])
  endif
  if has_key(h, "fg")
    call add(highlight, "ctermfg=" . h["fg"])
  endif

  let cterm = "cterm="
  let cterm .=  has_key(h, "cterm") ? h["cterm"] : "NONE"
  call add(highlight, cterm)

  " => highlight a:name ctermbg=highlight["bg"] ctermfg=highlight["fg"] cterm=highlight["cterm"]
  execute join(highlight, " ")
endfunction "}}}
function! alpaca_powertabline#utils#label2powerline(str, n) " {{{
  let current = a:n is tabpagenr()
  let last    = a:n is tabpagenr("$")
  let next_is_active = (a:n + 1) is tabpagenr()

  if last
    " last tab
    return s:to_powerline[current][2] . a:str . s:to_powerline[current][3]
  else
    if next_is_active
      return s:to_powerline[current][4] . a:str . s:to_powerline[current][5]
    else
      return s:to_powerline[current][0] . a:str . s:to_powerline[current][1]
    endif
  endif
endfunction"}}}
