%{
#include "adp.tab.h"
#include <string.h>
int lineno = 1;
%}

%%

[ \t]+			{ yylval.string = strdup(yytext); return WS; }
;.*$			{ yylval.string = strdup(yytext); return COMMENT; }
^[ \t]*\+?[0-9]+:	{ yylval.string = strdup(yytext); return PRIO; }
ext|x|exten|extension	{ return EXT; }
=>?			{ return EQ; }
\n|\r\n?		{ lineno++; return NL; }
[^\[\]\n=\${};\"',\|\(\)\t ]+	{ yylval.string = strdup(yytext); return WORD; }
\"[^\"]*\"|\'[^']\'	{ yylval.string = strdup(yytext); return STRING; }
. 			{ return yytext[0]; }

%%

void yyerror(char *s)
{
    printf("%d: %s at '%s'\n",(yytext[0] == '\n' ? lineno-1 : lineno),
	s,yytext);
}
