library(rstudioapi)
library(stringr)
library(purrr)
library(dplyr)
library(tidytext)
library(ggplot2)

setwd.within.project <- function() {
  if(rstudioapi::isAvailable()) {
    script.path <- rstudioapi::getSourceEditorContext()$path
  } else {
    script.path <- commandArgs() %>% keep(~ str_detect(.x, "--file=")) %>% str_replace("--file=","")
  }

  setwd(dirname(script.path))
}

setwd.within.project()

library(here)

make.words.df <- function(year) {
  fname.identity = paste0("CRA-",year,"-Ident.csv")
  fname.programs = paste0("CRA-",year,"-NewOngoingPrograms.csv")

  cra.identity <- read.csv(here("data","raw",fname.identity))
  cra.programs <- read.csv(here("data","raw",fname.programs))
  
  cra.joined <- cra.programs %>% 
    left_join(cra.identity, by="BN") %>%
    filter(Province %in% c("AB","BC","MB","NB","NL","NS","NT",
                           "NU","ON","PE","QC","SK","YT"))

  cra.words <- cra.joined %>%
    rename(Name = Legal.Name, Description = ACTVT.DESC) %>%
    mutate(Description = as.character(Description)) %>%
    select(Province, Name, Description) %>%
    unnest_tokens(Word, Description) %>%
    mutate(Word = wordStem(Word)) %>%
    count(Province, Name, Word, sort = TRUE) %>%
    ungroup() %>%
    anti_join(stop_words, by=c("Word" = "word"))
}

make.tf_idf.byprovince <- function(words.df) {
  words.df %>%
    group_by(Province, Word) %>%
    summarise(n = sum(n)) %>%
    bind_tf_idf(Word, Province, n) %>%
    arrange(desc(tf_idf)) %>%
    group_by(Province) %>% 
    ungroup() %>%
    mutate(Word = reorder(Word, tf_idf))
}

make.tf_idf.byorg <- function(words.df) {
  words.df %>%
    group_by(Province, Name, Word) %>%
    summarise(n = sum(n)) %>%
    bind_tf_idf(Word, Name, n) %>%
    arrange(desc(tf_idf)) %>%
    mutate(Word = reorder(Word, tf_idf))
}

plot.provinces <- function(tf_idf.df,year="") {
  tf_idf.df %>%
    group_by(Province) %>%
    top_n(15) %>%
    ungroup() %>%
    ggplot(aes(reorder(Word,tf_idf), tf_idf, fill = Province)) +
      geom_col(show.legend = FALSE) +
      labs(x = NULL, y = "tf-idf") +
      facet_wrap(~Province, ncol = 3, scales = "free") +
      ggtitle(paste0("Tf-idf by Province: ",year)) +
      coord_flip()
}

plot.save <- function(name,plot) {
  fname.plot <- paste0(name,".png")
  ggsave(here("results","plots",fname.plot), plot, 
         width = 9, height = 12)
}

cra.2012.words <- make.words.df(2012)
cra.2012.words.byprovince <- make.tf_idf.byprovince(cra.2012.words)
cra.2012.words.byorg <- make.tf_idf.byorg(cra.2012.words)
plot.2012 <- plot.provinces(cra.2012.words.byorg, 2012)
plot.save("tf-idf-provinces-2012", plot.2012)

cra.2013.words <- make.words.df(2013)
cra.2013.words.byprovince <- make.tf_idf.byprovince(cra.2013.words)
cra.2013.words.byorg <- make.tf_idf.byorg(cra.2013.words)
plot.2013 <- plot.provinces(cra.2013.words.byorg, 2013)
plot.save("tf-idf-provinces-2013", plot.2013)

cra.2014.words <- make.words.df(2014)
cra.2014.words.byprovince <- make.tf_idf.byprovince(cra.2014.words)
cra.2014.words.byorg <- make.tf_idf.byorg(cra.2014.words)
plot.2014 <- plot.provinces(cra.2014.words.byorg, 2014)
plot.save("tf-idf-provinces-2014", plot.2014)

cra.2015.words <- make.words.df(2015)
cra.2015.words.byprovince <- make.tf_idf.byprovince(cra.2015.words)
cra.2015.words.byorg <- make.tf_idf.byorg(cra.2015.words)
plot.2015 <- plot.provinces(cra.2015.words.byorg, 2015)
plot.save("tf-idf-provinces-2015", plot.2015)

cra.2016.words <- make.words.df(2016)
cra.2016.words.byprovince <- make.tf_idf.byprovince(cra.2016.words)
cra.2016.words.byorg <- make.tf_idf.byorg(cra.2016.words)
plot.2016 <- plot.provinces(cra.2016.words.byorg, 2016)
plot.save("tf-idf-provinces-2016", plot.2016)

cra.2017.words <- make.words.df(2017)
cra.2017.words.byprovince <- make.tf_idf.byprovince(cra.2017.words)
cra.2017.words.byorg <- make.tf_idf.byorg(cra.2017.words)
plot.2017 <- plot.provinces(cra.2017.words.byorg, 2017)
plot.save("tf-idf-provinces-2017", plot.2017)
