#setwd("~/DS/dfg-text/scripts")

charities2017 <- read.csv("../data/raw/CRA-2017-NewOngoingPrograms.csv")
charities2016 <- read.csv("../data/raw/CRA-2016-NewOngoingPrograms.csv")
charities2015 <- read.csv("../data/raw/CRA-2015-NewOngoingPrograms.csv")
charities2014 <- read.csv("../data/raw/CRA-2014-NewOngoingPrograms.csv")
charities2013 <- read.csv("../data/raw/CRA-2013-NewOngoingPrograms.csv")
charities2012 <- read.csv("../data/raw/CRA-2012-NewOngoingPrograms.csv")

ident2017 <- read.csv("../data/raw/CRA-2017-Ident.csv")
ident2016 <- read.csv("../data/raw/CRA-2016-Ident.csv")
ident2015 <- read.csv("../data/raw/CRA-2015-Ident.csv")
ident2014 <- read.csv("../data/raw/CRA-2014-Ident.csv")
ident2013 <- read.csv("../data/raw/CRA-2013-Ident.csv")
ident2012 <- read.csv("../data/raw/CRA-2012-Ident.csv")

budget2017 <- read.csv("../data/raw/CRA-2017-Financial_D_and_Schedule_6.csv")
budget2016 <- read.csv("../data/raw/CRA-2016-Financial_D_and_Schedule_6.csv")
budget2015 <- read.csv("../data/raw/CRA-2015-Financial_D_and_Schedule_6.csv")
budget2014 <- read.csv("../data/raw/CRA-2014-Financial_D_and_Schedule_6.csv")
budget2013 <- read.csv("../data/raw/CRA-2013-Financial_D_and_Schedule_6.csv")
budget2012 <- read.csv("../data/raw/CRA-2012-Financial_D_and_Schedule_6.csv")

budget2017[2:3] <- NULL
colnames(budget2017)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2017)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")
budget2016[2:3] <- NULL
colnames(budget2016)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2016)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")
budget2015[2:3] <- NULL
colnames(budget2015)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2015)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")
budget2014[2:3] <- NULL
colnames(budget2014)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2014)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")
budget2013[2:3] <- NULL
colnames(budget2013)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2013)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")
budget2012[2:3] <- NULL
colnames(budget2012)[25:47] <- c("Receipted donations - 4500","X4505","Gifts from other charities - 4510","X4520","X4525","X4530","Government funding federal - 4540","Government funding provincial - 4550","Government funding municipal - 4560","X4565","4570","X4571","Other revenue - 4575","Other revenue - 4580","Other revenue - 4590","X4600","X4610","X4620","Other revenue - 4630","X4640","X4650","X4655","Total revenue - 4700")
colnames(budget2012)[64:72] <- c("Charitable program - 5000","Management and administration - 5010","Fundraising - 5020","Political activities - 5030","Other expenditures - 5040","Gifts to others - 5050","X5060","X5070","Total expenses - 5100")

charities2017_new <- merge(charities2017,ddply(charities2017,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2017_new <- charities2017_new[!duplicated(charities2017_new$BN),]
charities2017_new$Doc_number <- 1
charities2017_new <- merge(charities2017_new,ident2017,by="BN",all.x=TRUE)
charities2017_new <- merge(charities2017_new,budget2017,by="BN",all.x=TRUE)

charities2016_new <- merge(charities2016,ddply(charities2016,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2016_new <- charities2016_new[!duplicated(charities2016_new$BN),]
charities2016_new$Doc_number <- 2
charities2016_new <- merge(charities2016_new,ident2016,by="BN",all.x=TRUE)
charities2016_new <- merge(charities2016_new,budget2016,by="BN",all.x=TRUE)


charities2015_new <- merge(charities2015,ddply(charities2015,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2015_new <- charities2015_new[!duplicated(charities2015_new$BN),]
charities2015_new$Doc_number <- 3
charities2015_new <- merge(charities2015_new,ident2015,by="BN",all.x=TRUE)
charities2015_new <- merge(charities2015_new,budget2015,by="BN",all.x=TRUE)

charities2014_new <- merge(charities2014,ddply(charities2014,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2014_new <- charities2014_new[!duplicated(charities2014_new$BN),]
charities2014_new$Doc_number <- 4
charities2014_new <- merge(charities2014_new,ident2014,by="BN",all.x=TRUE)
charities2014_new <- merge(charities2014_new,budget2014,by="BN",all.x=TRUE)

charities2013_new <- merge(charities2013,ddply(charities2013,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2013_new <- charities2013_new[!duplicated(charities2013_new$BN),]
charities2013_new$Doc_number <- 5
charities2013_new <- merge(charities2013_new,ident2013,by="BN",all.x=TRUE)
charities2013_new <- merge(charities2013_new,budget2013,by="BN",all.x=TRUE)

charities2012_new <- merge(charities2012,ddply(charities2012,.(BN),summarise,Desc=paste0(ACTVT.DESC,collapse="; ")),by="BN")
charities2012_new <- charities2012_new[!duplicated(charities2012_new$BN),]
charities2012_new$Doc_number <- 6
charities2012_new <- merge(charities2012_new,ident2012,by="BN",all.x=TRUE)
charities2012_new <- merge(charities2012_new,budget2012,by="BN",all.x=TRUE)

charities_all_new <- rbind(charities2017_new,charities2016_new,charities2015_new,charities2014_new,charities2013_new,charities2012_new)
write.csv(charities_all_new, file = "../data/processed/All_charities_ident_financial.csv")
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


