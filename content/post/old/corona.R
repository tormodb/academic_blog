library(tidyverse)
library(rvest)
library(xml2)


today <- format(Sys.time(), "%a %b %d %X %Y")


day <- unlist(strsplit(today, " "))[1]

day <-  recode(day, 
       Mon = "mandag",
       Tue = "tirsdag", 
       Wed = "onsdag", 
       Thur = "torsdag",
       Fri = "fredag", 
       Sat = "lordag", 
       Sun = "sondag")

mth <- unlist(strsplit(today, " "))[2]

mth <- recode(mth, 
       Mar = "mars", 
       Apr = "april")

date <- unlist(strsplit(today, " "))[3]
year <- unlist(strsplit(today, " "))[5]


url3 <- paste0("https://www.fhi.no/nyheter/2020/status-koronasmitte-", day, "-", date, ".-", mth, "-", year)
url_res3 <- xml2::read_html(url3)

frafhi <- url_res3 %>% html_nodes(".textual-block") %>% 
  map_df(~{
  tibble(
    # postal = html_node(.x, "span") %>% html_text(trim=TRUE),
    fhi = html_nodes(.x, "ul > li") %>% html_text(trim=TRUE)
  )
}) 



innlagt_fhi <- frafhi$fhi[1] %>% str_match_all("[0-9]+") %>% unlist %>% as.numeric
intensiv_fhi <- frafhi$fhi[4] %>% str_match_all("[0-9]+") %>% unlist %>% as.numeric

innl_num <- word(innlagt_fhi)[1]
# innl_num <- as.numeric(paste0(innl_num[1], innl_num[2]))
intens_num <- as.numeric(word(intensiv_fhi)[3])

# month <- 
  
fulldate <- format(Sys.time(), "%d.%m.%Y")
fullmonth <- format(Sys.time(), "%m")
fullyear <- format(Sys.time(), "%Y")

infint_fhi <- as.data.frame(cbind(date,  fullmonth, fullyear, innl_num, intens_num, fulldate))

write.table(infint_fhi, "/Users/st06810/Dropbox/UiB/blog/content/post/infint_fhi.csv", dec=".", quote=FALSE, append=T, sep="\t", col.names=FALSE)

url2 <- paste0("https://www.helsedirektoratet.no/nyheter/oversikt-over-innlagte-pasienter-med-covid-19-per-", format(Sys.Date(), "%d"),".mars")

url_res2 <- xml2::read_html(url2)

url_res2 %>% html_text()

hdir <- url_res2 %>% 
  html_nodes(".b-article-intro__intro") %>% html_text()

day_hdir <- unlist(strsplit(hdir, " "))[3]

day_hdir <- gsub('[[:punct:] ]+','', day_hdir)

mth_hdir <- unlist(strsplit(hdir, " "))[4]
mth_hdir <- ifelse(mth_hdir=="mars", "03", 
              ifelse(mth_hdir=="april", "04", 
                     ifelse(mth_hdir=="mai", "05", 
                            ifels(mth_hdir=="juni", "06", NA))))

n_innl_hdir <- unlist(strsplit(hdir, " "))[6]
n_int_hdir <- unlist(strsplit(hdir, " "))[15]

# This function is supposed to replace NULL values with missing values in case the script is used
# before the website is updated. Not working properly yet... 

if (is.null(day_hdir) && is.null(day_hdir && is.null(mth_hdir) && is.null(n_innl_hdir) && is.null(n_int_hdir))){
  day_hdir <- NA
  mth_hdir <- NA
  n_innl_hdir <- NA
  n_int_hdir <- NA
  return(day_hdir)
  return(mth_hdir)
  return(n_innl_hdir)
  return(n_int_hdir)
}

# day_hdir
# mth_hdir
# n_innl_hdir
# n_int_hdir

year_hdir <- 2020


date <- (paste(day_hdir, mth_hdir, year_hdir, sep = "."))

innl_date <- as.data.frame(cbind(day_hdir, mth_hdir, year_hdir, n_innl_hdir, n_int_hdir, date))


write.table(innl_date, "/Users/st06810/Dropbox/UiB/blog/content/post/innl_date.csv", dec=".", quote=FALSE, append=T, sep="\t", col.names=FALSE)


url <- "https://www.fhi.no/sv/smittsomme-sykdommer/corona/"
url_res <- xml2::read_html(url)

n_inf <- url_res %>% 
html_nodes(".fhi-key-figure-number") %>% .[[2]] %>% html_text()
n_inf <- as.numeric(n_inf)

date_txt <- url_res %>% 
  html_nodes(".fhi-key-figure-desc") %>% .[[2]] %>% html_text()

day_tmp <-  unlist(strsplit(date_txt, " "))[7]

mth_tmp <-  unlist(strsplit(date_txt, " "))[8]

day <- gsub('[[:punct:] ]+','',day_tmp)

day <- as.numeric(day)

mth <- ifelse(mth_tmp=="mars", "03", 
                     ifelse(mth_tmp=="april", "04", 
                            ifelse(mth_tmp=="mai", "05", 
                                   ifels(mth_tmp=="juni", "06", NA))))
year <- 2020
date <- (paste(day, mth, year, sep = "."))
mth <- as.numeric(mth)
inf_date <- as.data.frame(cbind(day, mth, year, n_inf, date, day_tmp, mth_tmp))

write.table(inf_date, "/Users/st06810/Dropbox/UiB/blog/content/post/inf_date.csv", dec=".", quote=FALSE, append=T, sep="\t", col.names=FALSE)
