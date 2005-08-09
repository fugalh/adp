%{
#include "adp.tab.h"
%}

%%

\"[^"]\"	{ return STRING; }
[ \t]   /* ignore whitespace */ ;

"switch"|sw	{ return SWITCH; }
"include"	{ return INCLUDE; }
ignorepat	{ return IGNOREPAT; }
ext|x|extension|exten	{ return EXT; }
=>?	{ return EQ; }
;.*$    { return COMMENT; }
[-_a-zA-Z0-9#*/@:]+  { return IDENT; }
"${"      { return DOLBRACE; }
"}"       { return CLOSEBRACE; }
\n|\r\n?	{ return NL; }
[\(\)\[\]\=\{\}\,\|]	{ return yytext[0]; }
.       { printf("unrecognized: %s\n",yytext); }

%%
