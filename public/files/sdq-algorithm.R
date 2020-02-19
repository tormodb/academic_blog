## SDQ Predictive algoritm in R

library(dplyr)
library(haven)

### Load your data into R

# The syntax is based on you reading you data into an object named `sdq`. This could be done with the command: 
sdq <- read_sav("sdq.sav")

### SDQ HYPERACTIVITY PREDICTION

sdq <- sdq %>%
  mutate(
    phk = case_when(
      phyper>=7 & pimpact>=2 ~ 2,
      phyper>=9 & pimpact>=1 ~ 2,
      phyper>=6 & pimpact>=1 ~ 1,
      phyper>=0 & pimpact>=0 ~ 0)
  )

sdq <- sdq %>% 
  mutate(
    shk = case_when(
      shyper>=7 & simpact>=2 ~ 2,
      shyper>=6 & simpact>=1 ~ 1,
      shyper>=0 & simpact>=0 ~ 0)
  )

sdq <- sdq %>% 
  mutate(
    thk = case_when(
      thyper>=7 & timpact>=2 ~ 2,
      thyper>=6 & timpact>=1 ~ 1,
      thyper>=0 & timpact>=0 ~ 0))


sdq$pshk <- sdq$phk
sdq$pshk <- ifelse(is.na(sdq$phk), sdq$shk, sdq$pshk)

sdq <- sdq %>% 
  mutate(
    sdqhk = case_when(
      pshk==2 & thk>=1 ~ 2,
      pshk>=1 & thk>=1 ~ 1,
      is.na(pshk) & thk>=1 ~ 1,
      pshk>=1 & !is.na(pshk) & is.na(thk) ~ 1,
      pshk==2 | thk==2 ~ 1,
      phk>=0 | shk>=0 | thk>=0 ~ 0)
  )

sdq <- sdq %>% 
  mutate(
    sdqcd = case_when(
      is.na(pimpact) & is.na(timpact) & is.na(simpact) ~ NA_real_,
      pconduct>=5 & pimpact>=2 ~ 2,
      tconduct>=4 & timpact>=2 ~ 2,
      sconduct>=6 & simpact>=2 ~ 2,
      pconduct>=4 | tconduct>=3 | sconduct>=5 ~ 1,
      pconduct>=0 | tconduct>=0 | sconduct>=0 ~ 0)
  )

### SDQ EMOTION PREDICTION

sdq <-  sdq %>% 
  mutate(
    sdqed = case_when(
      semotion>=6 & simpact>=1 ~ 1, 
      pemotion>=5 & pimpact>=1 ~ 1,
      temotion>=5 & timpact>=1 ~ 1, 
      pemotion>=0 | temotion>=0 | semotion>=0 ~ 0)
  )

sdq <- sdq %>% 
  mutate(pem = case_when(
    pemotion>=6 & pimpact>=2 ~ 1,
    TRUE ~ 0))

sdq <- sdq %>% 
  mutate(tem = case_when(
    temotion>=6 & timpact>=2 ~ 1,
    TRUE ~ 0))

sdq <- sdq %>% 
  mutate(sem = case_when(
    semotion>=7 & simpact>=2 ~ 1,
    TRUE ~ 0))

sdq <- sdq %>% 
  mutate(allem = pem + tem + sem)

sdq <- sdq %>% 
  mutate(
    sdqed_tmp = case_when(
      is.na(sdqcd) & is.na(sdqhk) ~ NA_real_,
      allem==1 & (sdqcd==2 | sdqhk==2) ~ 1,
      allem>=1 ~ 2, 
      sdqed==1 ~ 1,
      TRUE ~ 0))

sdq <- sdq %>% 
  mutate(
    sdqed = sdqed_tmp)

### SDQ ANY DISORDER PREDICTION

sdq <- sdq %>% 
  mutate(
    anydiag = case_when(
      sdqed==2 | sdqcd==2 | sdqhk==2 ~ 2,
      sdqed>=1 | sdqcd>=1 | sdqhk>=1 ~ 1,
      sdqed>=0 | sdqcd>=0 | sdqhk>=0 ~ 0)
  )

### CLEANING UP

# DELETE MIDWAY VARIABLES
sdq <- sdq %>% select(-phk, -shk, -thk, -pshk, -pem, -tem, -sem, -allem, -sdqed_tmp)

# ASSIGN LABELS
sdq$sdqhk   <- ordered(sdq$sdqhk,   levels = c(0, 1, 2), 
                       labels = c("Unlikely", "Possible", "Probable"))
sdq$sdqcd   <- ordered(sdq$sdqcd,   levels = c(0, 1, 2), 
                       labels = c("Unlikely", "Possible", "Probable"))
sdq$sdqed   <- ordered(sdq$sdqed,   levels = c(0, 1, 2), 
                       labels = c("Unlikely", "Possible", "Probable"))
sdq$anydiag <- ordered(sdq$anydiag, levels = c(0, 1, 2), 
                       labels = c("Unlikely", "Possible", "Probable"))
