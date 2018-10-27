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
    yvar = round(10 * runif(4), 1),
    z = round(100 * runif(4),1)
  ) -> df




hc_quarter <- function(ds, just_quarter = TRUE, additional_js = NULL){
  
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
    query <- c(query,quarter)
  } else {
    if(is.null(additional_js)) stop("You need to provide an argument for `additional_js`")
   assertthat::assert_that(is.character(additional_js))
   query <- c(query, paste0(quarter, " + '<br>' + "), additional_js) 
  }
  glue_collapse(c(query,glue("}}")), sep = "\n") %>% 
    JS()
}




hc_quarter(ds = "this.x")
hc_quarter(ds = "this.x", just_quarter = FALSE) # expect errors
hc_quarter(ds = "this.x",just_quarter = FALSE,additional_js = 1) # expect errors


# initialize hc object
hc <- highchart() %>% 
   hc_add_series(df, "line", hcaes(x=quarter, y= yvar)) %>% 
   hc_xAxis(type = "datetime")


# default 
# first day of each quarter is plotted
hc
           

# use the quarter year instead on x axis
hc <- hc  %>% 
  hc_xAxis(type = "datetime",
           labels  = list(
             formatter =  hc_quarter(ds = "this.value")
           )
           ) 


hc



add <-  "
  'yvar: ' + '<i>' + this.point.y + '<br>' + 
  'zvar: ' + '<i>' + this.point.z 
  "

# do it for the tooltip ; doesn't use this.value , uses this.x instead;
hc %>% 
  hc_tooltip(formatter = hc_quarter(ds = "this.x", 
                               just_quarter = FALSE,
                               additional_js = add
                                ))

             
