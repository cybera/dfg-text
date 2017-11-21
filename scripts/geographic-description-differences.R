library(rstudioapi)
library(stringr)
library(purrr)
library(dplyr)
library(tidytext)
library(SnowballC)
library(tm)
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

# Words that are either too long or otherwise nonsensical
ignore.words <- data.frame(word = c("providingsundaychristianworshipservic",
                                    "organizeorchestraperform",
                                    "www.centrejeunessedelaval.ca",
                                    "yukonbirds.ca",
                                    "csms.ca",
                                    "studycounselingmiss",
                                    "conferencesteachingb",
                                    "2013", "187", "31,2015", "50", "42",
                                    "a2", "f2", "c2", "c1", "n.", "e2", "e1",
                                    "nil", "projects:oper"))

stop_words.fr <- data.frame(word = stopwords(kind = "fr"))

# Create a list of all unique words in the program descriptions, for use when
# doing stem completion.
word.corpus <- function() {
  corpus.df = data_frame()
  for(year in 2012:2017) {
    fname.programs = paste0("CRA-",year,"-NewOngoingPrograms.csv")
    cra.programs <- read.csv(here("data","raw",fname.programs))
    words.df <- cra.programs %>% 
      rename(Description = ACTVT.DESC) %>%
      mutate(Description = as.character(Description)) %>%
      unnest_tokens(Word, Description) %>%
      select(Word)
    corpus.df <- bind_rows(corpus.df, words.df)
  }
  tmp.words <- unique(corpus.df$Word)
  tmp.words[!is.na(tmp.words)]
}

words.unstemmed <- word.corpus()

make.words.df <- function(year) {
  fname.identity = paste0("CRA-",year,"-Ident.csv")
  fname.programs = paste0("CRA-",year,"-NewOngoingPrograms.csv")

  cra.identity <- read.csv(here("data","raw",fname.identity))
  cra.programs <- read.csv(here("data","raw",fname.programs))
  
  cra.joined <- cra.programs %>% 
    left_join(cra.identity, by="BN") %>%
    # We seem to have states also being included here. Restrict to just
    # provinces and territories.
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
    anti_join(stop_words, by=c("Word" = "word")) %>%
    anti_join(stop_words.fr, by=c("Word" = "word")) %>%
    anti_join(ignore.words, by=c("Word" = "word"))
}

make.tf_idf.byprovince <- function(words.df) {
  words.df %>%
    group_by(Province, Word) %>%
    summarise(n = sum(n)) %>%
    bind_tf_idf(Word, Province, n) %>%
    arrange(desc(tf_idf)) %>%
    group_by(Province) %>% 
    mutate(Word = reorder(Word, tf_idf)) %>%
    ungroup()
}

make.tf_idf.byorg <- function(words.df) {
  words.df %>%
    group_by(Province, Name, Word) %>%
    summarise(n = sum(n)) %>%
    bind_tf_idf(Word, Name, n) %>%
    arrange(desc(tf_idf))  %>%
    group_by(Province) %>% 
    mutate(Word = reorder(Word, tf_idf)) %>%
    ungroup()
}

plot.provinces <- function(tf_idf.df,year="",doc.type="Province", max.words=15) {
  plot.df <- tf_idf.df %>%
    group_by(Province, Word) %>%
    summarise(tf_idf = max(tf_idf)) %>%
    group_by(Province) %>%
    top_n(max.words) %>%
    ungroup() %>%
    arrange(Province, tf_idf) %>%
    # Trick to properly order bars by tf_idf when faceting
    # See: https://www.r-bloggers.com/ordering-categories-within-ggplot2-facets/
    mutate(Order = row_number()) %>%
    group_by(Province) %>%
    # If we had a bunch of words with the same tf_idf score, we'll possibly get many
    # more words than specified via max.words. Do a harder cut off, based on Order,
    # which should be unique.
    top_n(max.words,wt=Order) %>%
    ungroup()
  
  # Try and figure out the original word. 
  completions <- stemCompletion(plot.df$Word, words.unstemmed)
  # If no match is found in the corpus, use the original word in its place.
  completions[completions == ""] = names(completions[completions==""])
  plot.df$Word <- completions
  
  plot.df %>%
    ggplot(aes(Order, tf_idf, fill = Province)) +
    geom_col(show.legend = FALSE) +
    labs(x = NULL, y = "tf-idf") +
    facet_wrap(~Province, ncol = 3, scales = "free") +
    ggtitle(paste0("Tf-idf by ",doc.type,": ",year)) +
    # Trick to properly order bars by tf_idf when faceting
    # See: https://www.r-bloggers.com/ordering-categories-within-ggplot2-facets/
    scale_x_continuous(
      breaks = plot.df$Order,
      labels = plot.df$Word,
      expand = c(0,0)
    ) +
    coord_flip()
}

