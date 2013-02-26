" this code from http://lists.metaprl.org/pipermail/omake/2007-May/001682.html
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
 syntax clear
elseif exists("b:current_syntax")
 finish
endif


syn keyword     omakeTodo       contained TODO FIXME XXX
syn match       omakeComment    "^#.*" contains=omakeTodo
syn match       omakeComment    "\s#.*"ms=s+1 contains=omakeTodo

syn region omakeString          start=+$\='+ end=+'+ skip=+\\\\\|\\'+ contains=omakeEscape
syn region omakeString          start=+$\="+ end=+"+ skip=+\\\\\|\\"+ contains=omakeEscape
syn region omakeString          start=+$\=""+ end=+""+ contains=omakeEscape
syn region omakeString          start=+$\=''+ end=+''+ contains=omakeEscape
syn region omakeString          start=+$\="""+ end=+"""+ contains=omakeEscape
syn region omakeString          start=+$\='''+ end=+'''+ contains=omakeEscape

syn match  omakeEscape          +\\[abfnrtv'"\\]+ contained
syn match  omakeEscape          "\\\o\{1,3}" contained
syn match  omakeEscape          "\\x\x\{2}" contained
syn match  omakeEscape          "\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match  omakeEscape          "\\$"

syn keyword omakeKeyword        case     catch  class    declare    default
syn keyword omakeKeyword        do       export extends
syn keyword omakeKeyword        finally  import include  match
syn keyword omakeKeyword        open     raise  return   section    switch
syn keyword omakeKeyword        try      value  when     while

syn match omakeKeyword        "^\.PHONY:"

syn keyword omakeConditional    if else elseif

syn keyword omakeBoolean        true false

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_omake_syntax_inits")
 if version < 508
   let did_omake_syntax_inits = 1
   command -nargs=+ HiLink hi link <args>
 else
   command -nargs=+ HiLink hi def link <args>
 endif

 HiLink omakeComment           Comment
 HiLink omakeTodo              Todo
 HiLink omakeString            String
 HiLink omakeKeyword           Keyword
 HiLink omakeConditional       Conditional
 HiLink omakeBoolean           Boolean

 delcommand HiLink
endif

let b:current_syntax = "omake"

" vim: ts=8 sw=2
