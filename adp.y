%{
#include <stdio.h>
%}

%token SWITCH INCLUDE IGNOREPAT EXT EQ COMMENT PRIO IDENT DOLBRACE CLOSEBRACE STRING NL 

%%

config
    : config eol
    | config context
    | 
    ;
context
    : '[' ctxname ']' eol ctxlines
    ;
ctxlines
    : ctxlines ctxline eol
    |
    ;
ctxline
    : varassign
    | ext
    | sw
    | incl
    | ignorepat 
    ;
varassign
    : varname '=' val
    ;
sw
    : SWITCH EQ val
    ;
incl
    : INCLUDE EQ ctxname
    ;
ignorepat
    : IGNOREPAT EQ extname
    ;
ext
    : EXT extname '{' applist '}'
    | EXT extname appline
    ;
applist
    : applist eol
    | applist appline
    |
    ;
appline
    : prio app
    | app
    ;
app
    : appname '(' appargs ')'
    | appname ',' appargs
    | appname
    ;
appargs
    : appargs ',' val
    | appargs '|' val
    | val
    ;
val
    : IDENT
    | STRING
    | varref
    ;
varref
    : DOLBRACE val CLOSEBRACE
    ;
eol
    : COMMENT NL
    | NL
    ;
prio
    : '+' IDENT
    ;

ctxname: IDENT
       ;
varname: IDENT
       ;
extname: IDENT
       ;
appname: IDENT
       ;

%%

extern FILE *yyin;

int main(void)
{
    yydebug = 1;
    do yyparse(); while(!feof(yyin));
}
