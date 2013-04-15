function! alpaca_powertabline#getinfo#buffer_name(bufnr) "{{{
  let bufname = bufname(a:bufnr)
  if bufname =~# '^[[:alnum:].+-]\+:\\\\'
    let bufname = substitute(bufname, '\\', '/', 'g')
  endif

  let buftype = getbufvar(a:bufnr, '&buftype')
  if bufname ==# ''
    if buftype ==# ''
      return '[No Name]'
    elseif buftype ==# 'quickfix'
      return '[Quickfix List]'
    elseif buftype ==# 'nofile' || buftype ==# 'acwrite'
      return '[Scratch]'
    endif
  endif

  if buftype ==# 'nofile' || buftype ==# 'acwrite'
    return bufname
  endif

  return fnamemodify(bufname, ':t')
endfunction "}}}

function! alpaca_powertabline#getinfo#lingr_buffer_name(n) "{{{
  let bufnrs = tabpagebuflist(a:n)
  let curbufnr = bufnrs[0]
  return exists('g:loaded_lingr_vim') && getbufvar(curbufnr, '&filetype') =~# '^lingr-'
endfunction"}}}
function! alpaca_powertabline#getinfo#lingr_buffer_name(n) "{{{
  if alpaca_powertabline#getinfo#lingr_buffer_name(a:n)
    let unread = lingr#unread_count()
    let status = lingr#status()
    " let last_message = lingr#get_last_message()

    let label = 'lingr - ' . status
    if unread != 0
      let label .= '(' . unread . ')'
    endif

    return label
  else
    return ""
  endif
endfunction"}}}

function! alpaca_powertabline#getinfo#tabpage_label(n, title, modified) "{{{
  " label
  let label = ""
  let label .= a:n . g:alpaca_powertabline_sep2
  let label .= a:title
  let mod   = a:modified ? ' + ' : ''
  let label .= mod
  let label = alpaca_powertabline#utils#label2powerline(label, a:n)

  let mark  = '%' . a:n . 'T'

  return  mark.label.'%T%#TabLineFill#'
endfunction"}}}

function! alpaca_powertabline#getinfo#buffer_into_tab(tabbufnr) "{{{
  let bufnrs = tabpagebuflist(a:tabbufnr)
  let curbufnr = bufnrs[tabpagewinnr(a:tabbufnr) - 1]  " first window, first appears
  let bufname = alpaca_powertabline#getinfo#buffer_name(curbufnr)
  let mod = len(filter(bufnrs, 'getbufvar(v:val, "&modified")')) > 0

  return [a:tabbufnr, bufname, mod]
endfunction"}}}
