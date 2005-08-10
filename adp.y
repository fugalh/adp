%{
#include <stdio.h>
%}

%token EXT EQ COMMENT NL PRIO WORD WS

%%

adp
    : adp context
    | /* empty */
    ;
context
    : '[' words ']' ws eol ctxlinelist
    ;
ctxlinelist
    : ws ctxline eol ctxlinelist
    | 
    ;
ctxline
    : statement
    | ext
    | 
    ;
statement
    : words EQ ws words
    ;
ext
    : EXT ws WORD exttail
    ;
exttail
    : ws extbody
    | appline
    ;
extbody
    : '{' applist '}'
    ;
appline
    : ws PRIO ws words
    | ws words
    ;
applist
    : applist appline eol
    | /* empty */
    ;
eol
    : COMMENT NL
    | NL
    ;
ws
    : WS
    |
    ;
words
    : words WORD ws
    | WORD ws
    ;
%%

extern FILE *yyin;

int main(int argc, char **argv)
{
    if (argc > 1) yydebug = 1;
    do yyparse(); while(!feof(yyin));
}
