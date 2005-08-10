%{
#include <stdio.h>
%}

%union { char *string; }
%token EXT EQ COMMENT NL PRIO WORD WS STRING

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
    | words
    ;
ext
    : EXT ws WORD exttail
    ;
exttail
    : ws extbody
    | ws appline
    ;
extbody
    : '{' applist '}'
    ;
applist
    : applist ws appline eol
    | /* empty */
    ;
appline
    : PRIO ws app
    | app
    |
    ;
app
    : WORD '(' ws appargs ')' ws
    | WORD ',' ws appargs
    | WORD '|' ws appargs
    | WORD
    ;
appargs
    : appargs ',' ws apparg
    | appargs '|' ws apparg
    | apparg
    ;
apparg
    : appargl
    | STRING
    ;
appargl
    : words varref appargl
    | varref appargl
    | words
    |
    ;
varref
    : '$' '{' apparg '}' 
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
