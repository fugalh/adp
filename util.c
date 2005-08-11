#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include "util.h"

/* caller is responsible for freeing returned string */
char *vstrjoin(va_list ap)
{
    const char *a;
    char *b;
    char *ret;
    a = va_arg(ap, char*);
    if (a)
    {
	b = vstrjoin(ap);
	if (b)
	{
	    asprintf(&ret, "%s%s", a, b);
	} else {
	    ret = strdup(a);
	}
    }
    else
	ret = 0;
    return ret;
}

/* caller is responsible for freeing returned string */
char *strjoin(int n, ...)
{
    va_list ap;
    char *ret;
    char fmt[101];
    int i;

    if (n > 50)
	return 0;

    for (i=0; i<n; i++)
	memcpy(fmt+(i*2), "%s", 2);
    fmt[n*2] = 0;

    va_start(ap,n);
    vasprintf(&ret, fmt, ap);
    va_end(ap);

    return ret;
}
