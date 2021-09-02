library(tidyverse)

# reading data
players <- read.delim('./data.csv', h=T, sep=',')
# head(players)

names(players)[1] <- 'player' # renaming column name

##################################################

# reordering names
players[,1] %>% str_replace_all(' ', '')  %>% str_split(',') %>%
  sapply(function(x){
    paste(x[[2]], x[[1]])
  }) -> players[,1]


# converting inches to m
inches_to_m <- function(x) round(x / 39.37, 2)

ind <- c(5,6,8,11,12)

for(i in ind){
  players[,i] <- inches_to_m(players[,i])
}

# converting lbs to kg
lbs_to_kg <- function(x) round(x/2.205,2)

players$weight <- lbs_to_kg(players$weight)

##################################################

# merging with draft
draft <- read_csv('./draft.csv')

draft$drafted <- ifelse(is.na(draft$team_draft), 0, 1) 

combine <- merge(players, draft, by.x='player', by.y='player', all.x = T)

# writing new table
combine <- write.table(combine, 'combine.csv', row.names = F, sep=',')
