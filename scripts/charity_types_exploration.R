library(rstudioapi)

setwd.within.project <- function() {
  if(rstudioapi::isAvailable()) {
    script.path <- rstudioapi::getSourceEditorContext()$path
  } else {
    script.path <- commandArgs() %>% keep(~ str_detect(.x, "--file=")) %>% str_replace("--file=","")
  }
  
  setwd(dirname(script.path))
}

setwd.within.project()
library(tidyverse)
library(lubridate)
library(tidytext)
library(cowplot)
library(plotly)

all.charities <- read.csv("../data/processed/All_charities_ident_financial.csv")
cat.codes <- read.csv("../data/raw/CRA-charity_category_codes.csv")
des.codes <- read.csv("../data/raw/CRA-charity_designation_codes.csv")
ckc.descriptions <- read.csv("../data/raw/ckc_calgary_mega_export.csv")

test <- all.charities[1:100,]

colnames(all.charities)[9:10] <- c("Designation.Code","Category.Code")
all.charities$FPE <- as.Date(all.charities$FPE)
all.charities$year <- year(all.charities$FPE)
all.charities.new <- left_join(all.charities,des.codes,by="Designation.Code")
all.charities.new <- left_join(all.charities.new,cat.codes,by="Category.Code")

#summary of charity counts and designations
charitycount.table <- all.charities.new %>%
  select(year) %>% 
  group_by(year) %>%
  tally()
charitycount.table <- data.frame(charitycount.table)
colnames(charitycount.table)[2] <- "total"

charitydesignations.table <- all.charities.new %>%
  select(year, Designation) %>% 
  group_by(year,Designation) %>%
  tally()
charitydesignations.table <- data.frame(charitydesignations.table)
colnames(charitydesignations.table)[3] <- "Total"
charitydesignations.spread <- spread(charitydesignations.table,Designation,Total)
write.csv(charitydesignations.spread,file="../data/processed/charitydesignations-spread.csv",row.names = FALSE)
##year over year change
charitydesignations.yoy <- ddply(charitydesignations.table,.(Designation),mutate,yoy_delta=c("NA",diff(Total)))

charitydesignations.yoy.spread <- charitydesignations.yoy %>%
  select(year,Designation,yoy_delta) %>%
  spread(Designation,yoy_delta)
write.csv(charitydesignations.yoy.spread,file="../data/processed/charitydesignations-yoy-spread.csv",row.names=FALSE)

##linechart
charitydesignation.line <- ggplot(charitydesignations.table,aes(x=year,y=Total,group=Designation)) +
  geom_line(aes(linetype=Designation)) +
  geom_point()

##barchart
charitydesignations.table <- all.charities.new %>%
  select(year, Designation)

charitydesignation.bar <- ggplot(charitydesignations.table,aes(x=year)) + 
  geom_bar(aes(fill=Designation))

#Summary of Charity Category Codes
charitycategorycodes.table <- 
  all.charities.new %>% 
  select(Category, Category.Code, Charity.Type) %>%
  group_by(Category.Code,Category, Charity.Type) %>%
  tally() %>%
  arrange(desc(n))

charitycategorycodes.table <- data.frame(charitycategorycodes.table)
charitycategorycodes.table$Category.Code.ordered <- factor(charitycategorycodes.table$Category.Code,levels=charitycategorycodes.table$Category.Code)
charitycategorycodes.plot <- ggplot(charitycategorycodes.table,aes(x=Category.Code.ordered,y=n,fill=Charity.Type)) + 
  geom_bar(stat="identity") + 
  theme(axis.text.x = element_text(size  = 7, angle = 45,hjust=1)) + 
  xlab("Charity Category Code") + ylab("Count")
ggplotly(charitycategorycodes.plot)


#Summary of charity types

target.years <- c("2014","2015")

charitytypes.spread <- 
  all.charities.new %>%
  select(year, Charity.Type) %>%
  group_by(year,Charity.Type) %>%
  tally() %>%
  spread(Charity.Type,n)
write.csv(charitytypes.spread,file="../data/processed/charitytypes-spread.csv",row.names = FALSE)

charitytypes.table <- 
  all.charities.new %>% 
  select(year, Charity.Type) %>%
  group_by(year, Charity.Type) %>%
  tally()

charitytypes.plot <- ggplot(charitytypes.table,aes(x=year,y=n,fill=Charity.Type)) + 
  geom_bar(stat="identity") + 
  xlab("Charity Type") + ylab("Count")
ggplotly(charitytypes.plot)

##What's with the increase in Private Foundations?
privatefoundations.table <- all.charities.new %>%
  select(year, Charity.Type,Designation) %>%
  filter(year==target.years) %>%
  filter(Designation=="Private foundations") %>%
  group_by(year,Charity.Type) %>%
  tally() %>%
  spread(Charity.Type,n)
write.csv(privatefoundations.table,file="../data/processed/privatefoundation20142015-spread.csv",row.names = FALSE)


#Summary of Revenue and Expenses by Charity Type
charitybudgets.table <-all.charities.new %>% 
  select(year,Total.revenue...4700, Total.expenses...5100, Charity.Type, BN, Legal.Name,City,Province)
charitybudgets.table$Total.revenue...4700 <- as.numeric(gsub("$", "", charitybudgets.table$Total.revenue...4700,fixed=TRUE))
charitybudgets.table$Total.expenses...5100 <- as.numeric(gsub("$", "", charitybudgets.table$Total.expenses...5100,fixed=TRUE))

charitybudgets.table.new <- charitybudgets.table %>%
  mutate(Net.budget=Total.revenue...4700-Total.expenses...5100) %>%
  filter(!is.na(Net.budget)) 

netbudget.ordered <- charitybudgets.table.new %>% 
  select(Legal.Name,City,Province,year,Net.budget) %>% 
  arrange(desc(Net.budget)) %>%
  top_n(20,Net.budget)
write.csv(totalbudget.ordered,file="../data/processed/charitynetbudget-top20.csv",row.names = FALSE)

totalrevenue.ordered <- charitybudgets.table.new %>% 
  select(Legal.Name,City,Province,year,Total.revenue...4700) %>% 
  arrange(desc(Total.revenue...4700)) %>%
  filter(Province=="AB") %>%
  top_n(20,Total.revenue...4700)
write.csv(totalrevenue.ordered,file="../data/processed/charitytotalrevenue-ABtop20.csv",row.names = FALSE)

#totalexpenses.ordered <- charitybudgets.table.new %>% 
#  select(Legal.Name,City,Province,year,Total.expenses...5100) %>% 
#  arrange(desc(Total.expenses...5100)) %>%
#  filter(Province=="AB") %>%
#  top_n(20,Total.expenses...5100)

##scatter plot of charities and budget
charitynetbudget.scatter <- ggplot(charitybudgets.table.new, aes(x=year,y=Net.budget)) + 
  geom_point(aes(colour=Charity.Type)) + 
  xlab("Year") +
  ylab("Net Budget ($)")

charitynetbudgetAB.scatter <- charitybudgets.table.new %>%
  filter(Province=="AB") %>%
  ggplot(aes(x=year,y=Net.budget)) + 
  geom_point(aes(colour=Charity.Type)) + 
  xlab("Year") +
  ylab("Net Budget ($)")

charitynetbudgetAB.scatter <- charitybudgets.table.new %>%
  filter(Province=="AB") %>%
  ggplot(aes(x=year,y=Net.budget)) + 
  geom_boxplot(aes(colour=Charity.Type))
  

## how many categories/bins?




