"
"     ::::::::   ::::::  :::   ::: :::
"    :+:   :+: :+:  :+: :+:   :+: :+:  Paul OHL
"   +#++++#+  +#+  +:+ +#++:+#++ +#+
"  #+#       #+#  #+# #+#   #+# #+#
" ###        ######  ###   ### #######
"
" Created: 2021/12/12 18:22:53
"


let s:asciiart = [
\"     ::::::::   ::::::  :::   ::: :::",
\"    :+:   :+: :+:  :+: :+:   :+: :+:  Paul OHL",
\"   +#++++#+  +#+  +:+ +#++:+#++ +#+",
\"  #+#       #+#  #+# #+#   #+# #+#",
\" ###        ######  ###   ### #######",
\]

let s:start		= '/*'
let s:end		= '*/'
let s:length	= 80

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php\|\.glsl':
			\['//', ''],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->'],
			\'\.js$':
			\['//', ''],
			\'\.lua$':
			\['--', ''],
			\'\.tex$':
			\['%', ''],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)'],
			\'\.vim$\|\vimrc$':
			\['"', ''],
			\'\.el$\|\emacs$':
			\[';', ''],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= ''

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 2]
endfunction

function! s:textline(text)
	if strlen(s:end)
		let l:written_length = strlen(a:text) + strlen(s:start) + strlen(s:end) + 1
		return s:start . a:text . repeat(' ', s:length - l:written_length) . s:end
	else
		return s:start . a:text
	endif
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 7 || a:n == 9 " blank line
		return s:textline('')
	elseif a:n == 2 || a:n == 3 || a:n == 4 || a:n == 5 || a:n == 6 " empty with ascii
		return s:textline(s:ascii(a:n))
	elseif a:n == 8 " created
		return s:textline(" Created: " . s:date())
	endif
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:insert()
	let l:line = 9

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	call s:filetype()
	if getline(8) =~ s:start . " Created: "
		return 0
	endif
	return 1
endfunction

function! s:pohlheader()
	if s:update()
		call s:insert()
	endif
endfunction

" Bind command and shortcut
command! Pohlheader call s:pohlheader ()
