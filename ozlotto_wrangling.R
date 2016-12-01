##### Oz Lotto
# Quantifying duplicate draws

# Muhsin Karim 1/12/2016
#--------------------------------------------------------------------------------------------------


#### Libraries

suppressPackageStartupMessages(library(dplyr))


#### Get data 

setwd('C:/Users/Muhsin Karim/Documents/GitHub/ozlotto')
dfCurrent <- read.csv('Ozlotto.csv', stringsAsFactors = F)
#dfPrevious <- read.csv('OzLotto.txt', stringsAsFactors = F) # Don't use - missing 7th winning draw


#### Formatting

## Select columns for dfCurrent
df <- dfCurrent %>%
    select(
        Format..Draw.Number,  
        Draw.Date..yyyymmdd., 
        Winning.Number.1,     
        X2,                  
        X3,
        X4,
        X5,
        X6,  
        X7,
        Supplementary.1,
        X2.1
        )

# ## Merge current and 
# df <- rbind.data.frame(df, dfPrevious)
# df <- df[order(df$Format..Draw.Number), ]
# rownames(df) <- NULL

## Rename columns
df <- df %>%
    select(
        DateNumber = Format..Draw.Number,
        Date = Draw.Date..yyyymmdd., 
        Winning1 = Winning.Number.1,     
        Winning2 = X2,                  
        Winning3 = X3,
        Winning4 = X4,
        Winning5 = X5,
        Winning6 = X6,  
        Winning7 = X7, 
        Supplementary1 = Supplementary.1,
        Supplementary2 = X2.1
    )

## Coerce to date
df$Date <- as.Date(as.character(df$Date), format = '%Y%m%d')


# #### Quantify duplicate draws
# # For each row, get seven numbers, order then record
# 
# df$FirstDivision <- ""
# 
# for (i in 1:nrow(df)) {
#     
#     ## Get numbers from draws
#     first_division <- as.numeric(df[i , c("Winning1", "Winning2", "Winning3", "Winning4", "Winning5", "Winning6", "Winning7")])
#     
#     ## Order draws
#     first_division <- sort(first_division)
# 
#     ## Record ordered draw
#     df$FirstDivision[i] <- paste(first_division, collapse=" ")
# }
# 
# 
# sum(duplicated(df$FirstDivision))

## Stack all draws as one data frame column
all_draws <- c(as.numeric(df$Winning1), 
             as.numeric(df$Winning2),
             as.numeric(df$Winning3),
             as.numeric(df$Winning4),
             as.numeric(df$Winning5),
             as.numeric(df$Winning6),
             as.numeric(df$Winning7))

t = as.data.frame(table(all_draws))
names(t)[1] = 'Draw'
head(t)

library(ggplot2)
ggplot(t, aes(x = reorder(Draw, Freq), y = Freq)) + 
    geom_bar(stat = "identity") +
    coord_flip()

