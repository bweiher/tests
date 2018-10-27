library(crayon)
library(tidyverse)
library(glue)

  ls("package:crayon") %>% 
  tibble(x = . ) %>% 
  mutate(color = str_detect(x, "[A-Z]")) %>% 
  filter(color  == TRUE) %>% 
  pull(x) -> colors


main_cols <- colors %>% 
  str_replace_all("bg", "") %>% 
  str_to_lower()


expand.grid(
  bg_cols = colors,
  themes = c("bold", "blurred", "italic"),
  main_cols = main_cols ,
  stringsAsFactors = FALSE
) %>% 
  distinct() %>% 
  as_data_frame() -> df


df %>% 
  arrange(bg_cols) %>% 
  unite(col = x, sep = " $ ") %>% 
  pull() -> uniques

map(uniques, ~eval(parse(text =  .))) # -> x


main_cols <- c("cyan", 
               "red",
               "blue",
               "green", 
               "magenta", 
               "yellow")

get_col <- function() sample(main_cols, 1)

print_str_col <- function(x) {
  string <- unlist(str_split(x, ""))
  
  for(g in seq_along(string)){
    col <- get_col()
    string[g] <- glue("{col} {string[g]}") %>% 
      paste0("{", ., "}")
  }
   
    glue_collapse(string) %>% 
    glue_col() %>% 
    print()
  
  
}


for(g in 1:10){
  print_str_col("Rainbow_coloring!!!
                ooooooh!
                
                ")
}



len <- length(main_cols)

map_df(c(2:24), 
       ~tibble(x=rbinom(n = 100, size = .x, prob = 1/6),
               size = .x) 
       ) %>% 
  group_by(size) %>% 
  summarise(
    runs =  n(),
    prop =  sum(ifelse(x > 1, 1, 0))
  ) %>% 
  mutate(
    prop =  prop / runs
  ) %>% 
  print(n=Inf)
  

string <- c("g", "o", "o","d",  "c", "a" , "t")
x <- string

new_chr <- character(length = length(x))

# for(g in seq_along(x)){
#   this_col <- sample(main_cols, 1)
#   new_chr[g] <- this_col
#     if(new_chr[g - 1L] == ){
#       
#     }
# }





