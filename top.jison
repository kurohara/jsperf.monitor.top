/**
 *
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
	| block summary NL header NL datalist
;

summary
	: process_summary datetime loadavg cpuusage sharedlibs memregions physmem vm networks disks
;

process_summary
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL NL
	{
	}
;

datetime
	: DATE TIME NL
;

loadavg
	: TAGSYMBOL FVAL ',' FVAL ',' FVAL NL
;

cpuusage
	: TAGSYMBOL FVAL '%' SYMBOL ',' FVAL '%' SYMBOL ',' FVAL '%' SYMBOL NL
;

sharedlibs
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVALBYTES SYMBOL '.' NL
;

memregions
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL ',' IVAL SYMBOL '.' NL
;

physmem
	: TAGSYMBOL IVAL SYMBOL '(' IVAL SYMBOL ')' ',' IVAL SYMBOL '.' NL
;

vm
	: TAGSYMBOL IVAL SYMBOL ',' IVAL SYMBOL SYMBOL ',' IVAL '(' IVAL ')' SYMBOL ',' IVAL '(' IVAL ')' SYMBOL '.' NL
;

networks
	: TAGSYMBOL TAGSYMBOL IVAL '/' IVAL SYMBOL ',' IVAL '/' IVAL SYMBOL '.' NL
;

disks
	: TAGSYMBOL IVAL '/' IVAL SYMBOL ',' IVAL '/' IVAL SYMBOL '.' NL
;

header
	: 
	| header SYMBOL
	| header PCTTAG
	| header QTYTAG
;


datalist
	: data NL
	  { /* yy.controller.dsSend($1);*/ }
	| datalist data NL
	  { /* yy.controller.dsSend($2);*/ }
;

data
	: 
	| data IVAL
	  { /* $1[yy.keys[yy.keyindex++]] = $2; $$ = $1;*/ }
	| data FVAL
	  { /* $1[yy.keys[yy.keyindex++]] = $2; $$ = $1;*/ }
	| data IVALOV
	| data IVALNEG
	| data FVALOV
	| data IVALBYTESOV
	| data procname
	| data NA
	| data annoval
	| data IVALBYTES
	| data INTERVAL
	| data TIME
	| data ivalneg
	| data fraction
;

procname
	: SYMBOL
	| INAME
	| COMPWORD
;

annoval
	: fv '[' fv ']'
	| '*' fv '[' fv ']'
;

fv
	: IVAL
	| IVALOV
	| IVALNEG
;

fraction
	: IVAL '/' IVAL
;

%%

/**
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

**/