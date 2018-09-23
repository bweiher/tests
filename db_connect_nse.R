library(tidyverse)

Sys.setenv(con1 = 'DBI::dbConnect(RSQLite::SQLite(), ":memory:")')


con <- Sys.getenv("con1") %>% 
  parse(text = .) %>% 
  eval(envir = globalenv())


con_db <- function(connection){
  con_chr <- Sys.getenv(connection)
  message(con_chr)
  eval(parse(text = con_chr), envir = environment())
}


con2 <- con_db("con1")
copy_to(con2, mtcars)
tbl(con2, "mtcars")
