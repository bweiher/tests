library(glue)
library(dplyr)

x <- 5

test_fn <- function(x) {
  x <- 31
  print(x)
}

test_fn_local <- function(x) {
  x <- 31
  print(quote(x) %>% evaluate(envir = environment()))
}


test_fn_global <- function(x) {
  x <- 31
  print(quote(x) %>% evaluate(envir = globalenv()))
}



tibble(
  regular =  test_fn(2) ,
  local =  test_fn_local(2) ,
  global=  test_fn_global(2)
)


