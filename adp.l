%{
#include "adp.tab.h"
int lineno = 1;
%}

%%

^[ \t]+	;
[ \t]+			{ return WS; }
;.*$			{ return COMMENT; }
^[ \t]*\+?[0-9]+:	{ return PRIO; }
ext|x|exten|extension	{ return EXT; }
=>?			{ return EQ; }
\n|\r\n?		{ lineno++; return NL; }
[^\[\]\n=\${}; \t]+	{ return WORD; }
. 			{ return yytext[0]; }

%%

void yyerror(char *s)
{
    printf("%d: %s at '%s'\n",(yytext[0] == '\n' ? lineno-1 : lineno),
	s,yytext);
}
