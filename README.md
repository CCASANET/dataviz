# Welcome to dAtaViZ #

**dAtaViZ** is a respository to share ongoing work building animated and interactive HIV cohort visualizations.

## Panel 1: Longitudinal/Time-to-Event Display ##

You can produce this plot with your HICDEP/CCASAnet compliant HIV cohort data.
A detailed video of the following instrutions can be viewed soon on [YouTube](http://youtube.com).


  Just download the R code, install R and RStudio, copy the .csv data files to `input/` folder, edit `input/panel1_specs.csv` to fit your project needs, open `code/panel1_code.R`, set the working directory to `dataviz` and source the code.  

### Editing panel1_specs.csv  
**INPUTS** include longitudinal, event, grouping, start time, and optional graphical parameters:
<table>
<thead>
<tr>
  <th>name</th>
  <th>specification</th>
  <th>example</th>
</tr>
</thead>
<tbody>
<tr>
  <td>longtablename </td>
  <td>character string of table name (same as CSV name during data load) </td>
  <td>lab_cd4</td>
</tr>
<tr>
  <td>longvar</td>
  <td>character string of longitudional variable name (must be present in table above)</td>
  <td>cd4_v</td>
</tr>
<tr>
  <td>longvardate </td>
  <td> character string of longitudional variable date name (must be present in table above)</td>
  <td>cd4_d</td>
</tr>
<tr>
  <td>longsubset (optional) </td>
  <td> function to be applied to subset data in longtablename (will currently be applied only to longvar; eg, function(x) x > 0) [default is no missing] </td>
  <td>function(x) x > 0 & !is.na(x) </td>
</tr>
<tr>
  <td>eventtablename </td>
  <td> character string of table name (same as CSV name during data load)</td>
  <td>follow</td>
</tr>
<tr>
  <td>event </td>
  <td> character string of event variable name (must be present in table above)</td>
  <td>death_y</td>
</tr>
<tr>
  <td>enddate </td>
  <td> character string of end date name (must be present in table above)</td>
  <td>l_alive_d</td>
</tr>
<tr>
  <td>grouptablename</td>
  <td> character string of table name (same as CSV name during data load)</td>
  <td>basic</td>
</tr>
<tr>
  <td>group </td>
  <td> character string of grouping variable name (must be present in table above)</td>
  <td>aids_preart_y</td>
</tr>
<tr>
  <td>groupsubset (optional) </td>
  <td> set of allowable vlues for groups [default is all unique groupings]</td>
  <td></td>
</tr>
<tr>
  <td>starttablename </td>
  <td> character string of table name (same as CSV name during data load)</td>
  <td>art</td>
</tr>
<tr>
  <td>startdate </td>
  <td> character string of start date name (must be present in table above)</td>
  <td>art_sd</td>
</tr>
<tr>
  <td>starttype (optional) </td>
  <td> character string of speficiation for identifying one start date if there are multiple per unique ID (options are "first" or "last") [default is "first"]</td>
  <td></td>
</tr>
<tr>
  <td>longvartrans (optional) </td>
  <td> character string of transformation for longvar (currently allow for "sqrt", "log", "log10") [default is identity function "I"]</td>
  <td>sqrt</td>
</tr>
<tr>
  <td>maxtime (optional) </td>
  <td> numeric maximum date for follow-up (start to end date) [default is 730 days]</td>
  <td>180</td>
</tr>
<tr>
  <td>long2eventwindow (optional) </td>
  <td> numeric allowable time to pass between longvar collection and event date in order for value to be attributed to event.  [default is 12 months]</td>
  <td></td>
</tr>
<tr>
  <td>longvarlim (optional) </td>
  <td> two numeric values for limit of longvar (y-axis pane 1) [default is .5th and 99.5th quantiles]</td>
  <td>c(0, 1500)</td>
</tr>
<tr>
  <td>problim (optional) </td>
  <td> two numeric values for limit of event rate (y-axis pane 2) [default is 0 and 1.4 times highest group rate]</td>
  <td></td>
</tr>
<tr>
  <td>longticks (optional)</td>
  <td> any length of numeric values to put tick marks and labels on longvar y-axis (original scale) [default is 5 points using pretty function]</td>
  <td>c(0, 25, 100, 150, 350, 500, 1000, 2000, 5000)</td>
</tr>
<tr>
  <td>longlabel (optional)</td>
  <td> label for y-axis of scatterplot [default is "Longitudinal Value"]</td>
  <td>Viral Load</td>
</tr>
<tr>
  <td>timelabel (optional)</td>
  <td> label for y-axis of scatterplot [default is "Days"]</td>
  <td>Days from Start</td>  
</tr>
<tr>
  <td>eventlabel (optional)</td>
  <td> label for y-axis of Kaplan-Meier plot [default is "Probability of Death"]</td>
  <td>Probability of Death</td>
</tr>
<tr>
  <td>grouplabels (optional)</td>
  <td> group label for plot legend.  must be a unique value of group variable, equal sign, label seperated by pipes. this is useful if the values of group are themselves not informative. [default is "Group" followed by unique value]</td>
  <td>0=No AIDS|1=AIDS|9=AIDS unknown</td>
</tbody>
</table>



## Panel 2: Animated Bubbleplot Display ##

You can produce this plot with your HICDEP/CCASAnet compliant HIV cohort data.
A detailed video of the following instrutions can be viewed soon on [YouTube](http://youtube.com).


  Just download the R code, install R and RStudio, copy the .csv data files to `input/` folder, edit `input/panel2_specs.csv` to fit your project needs, open `code/panel2_code.R`, set the working directory to `dataviz` and source the code.  

### Editing panel2_specs.csv  
**INPUTS** include two indicators, time, grouping, and optional graphical parameters:
<table>
<thead>
<tr>
  <th>name</th>
  <th>specification</th>
  <th>example</th>
</tr>
</thead>
<tbody>
<tr>
  <td>vartable</td>
  <td>character string of table name (same as CSV name during data load) </td>
  <td>basic</td>
</tr>
<tr>
  <td>var1</td>
  <td>R code that creates an indicator variable using variables in vartable</td>
  <td>basic$mode %in% c("Bisexual","Homosexual contact","Homo/Bisexual and Injecting drug user") & basic$male==1</td>
</tr>
<tr>
  <td>var2</td>
  <td>R code that creates an indicator variable using variables in vartable</td>
  <td>as.numeric(convertdate(baseline_d,basic) - convertdate(birth_d,basic))/365.25 < 25</td>
  </tr>
<tr>
  <td>vartablesubset (optional)</td>
  <td>R code that creates an indicator variable that will be used to subset the original vartable using variables in vartable</td>
  <td>format(convertdate(baseline_d,basic),"%Y") > 1998 & format(convertdate(baseline_d,basic),"%Y") < 2008 & !(basic$mode %in% c(90,"Unknown"))</td>
  </tr>
<tr>
  <td>eventdate</td>
  <td>Date corresponding to relevant data collection (eg, date of enrollment).</td>
  <td>baseline_d</td>
  </tr>
<tr>
  <td>eventperiod</td>
  <td>How to discretize time for the different frames of the bubbleplot. [default is year, allowable values are month, quarter, year, and missing]</td>
  <td>year</td>
  </tr>
<tr>
  <td>group</td>
  <td>Grouping variable in vartable for the different bubbles.</td>
  <td>site</td>
  </tr>
<tr>
  <td>var1label1 (optional)</td>
  <td>Label of group for which var1 is 1 or TRUE.</td>
  <td>MSM</td>
  </tr>
<tr>
  <td>var1label0 (optional)</td>
  <td>Label of group for which var1 is 0 or FALSE.</td>
  <td>non-MSM</td>
  </tr>
<tr>
  <td>var2label1 (optional)</td>
  <td>Label of group for which var2 is 1 or TRUE.</td>
  <td><25</td>
  </tr>
<tr>
  <td>var2label0 (optional)</td>
  <td>Label of group for which var2 is 0 or FALSE.</td>
  <td>25 or more</td>
  </tr>
<tr>
  <td>var1label (optional)</td>
  <td>Axis label for var1.</td>
  <td>Proportion MSM</td>
  </tr>
<tr>
  <td>var2label</td>
  <td>Axis label for var2.</td>
  <td>Proportion aged<25 at HIV diagnosis</td>
  </tr>
<tr>
  <td>minnum (optional)</td>
  <td>Set minimum number of observed units for a bubble to be drawn [default is 10].</td>
  <td>10</td>
</tbody>
</table>


### How robust is this code? ###

This code is intended for use with HICDEP/CCASAnet standard.  Because it is in development for a web-based system, there will be instances where the code fails if parameters are specified incorrectly. R is case sensitive and it is recommended to keep all data/input as lowercase.  Some data manipulation may be required prior to running the code.  As an example for panel1, lab_cd4 should be subset only to those records with cd4_u=1 (CD4 count only, excluding CD4 percentage).  We welcome feedback and suggestions for new graphical approaches.  
