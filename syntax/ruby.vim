" Vim syntax file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet@hey.com>
" URL: https://github.com/jlcrochet/vim-ruby

if exists("b:current_syntax")
  finish
endif

" Syntax {{{1
syn sync fromstart
syn iskeyword @,48-57,_,?,!,:

if get(b:, "is_eruby")
  syn cluster rubyTop contains=@ruby
else
  syn cluster rubyTop contains=TOP
endif

syn cluster rubyPostfix contains=rubyOperator,rubyMethodOperator,rubyRangeOperator,rubyNamespaceOperator,rubyPostfixKeyword,rubyComma
syn cluster rubyArguments contains=rubyNumber,rubyString,rubyStringArray,rubySymbol,rubySymbolArray,rubyRegex,rubyCommand,rubyHeredoc,rubyHeredocSkip,rubyHashKey

" Comments {{{2
if get(b:, "is_eruby")
  syn match rubyLineComment /\%#=1#.\{-}\ze\%(-\=%>\)\=/ contained contains=rubyTodo
else
  syn match rubyLineComment /\%#=1#.*/ contains=rubyTodo
endif

syn region rubyComment start=/\%#=1^=begin\>.*/ end=/\%#=1^=end\>.*/ contains=rubyTodo
syn match rubyTodo /\<\(BUG\|DEPRECATED\|FIXME\|NOTE\|WARNING\|OPTIMIZE\|TODO\|XXX\|TBD\)/ contained

syn match rubyShebang /\%#=1\%^#!.*/

" Operators {{{2
syn match rubyUnaryOperator /\%#=1[+*!~&^]/
syn match rubyUnaryOperator /\%#=1->\=/

syn match rubyOperator /\%#=1=\%(==\=\|[>~]\)\=/ contained
syn match rubyOperator /\%#=1![=~]/ contained
syn match rubyOperator /\%#=1<\%(<=\=\|=>\=\)\=/ contained
syn match rubyOperator /\%#=1>>\==\=/ contained
syn match rubyOperator /\%#=1+=\=/ contained
syn match rubyOperator /\%#=1-=\=/ contained
syn match rubyOperator /\%#=1\*\*\==\=/ contained
syn match rubyOperator /\%#=1[/?:]/ contained
syn match rubyOperator /\%#=1%=\=/ contained
syn match rubyOperator /\%#=1&&\==\=/ contained
syn match rubyOperator /\%#=1||\==\=/ contained
syn match rubyOperator /\%#=1\^=\=/ contained

syn match rubyMethodOperator /\%#=1&\=\./ nextgroup=rubyVariableOrMethod,rubyOperatorMethod skipwhite
execute 'syn match rubyOperatorMethod /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained nextgroup=@rubyPostfix,@rubyArguments skipwhite'

syn match rubyRangeOperator /\%#=1\.\.\.\=/ nextgroup=rubyOperator,rubyPostfixKeyword skipwhite

syn match rubyNamespaceOperator /\%#=1::/ nextgroup=rubyConstant

" Delimiters {{{2
syn match rubyDelimiter /\%#=1(/ nextgroup=rubyHashKey skipwhite skipempty
syn match rubyDelimiter /\%#=1)/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1\[/
syn match rubyDelimiter /\%#=1]/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1{/ nextgroup=rubyHashKey,rubyBlockParameters skipwhite skipempty
syn match rubyDelimiter /\%#=1}/ nextgroup=@rubyPostfix skipwhite

syn match rubyComma /\%#=1,/ contained nextgroup=rubyHashKey skipwhite skipempty

syn match rubyBackslash /\%#=1\\/

" Identifiers {{{2
syn match rubyInstanceVariable /\%#=1@\h\w*/ nextgroup=@rubyPostfix skipwhite
syn match rubyClassVariable /\%#=1@@\h\w*/ nextgroup=@rubyPostfix skipwhite
syn match rubyGlobalVariable /\%#=1\$\%(\h\w*\|[!@~&`'+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)/ nextgroup=@rubyPostfix skipwhite

syn match rubyConstant /\%#=1\u\w*/ nextgroup=@rubyPostfix skipwhite
syn match rubyVariableOrMethod /\%#=1[[:lower:]_]\w*[?!]\=/ nextgroup=@rubyPostfix,@rubyArguments skipwhite

syn match rubyHashKey /\%#=1\h\w*[?!]\=::\@!/ contained contains=rubySymbolStart nextgroup=rubyComma skipwhite

