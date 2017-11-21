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

test <- all.charities[1:100,]

colnames(all.charities)[9:10] <- c("Designation.Code","Category.Code")
all.charities$FPE <- as.Date(all.charities$FPE)
all.charities$year <- year(all.charities$FPE)
all.charities.new <- left_join(all.charities,des.codes,by="Designation.Code")
all.charities.new <- left_join(all.charities.new,cat.codes,by="Category.Code")

#summary of charity designations
##linechart
charitydesignations.count <- all.charities.new %>%
  select(year, Designation) %>% 
  group_by(year,Designation) %>%
  tally() 

charitydesignation.line <- ggplot(charitydesignations.count,aes(x=year,y=n,group=Designation)) +
  geom_line(aes(linetype=Designation)) +
  geom_point()

##barchart
charitydesignations.count <- all.charities.new %>%
  select(year, Designation)

charitydesignation.bar <- ggplot(charitydesignations.count,aes(x=year)) + 
  geom_bar(aes(fill=Designation))

#summary of charity types
## linechart
charitytypes.count <- 
  all.charities.new %>%
  select(year, Charity.Type) %>%
  group_by(year,Charity.Type) %>%
  tally()

charitytypes.line <- ggplot(charitytypes.count,aes(x=year,y=n,group=Charity.Type)) +
  geom_line(aes(linetype=Charity.Type)) +
  geom_point()

##barchart
charitytypes.count <- 
  all.charities.new %>%
  select(year, Charity.Type)

charitytypes.bar <- ggplot(charitytypes.count,aes(x=year)) + 
  geom_bar(aes(fill=Charity.Type))

#Summary of Charity Category Codes
charitycategory.count <- 
  all.charities.new %>% 
  select(year, Category) %>%
  group_by(year, Category) %>%
  tally(sort=TRUE) %>%
  filter(year==2012) %>%
  top_n(10)


charitycategory.line <- ggplot(charitycategory.count,aes(x=year,y=n,group=Category)) +
  geom_line(aes(linetype=Category)) +
  geom_point()





  








