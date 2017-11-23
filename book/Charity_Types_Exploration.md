# Charity Types Exploration

## Introduction

## Methods

## Results - CRA Charity Designations, Categories and Types

Table. CRA Charity Totals

**year**|**total**
:-----:|:-----:
2012|85180
2013|84949
2014|84997
2015|84873
2016|74345
2017|3734

Table. CRA Charity Designations

**Year**|**Charitable organizations**|**Private foundations**|**Public foundations**
:-----:|:-----:|:-----:|:-----:
2012|74962|5133|5085
2013|74661|5213|5075
2014|74641|5296|5060
2015|74375|5464|5034
2016|65259|4642|4444
2017|3416|122|196

Table. CRA Charity Designations Year-Over-Year Change

**Year**|**Charitable organizations**|**Private foundations**|**Public foundations**
:-----:|:-----:|:-----:|:-----:
2012|NA|NA|NA
2013|-301|80|-10
2014|-20|83|-15
2015|-266|168|-26
2016|-9116|-822|-590
2017|-61843|-4520|-4248


![CRA Charity Codes Histogram](plots/Charity-category-codes-ordered.png)

Figure. CRA charity codes usage coloured by CRA charity type.


![CRA Charity Types Histogram](plots/Charity-types-histogram.png)

Figure. CRA charity types histogram.

Table. CRA Charity Types by Year

**Year**|**Community and Other**|**Education**|**Health**|**Religion**|**Welfare**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
2012|14028|13763|5771|33178|18440
2013|14025|13805|5801|32721|18597
2014|14010|13769|5777|32691|18750
2015|13983|13680|5751|32576|18883
2016|12333|12463|5178|27528|16843
2017|902|364|506|243|1719

## Results - CRA Financial Data

**Caveats**: this analysis was done pretty quickly so I started by using annual reported `Total Revenue` and `Total Expenses` values and excluded organizations with NAs values that appear when calculating their `Operating Budget` which in this case is `Total Revenue` minus `Total Expenses`. So I started with 418078 rows of data and was left with 389270 (93%).

Table. Largest total annual Operating Budgets.

**"Legal.Name"**|**"City"**|**"Province"**|**"year"**|**"Total.budget"**
:-----:|:-----:|:-----:|:-----:|:-----:
"Mastercard Foundation"|"TORONTO"|"ON"|2013|3420696082
"Mastercard Foundation"|"TORONTO"|"ON"|2012|1193461257
"Mastercard Foundation"|"TORONTO"|"ON"|2015|1158145016
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2015|1084923711
"VILLA DU REPOS INC."|"SHEDIAC"|"NB"|2013|932854989
"Jewish Community Foundation of Montreal / La Fondation Communautaire Juive de MontrÈal"|"MONTREAL"|"QC"|2016|802725827
"THE HALIFAX GRAMMAR SCHOOL"|"HALIFAX"|"NS"|2016|756188955
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2014|693268000
"Mastercard Foundation"|"TORONTO"|"ON"|2016|641181139
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2013|516649475
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2015|475645000
"Commission Scolaire Marie-Victorin"|"LONGUEUIL"|"QC"|2012|342432243
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2013|294682000
"Hamilton Health Sciences Research Institute"|"HAMILTON"|"ON"|2014|289706000
"VANCOUVER COASTAL HEALTH AUTHORITY"|"VANCOUVER"|"BC"|2016|277890000
"Fondation Marcelle et Jean Coutu"|"MONTREAL"|"QC"|2014|242580019
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2012|219004888
"Fondation Lucie et AndrÈ Chagnon"|"MONTREAL"|"QC"|2013|201529000
"THE CALGARY FOUNDATION"|"CALGARY"|"AB"|2013|179227583
"UNIVERSITY OF BRITISH COLUMBIA"|"VANCOUVER"|"BC"|2016|174574000

Table. Total annual revenue in Alberta.

**"Legal.Name"**|**"City"**|**"Province"**|**"year"**|**"Total.budget"**
:-----:|:-----:|:-----:|:-----:|:-----:
"Mastercard Foundation"|"TORONTO"|"ON"|2013|3420696082
"Mastercard Foundation"|"TORONTO"|"ON"|2012|1193461257
"Mastercard Foundation"|"TORONTO"|"ON"|2015|1158145016
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2015|1084923711
"VILLA DU REPOS INC."|"SHEDIAC"|"NB"|2013|932854989
"Jewish Community Foundation of Montreal / La Fondation Communautaire Juive de MontrÈal"|"MONTREAL"|"QC"|2016|802725827
"THE HALIFAX GRAMMAR SCHOOL"|"HALIFAX"|"NS"|2016|756188955
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2014|693268000
"Mastercard Foundation"|"TORONTO"|"ON"|2016|641181139
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2013|516649475
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2015|475645000
"Commission Scolaire Marie-Victorin"|"LONGUEUIL"|"QC"|2012|342432243
"THE GOVERNING COUNCIL OF THE UNIVERSITY OF TORONTO"|"TORONTO"|"ON"|2013|294682000
"Hamilton Health Sciences Research Institute"|"HAMILTON"|"ON"|2014|289706000
"VANCOUVER COASTAL HEALTH AUTHORITY"|"VANCOUVER"|"BC"|2016|277890000
"Fondation Marcelle et Jean Coutu"|"MONTREAL"|"QC"|2014|242580019
"THE AZRIELI FOUNDATION/LA FONDATION AZRIELI"|"MONTREAL"|"QC"|2012|219004888
"Fondation Lucie et AndrÈ Chagnon"|"MONTREAL"|"QC"|2013|201529000
"THE CALGARY FOUNDATION"|"CALGARY"|"AB"|2013|179227583
"UNIVERSITY OF BRITISH COLUMBIA"|"VANCOUVER"|"BC"|2016|174574000
