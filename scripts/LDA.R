setwd("~/DS/dfg-text/scripts")

library(topicmodels)
library(SnowballC)
library(tm)
library(tidytext)
library(ggplot2)
library(magrittr)
library(dplyr)

#all_charities <- read.csv("../data/processed/All_charities_summary.csv")
#all_charities_by_year <- read.csv("../data/processed/All_charities_by_year.csv")

#calgary_charities <- read.csv("../data/processed/Calgary_charities_summary.csv")
#calgary_charities_by_year <- read.csv("../data/processed/Calgary_charities_by_year.csv")

edmonton_charities <- read.csv("../data/processed/Edmonton_charities_summary.csv")
#edmonton_successfull_charities <-  read.csv("../data/processed/Edmonton_successfull_charities_summary.csv")
#edmonton_successfull_charities$Category <- 1
#edmonton_unsuccessfull_charities <-  read.csv("../data/processed/Edmonton_unsuccessfull_charities_summary.csv")
#edmonton_unsuccessfull_charities$Category <- 0
#edmonton_successfull_charities_by_year <- read.csv("../data/processed/Edmonton_successfull_charities_by_year.csv")
#edmonton_unsuccessfull_charities_by_year <- read.csv("../data/processed/Edmonton_unsuccessfull_charities_by_year.csv")

#utf8_desc <- iconv(all_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(all_charities_by_year[all_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(all_charities_by_year[all_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")

#utf8_desc <- iconv(calgary_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(calgary_charities_by_year[calgary_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(calgary_charities_by_year[calgary_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")
#edmonton_charities <- rbind(edmonton_successfull_charities,edmonton_unsuccessfull_charities)
utf8_desc <- iconv(edmonton_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_unsuccessfull_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities_by_year[edmonton_successfull_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities_by_year[edmonton_successfull_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_unsuccessfull_charities_by_year[edmonton_unsuccessfull_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_unsuccessfull_charities_by_year[edmonton_unsuccessfull_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")

utf8_desc <- utf8_desc[!is.na(utf8_desc)]
utf8_desc <- utf8_desc[!utf8_desc==""]

docs <- Corpus(VectorSource(utf8_desc))
docs <- tm_map(docs, removePunctuation) 
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, stopwords("french"))
docs <- tm_map(docs, removeWords, c("program","programs","services","service","provide", "community","support","calgary","alberta","canadian","canada","edmonton"))
#docs <- tm_map(docs, stemDocument) 
dtm <- DocumentTermMatrix(docs) 

ui = unique(dtm$i)
dtm.new = dtm[ui,]

################################## additional steps to find out optimal topic number http://davidmeza1.github.io/2015/07/20/topic-modeling-in-R.html
library(Rmpfr)
term_tfidf <- tapply(dtm$v/slam::row_sums(dtm)[dtm$i], dtm$j, mean) *log2(tm::nDocs(dtm)/slam::col_sums(dtm > 0))
summary(term_tfidf)

llisreduced.dtm <- dtm[,term_tfidf >= 0.1857]
summary(slam::col_sums(llisreduced.dtm))

harmonicMean <- function(logLikelihoods, precision = 2000L) {
  llMed <- median(logLikelihoods)
  as.double(llMed - log(mean(exp(-mpfr(logLikelihoods,
                                       prec = precision) + llMed))))
}

seqk <- seq(2, 100, 1)
burnin <- 1000
iter <- 1000
keep <- 50

system.time(fitted_many <- lapply(seqk, function(k) topicmodels::LDA(llisreduced.dtm, k = k,
                                                                     method = "Gibbs",control = list(burnin = burnin,
                                                                                                     iter = iter, keep = keep) )))
logLiks_many <- lapply(fitted_many, function(L)  L@logLiks[-c(1:(burnin/keep))])
hm_many <- sapply(logLiks_many, function(h) harmonicMean(h))
optimal_topic_number <-  seqk[which.max(hm_many)]  #- optimal topics number

system.time(llis.model <- topicmodels::LDA(llisreduced.dtm, optimal_topic_number, method = "Gibbs", control = list(iter=2000, seed = 0622)))

#Create labels for topics  - join 3 most common words

llis.topics <- topicmodels::topics(llis.model, 1)
llis.terms <- as.data.frame(topicmodels::terms(llis.model, 30), stringsAsFactors = FALSE)
topicTerms <- tidyr::gather(llis.terms, Topic)
topicTerms <- cbind(topicTerms, Rank = rep(1:30))
topTerms <- dplyr::filter(topicTerms, Rank < 4)
topTerms <- dplyr::mutate(topTerms, Topic = stringr::word(Topic, 2))
topTerms$Topic <- as.numeric(topTerms$Topic)
topicLabel <- data.frame()
  for (i in 1:optimal_topic_number){
    z <- dplyr::filter(topTerms, Topic == i)
    l <- as.data.frame(paste(z[1,2], z[2,2], z[3,2], sep = " " ), stringsAsFactors = FALSE)
    topicLabel <- rbind(topicLabel, l)
    
  }
colnames(topicLabel) <- c("Label")
topicLabel

###Correlation 

theta <- as.data.frame(topicmodels::posterior(llis.model)$topics)
head(theta[1:5])
  
  
x <- as.data.frame(row.names(theta), stringsAsFactors = FALSE)
colnames(x) <- c("Key")
x$Key <- as.numeric(x$Key)
theta2 <- cbind(x, theta)
edmonton_charities$Key <- row.names(edmonton_charities)
edmonton_charities$Key<- as.numeric(edmonton_charities$Key)
theta2 <- dplyr::left_join(theta2, edmonton_charities, by = "Key")
## Returns column means grouped by catergory
theta.mean.by <- by(theta2[, 2:optimal_topic_number+1], theta2$Category, colMeans)
theta.mean <- do.call("rbind", theta.mean.by)
library(corrplot)
c <- cor(theta.mean)
corrplot(c, method = "circle")
  
theta.mean.ratios <- theta.mean
for (ii in 1:nrow(theta.mean)) {
    for (jj in 1:ncol(theta.mean)) {
      theta.mean.ratios[ii,jj] <-
        theta.mean[ii,jj] / sum(theta.mean[ii,-jj])
    }
}
  
topics.by.ratio <- apply(theta.mean.ratios, 1, function(x) sort(x, decreasing = TRUE, index.return = TRUE)$ix)
  
topics.most.diagnostic <- topics.by.ratio[1,]
head(topics.most.diagnostic)

##############################################

#dtm_lda <- LDA(dtm.new, k = 18, control = list(seed = 1234))

#dtm_topics <- tidy(dtm_lda, matrix = "beta")

dtm_topics <- tidy(llis.model, matrix = "beta")

dtm_top_terms <- dtm_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

dtm_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

