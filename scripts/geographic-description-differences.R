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
  
  cra.joined <- cra.programs %>% left_join(cra.identity, by="BN")
  
  cra.words <- cra.joined %>%
    rename(Name = Legal.Name, Description = ACTVT.DESC) %>%
    mutate(Description = as.character(Description)) %>%
    select(Province, Name, Description) %>%
    unnest_tokens(Word, Description) %>%
    count(Province, Name, Word, sort = TRUE) %>%
    ungroup()
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
    mutate(Word = factor(Word, levels = rev(unique(Word))))
}

plot.provinces <- function(tf_idf.df,year="") {
  tf_idf.df %>%
    group_by(Province) %>%
    filter(Province %in% c("AB","BC","MB","NB","NL","NS","NT",
                           "NU","ON","PE","QC","SK","YT")) %>%
    top_n(15) %>%
    ungroup() %>%
    ggplot(aes(reorder(Word,tf_idf), tf_idf, fill = Province)) +
      geom_col(show.legend = FALSE) +
      labs(x = NULL, y = "tf-idf") +
      facet_wrap(~Province, ncol = 3, scales = "free") +
      ggtitle(paste0("Tf-idf by Province: ",year)) +
      coord_flip()
}

cra.2012.words <- make.words.df(2012)
cra.2012.words.byprovince <- make.tf_idf.byprovince(cra.2012.words)
cra.2012.words.byorg <- make.tf_idf.byorg(cra.2012.words)
plot.provinces(cra.2012.words.byprovince, 2012)

cra.2013.words <- make.words.df(2013)
cra.2013.words.byprovince <- make.tf_idf.byprovince(cra.2013.words)
cra.2013.words.byorg <- make.tf_idf.byorg(cra.2013.words)
plot.provinces(cra.2013.words.byprovince, 2013)

cra.2014.words <- make.words.df(2014)
cra.2014.words.byprovince <- make.tf_idf.byprovince(cra.2014.words)
cra.2014.words.byorg <- make.tf_idf.byorg(cra.2014.words)
plot.provinces(cra.2014.words.byprovince, 2014)

cra.2015.words <- make.words.df(2015)
cra.2015.words.byprovince <- make.tf_idf.byprovince(cra.2015.words)
cra.2015.words.byorg <- make.tf_idf.byorg(cra.2015.words)
plot.provinces(cra.2015.words.byprovince, 2015)

cra.2016.words <- make.words.df(2016)
cra.2016.words.byprovince <- make.tf_idf.byprovince(cra.2016.words)
cra.2016.words.byorg <- make.tf_idf.byorg(cra.2016.words)
plot.provinces(cra.2016.words.byprovince, 2016)

cra.2017.words <- make.words.df(2017)
cra.2017.words.byprovince <- make.tf_idf.byprovince(cra.2017.words)
cra.2017.words.byorg <- make.tf_idf.byorg(cra.2017.words)
plot.provinces(cra.2017.words.byprovince, 2017)
