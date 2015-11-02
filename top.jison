/** -*- tab-width : 2 -*-
 * 
 * Syntax definition for 'top' command of macosx.
 * Copyright (C) 2015 Hiroyoshi Kurohara.
 * E-mail: kurohara@yk.rim.or.jp, kurohara@microgadget-inc.com
 * Licensed under MIT the the license.
 */
 
/*****
//
// No additional lexer definition is defined in  this file.
// The lexer definition in this part will be merged into default lexer.
// The default lexer is defined in jsperf/lib/deflex.l".
//
%lex

%%

/lex

****/
 
%start top

%%

top
	: block EOF
	  { return; }
;

block
	: summary NL header NL datalist
	{
		yy.controller.dsSend(	{ summary: $1, data: $5 } );
	}
	| block summary NL header NL datalist
	{
		yy.controller.dsSend( { summary: $2, data: $6 } );
	}
;

summary
	: process_summary datetime loadavg cpuusage sharedlibs memregions physmem vm networks disks
	{
		$$ = { };
		$$[$1.name] = $1;
		$$.datetime = $2;
		$$[$3.name] = $3;
		$$[$4.name] = $4;
		$$[$5.name] = $5;
		$$[$6.name] = $6;
		$$[$7.name] = $7;
		$$[$8.name] = $8;
		$$[$9.name] = $9;
		$$[$10.name] = $10;
	}
;

process_summary
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL NL
	{
		$$ = { name: $1.value };
		$$[$3.value] = $2.value;
		$$[$6.value] = $5.value;
		$$[$9.value] = $8.value;
		$$[$12.value] = $11.value;
		$$[$15.value] = $14.value;
	}
;

datetime
	: DATE TIME NL
	{
		$$ = $1.value;
		$$.setHours(
					$2.value.getHours(),
					$2.value.getMinutes(), 
					$2.value.getSeconds(), 
					$2.value.getMilliseconds()
		);
	}
;

loadavg
	: TAGSYMBOL FVAL ',' FVAL ',' FVAL NL
	{
		$$ = { name: $1.value, "1": $2.value, "5": $4.value };
	}
;

cpuusage
	: TAGSYMBOL FVAL '%' SYMBOL ',' FVAL '%' SYMBOL ',' FVAL '%' SYMBOL NL
	{
		$$ = { name: $1.value };
		$$[$4.value] = $2.value;
		$$[$8.value] = $6.value;
		$$[$12.value] = $10.value;
	}
;

sharedlibs
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVALBYTES SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$3.value] = $2.value;
		$$[$6.value] = $5.value;
		$$[$9.value] = $8.value;
	}
;

memregions
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$3.value] = $2.value;
		$$[$6.value] = $5.value;
		$$[$9.value] = $8.value;
		$$[$12.value] = $11.value;
	}
;

physmem
	: TAGSYMBOL IVAL SYMBOL '(' IVAL SYMBOL ')' ',' IVAL SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$3.value] = $2.value;
		$$[$6.value] = $5.value;
		$$[$10.value] = $9.value;
	}
;

vm
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL SYMBOL ',' IVAL '(' IVAL ')' SYMBOL ',' IVAL '(' IVAL ')' SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$3.value] = $2.value;
		$$[$6.value + " " + $7.value] = $5.value;
		$$[$13.value] = $9.value;
		$$[$19.value] = $15.value;
	}
;

networks
	: TAGSYMBOL TAGSYMBOL IVAL '/' IVAL SYMBOL ',' IVAL '/' IVAL SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$6.value] = $3.value;
		$$[$11.value] = $8.value;
	}
;

disks
	: TAGSYMBOL IVAL '/' IVAL SYMBOL ',' IVAL '/' IVAL SYMBOL '.' NL
	{
		$$ = { name: $1.value };
		$$[$5.value] = $2.value;
		$$[$10.value] = $7.value;
	}
;

header
	: 
	{
		yy.keys = [];
	}
	| header SYMBOL
	{
		yy.keys.push($2.yytext);
	}
	| header PCTTAG
	{
		yy.keys.push($2.yytext);
	}
	| header QTYTAG
	{
		yy.keys.push($2.yytext);
	}
;


datalist
	: data NL
	  { $$ = [ $1 ]; }
	| datalist data NL
	  { $1.push($2); $$ = $1; }
;

data
	: 
	{
		yy.keyindex = 0;
		$$ = {};
	}
	| data IVAL
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data IVALOV
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data IVALUND
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data FVAL
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data FVALOV
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data IVALBYTESOV
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data procname
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data NA
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data annoval
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data IVALBYTES
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data INTERVAL
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data TIME
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data ivalneg
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
	| data fraction
	  { $1[yy.keys[yy.keyindex++]] = $2.value; $$ = $1; }
;

procname
	: SYMBOL
	{ $$ = $1; }
	| INAME
	{ $$ = $1; }
	| COMPWORD
	{ $$ = $1; }
;

annoval
	: fv '[' fv ']'
	{
		$$ = {};
		$$.value = $1.yytext + '[' + $3.yytext + ']';
	}
	| '*' fv '[' fv ']'
	{
		$$ = {}
		$$.value = '*' + $2.yytext + '[' + $4.yytext + ']';
	}
;

fv
	: IVAL
	{ $$ = $1; }
	| IVALOV
	{ $$ = $1; }
	| IVALUND
	{ $$ = $1; }
;

fraction
	: IVAL '/' IVAL
	{
		$$ = { value: $1.yytext + "/" + $3.yytext };
	}
;

%%

/*
 * sample output of macosx top command.
 */
/*
Processes: 264 total, 2 running, 4 stuck, 258 sleeping, 1368 threads
2015/10/23 15:15:48
Load Avg: 1.36, 1.46, 1.53
CPU usage: 5.63% user, 23.94% sys, 70.42% idle
SharedLibs: 14M resident, 16M data, 0B linkedit.
MemRegions: 65184 total, 1440M resident, 39M private, 384M shared.
PhysMem: 4077M used (932M wired), 17M unused.
VM: 655G vsize, 1095M framework vsize, 77702579(0) swapins, 79070174(0) swapouts.
Networks: packets: 51216677/26G in, 45613673/19G out.
Disks: 19802492/658G read, 10545302/546G written.

PID    COMMAND          %CPU TIME     #TH   #WQ #PORTS  MEM    PURG   CMPRS  PGRP  PPID  STATE    BOOSTS       %CPU_ME %CPU_OTHRS UID FAULTS     COW      MSGSENT     MSGRECV     SYSBSD     SYSMACH    CSW         PAGEINS  IDLEW     POWER USER            #MREGS RPRVT VPRVT VSIZE KPRVT KSHRD
98523  helpd            0.0  00:00.02 2     0   34+     316K+  0B     736K+  98523 1     sleeping  0[0]        0.00000 0.00000    501 1650+      135+     140+        50+         442+       296+       170+        2+       1         0.0   kurohara        N/A    N/A   N/A   N/A   N/A   N/A
97627  mapspushd        0.0  00:00.05 2     0   65+     32K+   0B     1620K+ 97627 1     sleeping *0[2+]       0.00000 0.00000    501 2147+      168+     579+        251+        1326+      976+       1378+       29+      4         0.0   kurohara        N/A    N/A   N/A   N/A   N/A   N/A
97622  com.apple.Commer 0.0  00:00.24 4     1   90+     856K+  0B     2704K+ 97622 1     sleeping *0[2+]       0.00000 0.00000    501 3521+      202+     844+        320+        4147+      1402+      1363+       22+      25        0.0   kurohara        N/A    N/A   N/A   N/A   N/A   N/A

 */