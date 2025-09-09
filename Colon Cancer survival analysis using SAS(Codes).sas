/* ------------------------
   Colon Cancer Analysis
   Cleaned & fixed version
   ------------------------ */

options nonotes nostimer nosource nosyntaxcheck;

/* 1) Import CSV */
proc import datafile="/home/u64140878/colon.csv"
    out=colon_raw
    dbms=csv
    replace;
    getnames=yes;
    guessingrows=max;
run;

/* 2) Clean 'NA' and convert variables */
data colon_clean;
    set colon_raw;

    /* Clean character variables */
    array cvars _character_;
    do over cvars;
        if strip(cvars) = "NA" then cvars = "";
    end;

    /* Create numeric versions */
    nodes_num  = input(nodes, best12.);
    time_num   = input(time, best12.);
    status_num = input(status, best12.);
run;

/* 3) Subset for death events (etype=2) */
data colondeath;
    set colon_clean;
    where etype = 2;
run;

/* 4) Quick frequency checks */
proc freq data=colondeath;
    tables rx status etype;
run;

/* 5) Descriptive stats */
proc means data=colondeath n mean std min max;
    var age nodes_num time_num;
run;

/* 6) Baseline table by treatment */
proc tabulate data=colondeath format=6.2;
    class rx;
    var age nodes_num;
    table rx='Treatment',
          (N='N'*f=8.
           age='Age'*(mean='Mean' std='StdDev')
           nodes_num='Nodes'*(mean='Mean' std='StdDev'));
    title "Table 1: Baseline demographics by treatment (etype=2)";
run;

/* 7) Kaplan-Meier by treatment */
ods graphics on / imagename="KM_by_rx" height=5in width=7in;
proc lifetest data=colondeath plots=(survival(cl atrisk)) notable;
    time time_num*status_num(0);
    strata rx / test=logrank;
run;
ods graphics off;

/* 8) Cox proportional hazards model */
ods graphics on / imagename="PHREG_forest" height=4in width=6in;
proc phreg data=colondeath plots(overlay)=survival;
    class rx (ref="Obs") sex (ref="0") / param=ref;
    model time_num*status_num(0) = rx age sex nodes_num;
    hazardratio 'Treatment HRs' rx / cl=both;
    ods output HazardRatios=HRs ParameterEstimates=PEst;
run;
ods graphics off;

/* 9) Format hazard ratio table for forest plot */
data HRs_fmt;
    set HRs;
    length Covariate $30;

    if Description = "rx Lev vs Obs" then Covariate = "Lev vs Obs";
    else if Description = "rx Lev+5FU vs Obs" then Covariate = "Lev+5FU vs Obs";
    else if Description = "rx Lev vs Lev+5FU" then Covariate = "Lev vs Lev+5FU";
    else Covariate = Description;

    HRLowerCL = WaldLower;
    HRUpperCL = WaldUpper;
run;

/* 10) Forest plot */
proc sgplot data=HRs_fmt noautolegend;
    scatter y=Covariate x=HazardRatio /
            xerrorlower=HRLowerCL
            xerrorupper=HRUpperCL
            markerattrs=(symbol=diamondfilled size=10 color=blue);
    refline 1 / axis=x lineattrs=(pattern=shortdash);
    xaxis type=log label="Hazard Ratio (95% CI)";
    yaxis discreteorder=data label="Covariates";
    title "Forest Plot of Hazard Ratios (Wald CI)";
run;

/* 11) Cox model with interaction */
proc phreg data=colondeath;
    class rx (ref="Obs") sex (ref="0") / param=ref;
    model time_num*status_num(0) = rx nodes_num rx*nodes_num age sex;
    title "Cox model with interaction rx*nodes";
run;

/* 12) Stratified KM by median nodes */
proc univariate data=colondeath noprint;
    var nodes_num;
    output out=median_nodes pctlpts=50 pctlpre=med_;
run;

data _null_;
    set median_nodes;
    call symputx('med_nodes', med_nodes_num50);
run;

data colondeath2;
    set colondeath;
    if nodes_num <= &med_nodes then node_group = "Low Nodes";
    else node_group = "High Nodes";
run;

ods graphics on / imagename="KM_node_rx" height=5in width=7in;
proc lifetest data=colondeath2 plots=(survival(cl atrisk));
    time time_num*status_num(0);
    strata node_group rx;
run;
ods graphics off;

/* 13) Close ODS HTML */
ods html close;

