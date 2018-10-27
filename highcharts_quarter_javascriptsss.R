# highcharts
# r noob way of plotting data by quarters 

library(highcharter)
library(tidyverse)
library(lubridate)
library(glue)

seq.Date(ymd(20180101), ymd(20181231), by = "days") %>% 
  tibble(
    date = .
  ) %>% 
  mutate(
    quarter = floor_date(date, "quarter")
  ) %>% 
  distinct(quarter) %>% 
  mutate(
    yvar = 10 * runif(4),
    z = 100 * runif(4)
  ) -> df




js_fn <- function(ds, just_quarter = TRUE, additional_js = NULL){
  
  query <- glue("function(){{
    var n = new Date({ds});
    var year = n.getUTCFullYear();
    var month = n.getUTCMonth() + 1;
    var quarter
              
    if(month <= 3){{ 
    quarter = 1
    }} else if (month >  3 & month <= 4){{ 
    quarter = 2
    }} else if (month > 4 & month <= 7){{
    quarter = 3
    }} else if (month > 7){{
    quarter = 4
    }} 
")
  
  quarter <- glue("return year + '.' + quarter")
  
  if(isTRUE(just_quarter)){
    query <- c(query,quarter, glue("}}"))
  } else {
    if(is.null(additional_js)) stop("You need to provide an argument for `additional_js`")
   assertthat::assert_that(is.character(additional_js))
   query <- c(query, paste0(quarter, " + '<br>' + "), additional_js, glue("}}")) 
  }
  glue_collapse(query, sep = "\n") %>% 
    JS()
}



# test 
js_fn(ds = "this.x", 
      just_quarter = FALSE
)

js_fn(ds = "this.x",just_quarter = FALSE,additional_js = 1)



          
hc <- highchart() %>% 
   hc_add_series(df, "line", hcaes(x=quarter, y= yvar)) %>% 
   hc_xAxis(type = "datetime")


# default , first day of each month on x axis       
hc
           

# use the quarter year instead on x axis
hc <- hc  %>% 
  hc_xAxis(type = "datetime",
           labels  = list(
             formatter =  js_fn(ds = "this.value")
           )
           ) 


hc



add <-  "
  'yvar: ' + this.point.y + '<br>' + 
  'zvar: ' + this.point.z 
  "

# do it for the tooltip ; doesn't use this.value , uses this.x instead;
hc %>% 
  hc_tooltip(formatter = js_fn(ds = "this.x", 
                               just_quarter = FALSE,
                               additional_js = add
                                ))

             
