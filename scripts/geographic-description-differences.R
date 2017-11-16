library(rstudioapi)
library(stringr)
library(purrr)
library(dplyr)

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

cra.2012.identity <- read.csv(here("data","raw","CRA-2012-Ident.csv"))
cra.2012.programs <- read.csv(here("data","raw","CRA-2012-NewOngoingPrograms.csv"))

cra.2012.joined <- cra.2012.programs %>% left_join(cra.2012.identity, by="BN")