" Literals {{{2
syn keyword rubyNil nil nextgroup=@rubyPostfix skipwhite
syn keyword rubyBoolean true false nextgroup=@rubyPostfix skipwhite
syn keyword rubySelf self nextgroup=@rubyPostfix skipwhite
syn keyword rubySuper super nextgroup=@rubyPostfix,@rubyArguments skipwhite

" Numbers {{{3
execute g:ruby#syntax#numbers

" Strings {{{3
syn match rubyCharacter /\%#=1?\%(\\\%(\o\{1,3}\|x\x\{,2}\|u\%(\x\{,4}\|{\x\{1,6}}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\|\_.\)\|.\)/ contains=rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubyString matchgroup=rubyStringStart start=/\%#=1"/ matchgroup=rubyStringEnd end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn match rubyStringInterpolation /\%#=1#@@\=\h\w*/ contained contains=rubyStringInterpolationDelimiter,rubyInstanceVariable,rubyClassVariable
syn match rubyStringInterpolation /\%#=1#\$\%(\h\w*\|[!@~&`'+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)/ contained contains=rubyStringInterpolationDelimiter,rubyGlobalVariable
syn match rubyStringInterpolationDelimiter /\%#=1#/ contained
syn region rubyStringInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#{/ end=/\%#=1}/ contained contains=@rubyTop,rubyNestedBraces
syn region rubyNestedBraces start=/\%#=1{/ matchgroup=rubyDelimiter end=/\%#=1}/ contained transparent nextgroup=@rubyPostfix skipwhite

syn match rubyStringEscape /\%#=1\\\_./ contained
syn match rubyStringEscapeError /\%#=1\\\%(x\|u\x\{,3}\)/ contained
syn match rubyStringEscape /\%#=1\\\%(\o\{1,3}\|x\x\x\=\|u\%(\x\{4}\|{\s*\x\{1,6}\%(\s\+\x\{1,6}\)*\s*}\)\|\%(c\|C-\)\%(\\M-\)\=.\|M-\%(\\c\|\\C-\)\=.\)/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1'/ matchgroup=rubyStringEnd end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix skipwhite
syn match rubyQuoteEscape /\%#=1\\[\\']/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=(/ matchgroup=rubyStringEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=\[/ matchgroup=rubyStringEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringSquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\={/ matchgroup=rubyStringEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=</ matchgroup=rubyStringEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyStringAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q(/ matchgroup=rubyStringEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn match rubyParenthesisEscape /\%#=1\\[\\()]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q\[/ matchgroup=rubyStringEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubySquareBracketEscape /\%#=1\\[\\\[\]]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q{/ matchgroup=rubyStringEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn match rubyCurlyBraceEscape /\%#=1\\[\\{}]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q</ matchgroup=rubyStringEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyAngleBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyAngleBracketEscape /\%#=1\\[\\<>]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayParenthesisEscape /\%#=1\\[()[:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArraySquareBracketEscape /\%#=1\\[\[\][:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w{/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayCurlyBraceEscape /\%#=1\\[{}[:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayAngleBracketEscape /\%#=1\\[<>[:space:]]/ contained

" Symbols {{{3
syn match rubySymbol /\%#=1:\h\w*[=?!]\=/ contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite
execute 'syn match rubySymbol /\%#=1:'.g:ruby#syntax#overloadable_operators.'/ contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite'

syn match rubySymbolStart /\%#=1:/ contained

syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1:"/ matchgroup=rubySymbolEnd end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1:'/ matchgroup=rubySymbolEnd end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix skipwhite

syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s(/  matchgroup=rubySymbolEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s\[/ matchgroup=rubySymbolEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s{/  matchgroup=rubySymbolEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s</  matchgroup=rubySymbolEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite

" Regular Expressions {{{3
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1\/\s\@!/ matchgroup=rubyRegexEnd end=/\%#=1\/[imx]*/ skip=/\%#=1\\\\\|\\\// oneline keepend contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite

" NOTE: This is defined here in order to take precedence over /-style
" regexes
syn match rubyOperator /\%#=1\/=/ contained

syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r(/  matchgroup=rubyRegexEnd end=/\%#=1)[imx]*/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r\[/ matchgroup=rubyRegexEnd end=/\%#=1][imx]*/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r{/  matchgroup=rubyRegexEnd end=/\%#=1}[imx]*/ skip=/\%#=1{.\{-}}/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r</  matchgroup=rubyRegexEnd end=/\%#=1>[imx]*/ skip=/\%#=1<.\{-}>/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite

" Onigmo {{{4
syn cluster rubyOnigmo contains=
      \ rubyOnigmoGroup,rubyOnigmoEscape,rubyOnigmoMetaCharacter,rubyOnigmoQuantifier,rubyOnigmoComment,rubyOnigmoClass

execute g:ruby#syntax#onigmo_escape
execute g:ruby#syntax#onigmo_group

syn match rubyOnigmoMetaCharacter /\%#=1[.^$|]/ contained

syn match rubyOnigmoQuantifier /\%#=1[?*+][?+]\=/ contained
syn match rubyOnigmoQuantifier /\%#=1{\%(\d\+,\=\d*\|,\d\+\)}[?+]\=/ contained

syn region rubyOnigmoComment start=/\%#=1(?#/ end=/\%#=1)/ contained contains=rubyRegexSlashEscape
syn match rubyRegexSlashEscape /\%#=1\\\// contained

syn region rubyOnigmoClass matchgroup=rubyOnigmoMetaCharacter start=/\%#=1\[\^\=/ end=/\%#=1\]/ contained transparent contains=rubyOnigmoEscape,rubyStringEscape,rubyStringEscapeError,rubyOnigmoPOSIXClass,rubyOnigmoClass,rubyOnigmoIntersection
syn match rubyOnigmoPOSIXClass /\%#=1\[:\^\=\h\w*:\]/ contained
syn match rubyOnigmoIntersection /\%#=1&&/ contained nextgroup=rubyOnigmoClass

" Commands {{{3
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1`/ matchgroup=rubyCommandEnd end=/\%#=1`/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x(/  matchgroup=rubyCommandEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x\[/ matchgroup=rubyCommandEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x{/  matchgroup=rubyCommandEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x</  matchgroup=rubyCommandEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

" Additional % Literals {{{3
syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyStringEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyStringEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ nextgroup=@rubyPostfix skipwhite
syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubySymbolEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyRegexEnd end=/\%#=1\z1[imx]*/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x\z([~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyCommandEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn match rubyArrayEscape /\%#=1\\\s/ contained

" Here Documents {{{3
syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\(`\=\)\z(\w\+\)\1/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ contains=rubyHeredocStartLine,rubyHeredocLine
syn match rubyHeredocStartLine /\%#=1.*/ contained contains=@rubyPostfix,@rubyArguments nextgroup=rubyHeredocLine skipempty
syn match rubyHeredocLine /\%#=1^.*/ contained contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=rubyHeredocLine skipempty

syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\='\z(\w\+\)'/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ contains=rubyHeredocStartLineRaw,rubyHeredocLineRaw
syn match rubyHeredocStartLineRaw /\%#=1.*/ contained contains=@rubyPostfix,@rubyArguments nextgroup=rubyHeredocLineRaw skipempty
syn match rubyHeredocLineRaw /\%#=1^.*/ contained nextgroup=rubyHeredocLineRaw skipempty

syn region rubyHeredocSkip matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\([`']\=\)\w\+\1/ end=/\%#=1\ze<<[-~]\=[`']\=\w/ contains=@rubyPostfix,@rubyArguments oneline nextgroup=rubyHeredoc,rubyHeredocSkip

" Blocks {{{2
if get(g:, "ruby_simple_indent") || get(b:, "is_eruby")
  syn keyword rubyKeyword if unless case while until for begin else elsif when ensure
  syn keyword rubyKeyword in nextgroup=rubyHashKey skipwhite
  syn keyword rubyKeyword rescue nextgroup=rubyConstant,rubyOperator skipwhite
  syn keyword rubyKeyword end nextgroup=@rubyPostfix skipwhite
  syn keyword rubyKeyword do nextgroup=rubyBlockParameters skipwhite

  syn keyword rubyKeyword def nextgroup=rubyMethodDefinition,rubyMethodReceiver,rubyMethodSelf skipwhite
  syn keyword rubyKeyword class module nextgroup=rubyTypeDefinition skipwhite

  syn keyword rubyKeyword public private protected nextgroup=rubySymbol skipwhite
else
  " NOTE: When definition blocks are highlighted, the following keywords
  " have to be matched with :syn-match instead of :syn-keyword to
  " prevent the block regions from being clobbered.

  syn keyword rubyKeywordError end else elsif when in ensure rescue
  syn keyword rubyKeywordError and or then

  syn match rubyKeyword /\%#=1\<do\>/ nextgroup=rubyBlockParameters skipwhite contained containedin=rubyBlock
  syn region rubyBlock start=/\%#=1\<do\>/ matchgroup=rubyKeyword end=/\%#=1\<\.\@1<!end\>/ contains=TOP nextgroup=@rubyPostfix skipwhite

  syn region rubyBlock matchgroup=rubyKeyword start=/\%#=1\<\%(if\|unless\|case\|begin\|for\|while\|until\)\>/ end=/\%#=1\<\.\@1<!end\>/ contains=TOP nextgroup=@rubyPostfix skipwhite
  syn keyword rubyKeyword else elsif when ensure contained containedin=rubyBlock
  syn keyword rubyKeyword in contained containedin=rubyBlock nextgroup=rubyHashKey skipwhite
  syn keyword rubyKeyword rescue contained containedin=rubyBlock nextgroup=rubyConstant,rubyOperator skipwhite

  syn region rubyBlockSkip matchgroup=rubyKeywordNoBlock start=/\%#=1\<\%(while\|until\|for\)\>/ end=/\%#=1\ze\<\.\@1<!do\>/ transparent oneline nextgroup=rubyBlock

  syn match rubyDefine /\%#=1\<def\>/ nextgroup=rubyMethodDefinition,rubyMethodReceiver,rubyMethodSelf skipwhite
  syn match rubyDefine /\%#=1\<\%(class\|module\)\>/ nextgroup=rubyTypeDefinition skipwhite contained containedin=rubyDefineBlock

  syn region rubyDefineBlock start=/\%#=1\<\%(def\|class\|module\)\>/ matchgroup=rubyDefine end=/\%#=1\<\.\@1<!end\>/ contains=TOP fold
  syn keyword rubyDefine else ensure contained containedin=rubyDefineBlock
  syn keyword rubyDefine rescue contained containedin=rubyDefineBlock nextgroup=rubyConstant,rubyOperator skipwhite

  " This is to handle "endless" definitions:
  syn region rubyDefineLine matchgroup=rubyDefineNoBlock start=/\%#=1\<def\>/ matchgroup=rubyMethodAssignmentOperator end=/\%#=1=/ skip=/\%#=1\%((.*)\|=\%([>~]\|==\=\)\|!=\|\[\]=\|[[:lower:]_]\w*=\=\)/ oneline contains=rubyMethodDefinition

  syn keyword rubyDefine public private protected nextgroup=rubyDefineBlock,rubyDefineLine,rubySymbol skipwhite
endif

syn match rubyTypeDefinition /\%#=1\u\w*/ contained nextgroup=rubyTypeNamespace,rubyInheritanceOperator skipwhite
syn match rubyTypeNamespace /\%#=1::/ contained nextgroup=rubyTypeDefinition
syn match rubyInheritanceOperator /\%#=1</ contained nextgroup=rubyConstant skipwhite

syn match rubyMethodDefinition /\%#=1[[:lower:]_]\w*[=?!]\=/ contained nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey skipwhite
execute 'syn match rubyMethodDefinition /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey skipwhite'
syn region rubyMethodParameters matchgroup=rubyDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@rubyTop,rubyHashKey nextgroup=rubyMethodAssignmentOperator skipwhite
syn match rubyMethodReceiver /\%#=1\h\w*\./ contained contains=rubyMethodReceiverVariable,rubyMethodReceiverConstant,rubyMethodReceiverSelf,rubyMethodReceiverDot nextgroup=rubyMethodDefinition
syn match rubyMethodReceiverVariable /\%#=1[[:lower:]_]\w*/ contained
syn match rubyMethodReceiverConstant /\%#=1\u\w*/ contained
syn keyword rubyMethodReceiverSelf self contained
syn match rubyMethodReceiverDot /\%#=1\./ contained
syn match rubyMethodAssignmentOperator /\%#=1=/ contained

" Miscellaneous {{{2
syn keyword rubyKeyword not undef
syn keyword rubyKeyword include extend nextgroup=rubyConstant skipwhite
syn keyword rubyKeyword return next break yield redo retry nextgroup=rubyPostfixKeyword skipwhite

syn keyword rubyKeyword alias nextgroup=rubyAlias
syn region rubyAlias start=/\%#=1/ end=/\%#=1$/ contained contains=rubySymbolAlias,rubyGlobalVariableAlias,rubyMethodAlias
syn match rubySymbolAlias /\%#=1:[[:lower:]_]\w*[=?!]\=/ contained contains=rubySymbolStart
execute 'syn match rubySymbolAlias /\%#=1:'.g:ruby#syntax#overloadable_operators.'/ contained'
syn match rubyGlobalVariableAlias /\%#=1\$\%(\h\w*\|-\w\)/ contained
syn match rubyMethodAlias /\%#=1[[:lower:]_]\w*[=?!]\=/ contained
execute 'syn match rubyMethodAlias /\%#=1'.g:ruby#syntax#overloadable_operators.'/ contained'

syn keyword rubyPostfixKeyword and or then if unless while until contained
syn keyword rubyPostfixKeyword rescue contained nextgroup=rubyHashKey,rubyOperator skipwhite skipempty
syn keyword rubyPostfixKeyword in contained nextgroup=rubyHashKey skipwhite

syn keyword rubyKeyword require require_relative nextgroup=rubyString skipwhite

syn keyword rubyKeyword BEGIN END

syn region rubyBlockParameters matchgroup=rubyDelimiter start=/\%#=1|/ end=/\%#=1|/ transparent contained
" }}}2

" Highlighting {{{1
hi def link rubyComment Comment
hi def link rubyLineComment rubyComment
hi def link rubyTodo Todo
hi def link rubyShebang Special
hi def link rubyOperator Operator
hi def link rubyUnaryOperator rubyOperator
hi def link rubyRangeOperator rubyOperator
hi def link rubyMethodOperator rubyOperator
hi def link rubyNamespaceOperator rubyOperator
hi def link rubyDelimiter Delimiter
hi def link rubyInstanceVariable Identifier
hi def link rubyClassVariable Identifier
hi def link rubyGlobalVariable Identifier
hi def link rubyConstant Identifier
hi def link rubyHashKey rubySymbol
hi def link rubyNil Constant
hi def link rubyBoolean Boolean
hi def link rubySelf Constant
hi def link rubySuper Constant
hi def link rubyNumber Number
hi def link rubyCharacter Character
hi def link rubyString String
hi def link rubyStringStart rubyString
hi def link rubyStringEnd rubyStringStart
hi def link rubyStringArray rubyString
hi def link rubyStringArrayDelimiter rubyStringArray
hi def link rubyStringEscape SpecialChar
hi def link rubyStringEscapeError Error
hi def link rubyQuoteEscape rubyStringEscape
hi def link rubyStringInterpolationDelimiter PreProc
hi def link rubyStringParenthesisEscape rubyStringEscape
hi def link rubyStringSquareBracketEscape rubyStringEscape
hi def link rubyStringCurlyBraceEscape rubyStringEscape
hi def link rubyStringAngleBracketEscape rubyStringEscape
hi def link rubyArrayEscape rubyStringEscape
hi def link rubyArrayParenthesisEscape rubyStringEscape
hi def link rubyArraySquareBracketEscape rubyStringEscape
hi def link rubyArrayCurlyBraceEscape rubyStringEscape
hi def link rubyArrayAngleBracketEscape rubyStringEscape
hi def link rubyHeredocLine String
hi def link rubyHeredocLineRaw rubyHeredocLine
hi def link rubyHeredocStart rubyHeredocLine
hi def link rubyHeredocEnd rubyHeredocStart
hi def link rubySymbol String
hi def link rubySymbolStart rubySymbol
hi def link rubySymbolEnd rubySymbolStart
hi def link rubySymbolArray rubySymbol
hi def link rubySymbolArrayDelimiter rubySymbolArray
hi def link rubyRegex String
hi def link rubyRegexStart rubyRegex
hi def link rubyRegexEnd rubyRegexStart
hi def link rubyOnigmoMetaCharacter SpecialChar
hi def link rubyOnigmoEscape rubyOnigmoMetaCharacter
hi def link rubyOnigmoQuantifier rubyOnigmoMetaCharacter
hi def link rubyOnigmoComment rubyComment
hi def link rubyOnigmoPOSIXClass rubyOnigmoMetaCharacter
hi def link rubyOnigmoIntersection rubyOnigmoMetaCharacter
hi def link rubyRegexSlashEscape rubyStringEscape
hi def link rubyCommand String
hi def link rubyCommandStart rubyCommand
hi def link rubyCommandEnd rubyCommandStart
hi def link rubyKeyword Keyword
hi def link rubyKeywordNoBlock rubyKeyword
hi def link rubyPostfixKeyword rubyKeyword
hi def link rubyDefine Define
hi def link rubyDefineNoBlock rubyDefine
hi def link rubyKeywordError Error
hi def link rubyMethodDefinition Typedef
hi def link rubyMethodReceiverConstant rubyConstant
hi def link rubyMethodReceiverSelf rubySelf
hi def link rubyMethodReceiverDot rubyOperator
hi def link rubyMethodAssignmentOperator rubyOperator
hi def link rubyTypeDefinition Typedef
hi def link rubyTypeNamespace rubyOperator
hi def link rubySymbolAlias rubySymbol
hi def link rubyGlobalVariableAlias rubyGlobalVariable
hi def link rubyMethodAlias rubyMethodDefinition
" }}}1

let b:current_syntax = "ruby"

" vim:fdm=marker
