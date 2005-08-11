%{
#include <stdio.h>
#include "util.h"
%}

%union { char *string; }
%token <string> EXT EQ COMMENT NL PRIO WORD WS STRING
%type <string> adp context 
%type <string> ctxlinelist ctxline statement ext exttail extbody applist 
%type <string> appline app appargs apparg appargl varref eol ws words

%%

adp
    : adp context
    | { $$ = "" }
    ;
context
    : '[' words ']' ws eol ctxlinelist 
    { printf("%s",strjoin(6,"[",$2,"]",$4,$5,$6)); }
    ;
ctxlinelist
    : ws ctxline eol ctxlinelist { $$ = strjoin(4,$1,$2,$3,$4); }
    | { $$ = "" }
    ;
ctxline
    : statement
    | ext
    | { $$ = "" }
    ;
statement
    : words EQ ws words { $$ = strjoin(4,$1,$2,$3,$4); }
    | words
    ;
ext
    : EXT ws WORD exttail { $$ = strjoin(4,$1,$2,$3,$4); }
    ;
exttail
    : ws extbody { $$ = strjoin(2,$1,$2); }
    | ws appline { $$ = strjoin(2,$1,$2); }
    ;
extbody
    : '{' applist '}' { $$ = strjoin(3,"{",$2,"}"); }
    ;
applist
    : applist ws appline eol { $$ = strjoin(4,$1,$2,$3,$4); }
    | { $$ = "" }
    ;
appline
    : PRIO ws app { $$ = strjoin(3,$1,$2,$3); }
    | app
    | { $$ = "" }
    ;
app
    : WORD '(' ws appargs ')' ws { $$ = strjoin(6,$1,"(",$3,$4,")",$6); }
    | WORD ',' ws appargs { $$ = strjoin(4,$1,",",$3,$4); }
    | WORD '|' ws appargs { $$ = strjoin(4,$1,"|",$3,$4); }
    | WORD
    ;
appargs
    : appargs ',' ws apparg { $$ = strjoin(4,$1,",",$3,$4); }
    | appargs '|' ws apparg { $$ = strjoin(4,$1,"|",$3,$4); }
    | apparg
    ;
apparg
    : appargl
    | STRING
    ;
appargl
    : words varref appargl { $$ = strjoin(2,$1,$2); }
    | varref appargl { $$ = strjoin(2,$1,$2); }
    | words
    | { $$ = "" }
    ;
varref
    : '$' '{' apparg '}'  { $$ = strjoin(3,"${",$3,"}"); }
    ;
eol
    : COMMENT NL { $$ = strjoin(2,$1,$2); }
    | NL
    ;
ws
    : WS
    | { $$ = "" }
    ;
words
    : words WORD ws { $$ = strjoin(3,$1,$2,$3); }
    | WORD ws { $$ = strjoin(2,$1,$2); }
    ;
%%

extern FILE *yyin;

int main(int argc, char **argv)
{
    if (argc > 1) yydebug = 1;
    char *a = "Hello";
    char *b = ", ";
    char *c = "world";
    char *d = "!";
    fprintf(stderr,"%s\n",strjoin(4,a,b,c,d));

    do yyparse(); while(!feof(yyin));
}
