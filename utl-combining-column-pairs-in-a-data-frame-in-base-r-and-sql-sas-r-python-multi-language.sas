%let pgm=utl-combining-column-pairs-in-a-data-frame-in-base-r-and-sql-sas-r-python-multi-language;

%stop_submission;

          SOLUTIONS

               1 sas sql hardcoded
               2 sas sql dynamic
               3 r sql hardcoded
               4 pyhton sql hardcoded
               5 base r dynamic

Combining-column-pairs-in-a-data-frame-in-base-r-and-sql-sas-r-python-multi-language;

github
https://tinyurl.com/yuyahrdc
https://github.com/rogerjdeangelis/utl-combining-column-pairs-in-a-data-frame-in-base-r-and-sql-sas-r-python-multi-language

stackoverflow
https://tinyurl.com/2wrbkvya
https://stackoverflow.com/questions/79255447/combining-column-pairs-in-a-data-frame-in-r

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                           |                                         |                                                  */
/*        INPUT              |       PROCESS                           |              OUTPUT                              */
/*        =====              |       =======                           |              ======                              */
/*                           |                                         |                                                  */
/*                           |                                         |                                                  */
/*  C C C C C C C C C C      | Combine every two coumns                |  C1     C2     C3     C4     C5                  */
/*  1 1 2 2 3 3 4 4 5 5      | so the final data frame                 |                                                  */
/*  - - - - - - - - - -      | would have n/2 columns.                 |  0|0    0|0    0|0    0|0    0|0                 */
/*  1 2 1 2 1 2 1 2 1 2      |                                         |  0|0    0|0    0|0    0|0    0|1                 */
/*                           | For instance                            |  0|0    0|0    0|0    0|0    0|0                 */
/*  0 0 0 0 0 0 0 0 0 0      |                                         |  0|1    0|1    0|1    1|1    1|1                 */
/*  0 0 0 0 0 0 0 0 0 1      |  C1_1  C1_2         C1                  |  0|0    0|0    0|0    0|0    0|0                 */
/*  0 0 0 0 0 0 0 0 0 0      |                                         |  0|0    0|0    0|0    0|0    0|0                 */
/*  0 1 0 1 0 1 1 1 1 1      |    1     2    =>   1|2                  |  0|0    0|0    0|0    0|0    0|0                 */
/*  0 0 0 0 0 0 0 0 0 0      |    2     1    =>   2|1                  |  0|1    0|1    0|1    0|0    0|0                 */
/*  0 0 0 0 0 0 0 0 0 0      |                                         |  0|0    0|0    0|0    0|0    0|0                 */
/*  0 0 0 0 0 0 0 0 0 0      | ----------------------------------------|  0|0    0|0    0|0    0|0    0|0                 */
/*  0 1 0 1 0 1 0 0 0 0      |                                         |                                                  */
/*  0 0 0 0 0 0 0 0 0 0      | 1 SAS SQL (SELF EXPLANATORY)            |                                                  */
/*  0 0 0 0 0 0 0 0 0 0      | ============================            |                                                  */
/*                           |                                         |                                                  */
/*                           | select                                  |                                                  */
/*                           |    catx('|',C1_1,C1_2) as C1            |                                                  */
/*                           |   ,catx('|',C2_1,C2_2) as C2            |                                                  */
/*                           |   ,catx('|',C3_1,C3_2) as C3            |                                                  */
/*                           |   ,catx('|',C4_1,C4_2) as C4            |                                                  */
/*                           |   ,catx('|',C5_1,C5_2) as C5            |                                                  */
/*                           | from                                    |                                                  */
/*                           |   sd1.have                              |                                                  */
/*                           |                                         |                                                  */
/*                           | 2 USING SAS SQL DYNAMIC ARRAYS          |                                                  */
/*                           | ==============================          |                                                  */
/*                           |                                         |                                                  */
/*                           | %array(left,values=                     |                                                  */
/*                           |   %utl_varlist(sd1.have,prx=/1$/));     |                                                  */
/*                           | %array(right, values=                   |                                                  */
/*                           |   %utl_varlist(sd1.have,prx=/2$/));     |                                                  */
/*                           |                                         |                                                  */
/*                           | select                                  |                                                  */
/*                           |   %do_over(left right,phrase=%str(      |                                                  */
/*                           |      catx('|',?left,?right) as          |                                                  */
/*                           |        %nrstr(%substr(?left,1,2)))      |                                                  */
/*                           |     ,between=comma)                     |                                                  */
/*                           | from                                    |                                                  */
/*                           |   sd1.have                              |                                                  */
/*                           |                                         |                                                  */
/*                           | Paste the sas generated code into       |                                                  */
/*                           | r and  python sql, see below            |                                                  */
/*                           | for details                             |                                                  */
/*                           |                                         |                                                  */
/*                           |-----------------------------------------|                                                  */
/*                           |                                         |                                                  */
/*                           |                                         |                                                  */
/*                           | 3 r sql (LAPPLY IS PART OF BASE R)      |                                                  */
/*                           | ==================================      |                                                  */
/*                           |                                         |                                                  */
/*                           | have[] <- lapply(have, as.character)    |                                                  */
/*                           | want<-sqldf("                           |                                                  */
/*                           |    select                               |                                                  */
/*                           |       C1_1||'|'||C1_2 as C1             |                                                  */
/*                           |      ,C2_1||'|'||C2_2 as C2             |                                                  */
/*                           |      ,C3_1||'|'||C3_2 as C3             |                                                  */
/*                           |      ,C4_1||'|'||C4_2 as C4             |                                                  */
/*                           |      ,C5_1||'|'||C5_2 as C5             |                                                  */
/*                           |    from                                 |                                                  */
/*                           |      have                               |                                                  */
/*                           |                                         |                                                  */
/*                           |-----------------------------------------|                                                  */
/*                           |                                         |                                                  */
/*                           | 4 python sql                            |                                                  */
/*                           | ============                            |                                                  */
/*                           |                                         |                                                  */
/*                           | have = have.astype(int)                 |                                                  */
/*                           | want=pdsql('''                          |                                                  */
/*                           |    select                               |                                                  */
/*                           |       C1_1||'|'||C1_2 as C1             |                                                  */
/*                           |      ,C2_1||'|'||C2_2 as C2             |                                                  */
/*                           |      ,C3_1||'|'||C3_2 as C3             |                                                  */
/*                           |      ,C4_1||'|'||C4_2 as C4             |                                                  */
/*                           |      ,C5_1||'|'||C5_2 as C5             |                                                  */
/*                           |    from                                 |                                                  */
/*                           |      have                               |                                                  */
/*                           |                                         |                                                  */
/*                           |-----------------------------------------|                                                  */
/*                           |                                         |                                                  */
/*                           | 5 base r  (see below for details)       |                                                  */
/*                           | ========                                |                                                  */
/*                           |                                         |                                                  */
/*                           | oddcols <- seq(1, ncol(have), by = 2)   |                                                  */
/*                           | want <- mapply(paste,have[oddcols]      |                                                  */
/*                           |   ,have[oddcols+1],sep="|")             |                                                  */
/*                           | colnames(want) <- sub("\\..*",""        |                                                  */|                                         |                                                  */
/*                           |  ,colnames(want))                       |                                                  */|                                         |                                                  */
/*                           |                                         |                                                  */
/**************************************************************************************************************************/

 /*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 input c1_1 c1_2
       c2_1 c2_2
       c3_1 c3_2
       c4_1 c4_2
       c5_1 c5_2;
cards4;
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 0 0 0
0 1 0 1 0 1 1 1 1 1
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 1 0 1 0 1 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
;;;;
run;quit;

proc print data=sd1.have heading=vertica;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.HAVE total obs=10                                                                                                  */
/*                                                                                                                        */
/* C1_1  C1_2  C2_1  C2_2  C3_1  C3_2  C4_1  C4_2  C5_1  C5_2                                                             */
/*                                                                                                                        */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     0     0     0     0     0     0     0     0     1                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     1     0     1     0     1     1     1     1     1                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     1     0     1     0     1     0     0     0     0                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*   0     0     0     0     0     0     0     0     0     0                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _  _                   _               _          _
/ |  ___  __ _ ___   ___  __ _| || |__   __ _ _ __ __| | ___ ___   __| | ___  __| |
| | / __|/ _` / __| / __|/ _` | || `_ \ / _` | `__/ _` |/ __/ _ \ / _` |/ _ \/ _` |
| | \__ \ (_| \__ \ \__ \ (_| | || | | | (_| | | | (_| | (_| (_) | (_| |  __/ (_| |
|_| |___/\__,_|___/ |___/\__, |_||_| |_|\__,_|_|  \__,_|\___\___/ \__,_|\___|\__,_|
                            |_|
*/

proc sql;
   create
      table want  as
   select
      catx('|',C1_1,C1_2) as C1
     ,catx('|',C2_1,C2_2) as C2
     ,catx('|',C3_1,C3_2) as C3
     ,catx('|',C4_1,C4_2) as C4
     ,catx('|',C5_1,C5_2) as C5
   from
     sd1.have
;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT total obs=10                                                                                                      */
/*                                                                                                                        */
/*   C1     C2     C3     C4     C5                                                                                       */
/*                                                                                                                        */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|0    0|0    0|0    0|0    0|1                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|1    0|1    0|1    1|1    1|1                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|1    0|1    0|1    0|0    0|0                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*   0|0    0|0    0|0    0|0    0|0                                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                              _
|___ \   ___  __ _ ___   ___  __ _| |   __ _ _ __ _ __ __ _ _   _ ___
  __) | / __|/ _` / __| / __|/ _` | |  / _` | `__| `__/ _` | | | / __|
 / __/  \__ \ (_| \__ \ \__ \ (_| | | | (_| | |  | | | (_| | |_| \__ \
|_____| |___/\__,_|___/ |___/\__, |_|  \__,_|_|  |_|  \__,_|\__, |___/
                                |_|                         |___/
*/

/*---- odd and eben arrays ----*/

%array(left,values=
  %utl_varlist(sd1.have,prx=/1$/));

%put &=left4; /*--- c4_1 ---*/
%put &=left5; /*--- c5_1 ---*/
%put &=leftn; /*--- 5    ---*/

%array(right,
 values=%utl_varlist(sd1.have,prx=/2$/));

%put &=right4; /*--- c4_2 ---*/
%put &=right5; /*--- c5_2 ---*/
%put &=rightn; /*--- 5    ---*/

proc sql;
  create
    table want as
  select
    %do_over(left right,phrase=%str(
       catx('|',?left,?right) as
         %nrstr(%substr(?left,1,2)))
      ,between=comma)
  from
    sd1.have
;quit;

%array(left,values=
  %utl_varlist(sd1.have,prx=/1$/));
%array(right, values=
  %utl_varlist(sd1.have,prx=/2$/));

To get the code highlight the sas code and type debug
on the command line, this will put the resolved code
in the log. Copy and paste. You may have to do
minor editing

MPRINT(DEBUGA):
    create
       table want as
    select
       catx('|,'C1_1,C1_2) as C1
      ,catx('|,'C2_1,C2_2) as C2
      ,catx('|,'C3_1,C3_2) as C3
      ,catx('|,'C4_1,C4_2) as C4
      ,catx('|,'C5_1,C5_2) as C5
    from
      sd1.have

proc sql;
   create
      table wantresolved as
   select
      catx('|',C1_1,C1_2) as C1
     ,catx('|',C2_1,C2_2) as C2
     ,catx('|',C3_1,C3_2) as C3
     ,catx('|',C4_1,C4_2) as C4
     ,catx('|',C5_1,C5_2) as C5
   from
     sd1.have
;quit;

/*____                    _
|___ /   _ __   ___  __ _| |
  |_ \  | `__| / __|/ _` | |
 ___) | | |    \__ \ (_| | |
|____/  |_|    |___/\__, |_|
                       |_|
*/

/*--- USE THE GENERATED CODE FROM SAS ---*/

proc datasets lib=sd1 nolist nodetails;
 delete rwant;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
library(dplyr)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
have[] <- lapply(have, as.character)
want<-sqldf("
   select
      C1_1||'|'||C1_2 as C1
     ,C2_1||'|'||C2_2 as C2
     ,C3_1||'|'||C3_2 as C3
     ,C4_1||'|'||C4_2 as C4
     ,C5_1||'|'||C5_2 as C5
   from
     have
   ")
print(want)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                          |                                                                                             */
/*   R                      |    SAS                                                                                      */
/*                          |                                                                                             */
/*    C1  C2  C3  C4  C5    |     C1     C2     C3     C4     C5                                                          */
/*                          |                                                                                             */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|0 0|0 0|0 0|0 0|1    |     0|0    0|0    0|0    0|0    0|1                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|1 0|1 0|1 1|1 1|1    |     0|1    0|1    0|1    1|1    1|1                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|1 0|1 0|1 0|0 0|0    |     0|1    0|1    0|1    0|0    0|0                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*   0|0 0|0 0|0 0|0 0|0    |     0|0    0|0    0|0    0|0    0|0                                                         */
/*                          |                                                                                             */
/**************************************************************************************************************************/

/*  _                 _   _                             _
| || |    _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
|__   _| | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
         |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
have = have.astype(int)
want=pdsql('''
   select
      C1_1||'|'||C1_2 as C1
     ,C2_1||'|'||C2_2 as C2
     ,C3_1||'|'||C3_2 as C3
     ,C4_1||'|'||C4_2 as C4
     ,C5_1||'|'||C5_2 as C5
   from
     have
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                             |                                                                                          */
/* PYTHON                      |   SAS                                                                                    */
/*                             |                                                                                          */
/*     C1   C2   C3   C4   C5  |   C1     C2     C3     C4     C5                                                         */
/*                             |                                                                                          */
/* 0  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 1  0|0  0|0  0|0  0|0  0|1  |   0|0    0|0    0|0    0|0    0|1                                                        */
/* 2  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 3  0|1  0|1  0|1  1|1  1|1  |   0|1    0|1    0|1    1|1    1|1                                                        */
/* 4  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 5  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 6  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 7  0|1  0|1  0|1  0|0  0|0  |   0|1    0|1    0|1    0|0    0|0                                                        */
/* 8  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/* 9  0|0  0|0  0|0  0|0  0|0  |   0|0    0|0    0|0    0|0    0|0                                                        */
/*                             |                                                                                          */
/**************************************************************************************************************************/

/*___    _
| ___|  | |__   __ _ ___  ___   _ __
|___ \  | `_ \ / _` / __|/ _ \ | `__|
 ___) | | |_) | (_| \__ \  __/ | |
|____/  |_.__/ \__,_|___/\___| |_|

*/
proc datasets lib=sd1 nolist nodetails;
 delete rrwant;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(dplyr)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
oddcols <- seq(1, ncol(have), by = 2)
want <- mapply(paste,
  have[oddcols], have[oddcols + 1], sep = "|")
colnames(want) <- sub("\\..*",""
 ,colnames(want))
print(want)
str(want)
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="rrwant"
     )
;;;;
%utl_rendx;

proc print data=sd1.rrwant;
run;quit;

/**************************************************************************************************************************/
/*                                      |                                                                                 */
/*  R                                   |                                                                                 */
/*                                      |                                                                                 */
/*       C1_1  C2_1  C3_1  C4_1  C5_1   |   C1_1    C2_1    C3_1    C4_1    C5_1                                          */
/*                                      |                                                                                 */
/*  [1,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*  [2,] "0|0" "0|0" "0|0" "0|0" "0|1"  |   0|0     0|0     0|0     0|0     0|1                                           */
/*  [3,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*  [4,] "0|1" "0|1" "0|1" "1|1" "1|1"  |   0|1     0|1     0|1     1|1     1|1                                           */
/*  [5,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*  [6,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*  [7,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*  [8,] "0|1" "0|1" "0|1" "0|0" "0|0"  |   0|1     0|1     0|1     0|0     0|0                                           */
/*  [9,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/* [10,] "0|0" "0|0" "0|0" "0|0" "0|0"  |   0|0     0|0     0|0     0|0     0|0                                           */
/*                                      |                                                                                 */
/*                                      |                                                                                 */
/*                                      |   #    Variable    Type    Len                                                  */
/*                                      |                                                                                 */
/*                                      |   1    C1_1        Char      3                                                  */
/*                                      |   2    C2_1        Char      3                                                  */
/*                                      |   3    C3_1        Char      3                                                  */
/*                                      |   4    C4_1        Char      3                                                  */
/*                                      |   5    C5_1        Char      3                                                  */
/*                                      |                                                                                 */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
