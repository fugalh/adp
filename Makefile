adp: adp.tab.c lex.yy.c
	cc -o $@ adp.tab.c lex.yy.c -ly -ll
lex.yy.c: adp.l adp.tab.h
	flex $<

adp.tab.h: adp.tab.c

adp.tab.c: adp.y
	bison -d -t -v $<

clean:
	rm -f adp.tab.* lex.yy.* adp.output