plot.save <- function(name,plot) {
  fname.plot <- paste0(name,".png")
  dir.create(here("book", "plots"), recursive=T, showWarnings=F)
  ggsave(here("book","plots",fname.plot), plot, 
         width = 9, height = 12)
}

cra.2012.words <- make.words.df(2012)
cra.2012.words.byprovince <- make.tf_idf.byprovince(cra.2012.words)
cra.2012.words.byorg <- make.tf_idf.byorg(cra.2012.words)
plot.2012.provinces.byorg <- plot.provinces(cra.2012.words.byorg, 2012, doc.type="Org")
plot.2012.provinces.byprovince <- plot.provinces(cra.2012.words.byprovince, 2012, doc.type="Province")
plot.save("tf-idf-provinces-2012-byorg", plot.2012.provinces.byorg)
plot.save("tf-idf-provinces-2012-byprovince", plot.2012.provinces.byprovince)

cra.2013.words <- make.words.df(2013)
cra.2013.words.byprovince <- make.tf_idf.byprovince(cra.2013.words)
cra.2013.words.byorg <- make.tf_idf.byorg(cra.2013.words)
plot.2013.provinces.byorg <- plot.provinces(cra.2013.words.byorg, 2013, doc.type="Org")
plot.2013.provinces.byprovince <- plot.provinces(cra.2013.words.byprovince, 2013, doc.type="Province")
plot.save("tf-idf-provinces-2013-byorg", plot.2013.provinces.byorg)
plot.save("tf-idf-provinces-2013-byprovince", plot.2013.provinces.byprovince)

cra.2014.words <- make.words.df(2014)
cra.2014.words.byprovince <- make.tf_idf.byprovince(cra.2014.words)
cra.2014.words.byorg <- make.tf_idf.byorg(cra.2014.words)
plot.2014.provinces.byorg <- plot.provinces(cra.2014.words.byorg, 2014, doc.type="Org")
plot.2014.provinces.byprovince <- plot.provinces(cra.2014.words.byprovince, 2014, doc.type="Province")
plot.save("tf-idf-provinces-2014-byorg", plot.2014.provinces.byorg)
plot.save("tf-idf-provinces-2014-byprovince", plot.2014.provinces.byprovince)

cra.2015.words <- make.words.df(2015)
cra.2015.words.byprovince <- make.tf_idf.byprovince(cra.2015.words)
cra.2015.words.byorg <- make.tf_idf.byorg(cra.2015.words)
plot.2015.provinces.byorg <- plot.provinces(cra.2015.words.byorg, 2015, doc.type="Org")
plot.2015.provinces.byprovince <- plot.provinces(cra.2015.words.byprovince, 2015, doc.type="Province")
plot.save("tf-idf-provinces-2015-byorg", plot.2015.provinces.byorg)
plot.save("tf-idf-provinces-2015-byprovince", plot.2015.provinces.byprovince)

cra.2016.words <- make.words.df(2016)
cra.2016.words.byprovince <- make.tf_idf.byprovince(cra.2016.words)
cra.2016.words.byorg <- make.tf_idf.byorg(cra.2016.words)
plot.2016.provinces.byorg <- plot.provinces(cra.2016.words.byorg, 2016, doc.type="Org")
plot.2016.provinces.byprovince <- plot.provinces(cra.2016.words.byprovince, 2016, doc.type="Province")
plot.save("tf-idf-provinces-2016-byorg", plot.2016.provinces.byorg)
plot.save("tf-idf-provinces-2016-byprovince", plot.2016.provinces.byprovince)

cra.2017.words <- make.words.df(2017)
cra.2017.words.byprovince <- make.tf_idf.byprovince(cra.2017.words)
cra.2017.words.byorg <- make.tf_idf.byorg(cra.2017.words)
plot.2017.provinces.byorg <- plot.provinces(cra.2017.words.byorg, 2017, doc.type="Org")
plot.2017.provinces.byprovince <- plot.provinces(cra.2017.words.byprovince, 2017, doc.type="Province")
plot.save("tf-idf-provinces-2017-byorg", plot.2017.provinces.byorg)
plot.save("tf-idf-provinces-2017-byprovince", plot.2017.provinces.byprovince)
