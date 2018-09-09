library(tidyverse)

Sys.setenv(con1 = 'DBI::dbConnect(RSQLite::SQLite(), ":memory:")')


con <- Sys.getenv("con1") %>% 
  parse(text = .) %>% 
  eval(envir = globalenv())


con_db <- function(connection){
  eval(parse(text = Sys.getenv(connection)), envir = environment())
}


con2 <- con_db("con1")
con2