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

#edmonton_charities <- read.csv("../data/processed/Edmonton_charities_summary.csv")
#edmonton_successfull_charities <-  read.csv("../data/processed/Edmonton_successfull_charities_summary.csv")
#edmonton_unsuccessfull_charities <-  read.csv("../data/processed/Edmonton_unsuccessfull_charities_summary.csv")
#edmonton_successfull_charities_by_year <- read.csv("../data/processed/Edmonton_successfull_charities_by_year.csv")
edmonton_unsuccessfull_charities_by_year <- read.csv("../data/processed/Edmonton_unsuccessfull_charities_by_year.csv")

#utf8_desc <- iconv(all_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(all_charities_by_year[all_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(all_charities_by_year[all_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")

#utf8_desc <- iconv(calgary_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(calgary_charities_by_year[calgary_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(calgary_charities_by_year[calgary_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")

#utf8_desc <- iconv(edmonton_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_unsuccessfull_charities$Desc, "LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities_by_year[edmonton_successfull_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
#utf8_desc <- iconv(edmonton_successfull_charities_by_year[edmonton_successfull_charities_by_year$Year==2016,]$Desc,"LATIN2", "UTF-8")
utf8_desc <- iconv(edmonton_unsuccessfull_charities_by_year[edmonton_unsuccessfull_charities_by_year$Year==2012,]$Desc,"LATIN2", "UTF-8")
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

#rowTotals <- apply(dtm , 1, sum)
#dtm.new   <- dtm[rowTotals> 0, ]

ui = unique(dtm$i)
dtm.new = dtm[ui,]

dtm_lda <- LDA(dtm.new, k = 10, control = list(seed = 1234))
dtm_topics <- tidy(dtm_lda, matrix = "beta")

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

