#setwd("~/DS/dfg-text/scripts")

charities2017 <- read.csv("../data/raw/CRA-2017-NewOngoingPrograms.csv")
charities2016 <- read.csv("../data/raw/CRA-2016-NewOngoingPrograms.csv")
charities2015 <- read.csv("../data/raw/CRA-2015-NewOngoingPrograms.csv")
charities2014 <- read.csv("../data/raw/CRA-2014-NewOngoingPrograms.csv")
charities2013 <- read.csv("../data/raw/CRA-2013-NewOngoingPrograms.csv")
charities2012 <- read.csv("../data/raw/CRA-2012-NewOngoingPrograms.csv")


charities2017_new <- merge(charities2017,ddply(charities2017,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2017_new <- charities2017_new[!duplicated(charities2017_new$BN),]
charities2017_new$Doc_number <- 1

charities2016_new <- merge(charities2016,ddply(charities2016,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2016_new <- charities2016_new[!duplicated(charities2016_new$BN),]
charities2016_new$Doc_number <- 2

charities2015_new <- merge(charities2015,ddply(charities2015,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2015_new <- charities2015_new[!duplicated(charities2015_new$BN),]
charities2015_new$Doc_number <- 3

charities2014_new <- merge(charities2014,ddply(charities2014,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2014_new <- charities2014_new[!duplicated(charities2014_new$BN),]
charities2014_new$Doc_number <- 4

charities2013_new <- merge(charities2013,ddply(charities2013,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2013_new <- charities2013_new[!duplicated(charities2013_new$BN),]
charities2013_new$Doc_number <- 5

charities2012_new <- merge(charities2012,ddply(charities2012,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2012_new <- charities2012_new[!duplicated(charities2012_new$BN),]
charities2012_new$Doc_number <- 6

charities_all_new <- rbind(charities2017_new,charities2016_new,charities2015_new,charities2014_new,charities2013_new,charities2012_new)
charities_all_new <- charities_all_new[order(charities_all_new[,'BN'],charities_all_new[,'Doc_number']),]
charities_all_new <- charities_all_new[!duplicated(charities_all_new$BN),]
charities_all_new <- charities_all_new[,c("BN","Desc","Doc_number")]
rownames(charities_all_new) <- NULL
write.csv(charities_all_new, file = "../data/processed/All_charities.csv")


calgary_grants <- read.csv("../data/raw/TCF_DataExtract_2012-17.csv")  

calgary_charity_numbers <- as.data.frame(table(calgary_grants$Charity.Number))
calgary_charity_numbers <- calgary_charity_numbers[order(-calgary_charity_numbers$Freq), ]
colnames(calgary_charity_numbers)  <- c("BN","#grants")


calgary_charity_numbers$Desc <- charities_all_new$Desc[match(calgary_charity_numbers$BN,charities_all_new$BN)]
rownames(calgary_charity_numbers) <- NULL
write.csv(calgary_charity_numbers, file = "../data/processed/Calgary_charities.csv")


