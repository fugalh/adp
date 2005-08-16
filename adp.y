%{
#include <stdio.h>
#include "util.h"
#include <string.h>

char *curext;
int prio;

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
    : WORD ws EQ ws words { $$ = strjoin(4,$1,"=",$4,$5); }
    | WORD ws words { $$ = strjoin(3,$1,"=",$3); }
    ;
ext
    : extdecl exttail { $$ = $2 }
    ;
extdecl
    : EXT ws WORD { curext = strdup($3); prio = 1; }
    ;
exttail
    : ws extbody { $$ = $2 }
    | ws appline { $$ = $2 }
    ;
extbody
    : '{' applist '}' { $$ = $2 }
    ;
applist
    : applist ws appline eol { $$ = strjoin(2,$1,$3); }
    | { $$ = "" }
    ;
appline
    : prio app { asprintf(&$$, "exten => %s,%d,%s\n",curext,prio,$2); ++prio; }
    | app { asprintf(&$$, "exten => %s,%d,%s\n",curext,prio,$1); ++prio }
    | { $$ = "" }
    ;
prio
    : PRIO ws { prio = atoi($1); }
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
    : COMMENT NL { $$ = strjoin(2,$1,"\n"); }
    | NL { $$ = "\n"; }
    ;
ws
    : WS
    | { $$ = ""; }
    ;
words
    : words WORD ws { $$ = strjoin(3,$1,$2,$3); }
    | WORD ws { $$ = strjoin(2,$1,$2); }
    ;
%%

extern FILE *yyin;

int main(int argc, char **argv)
{
    curext = "s";
    prio = 1;
    if (argc > 1) yydebug = 1;
    do yyparse(); while(!feof(yyin));
}
