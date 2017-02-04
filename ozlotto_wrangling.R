##### Oz Lotto
# Quantifying duplicate draws

# Muhsin Karim 16/12/2016

# Notes
# https://en.wikipedia.org/wiki/Oz_Lotto
# Starting 18 October 2005, a seventh number began to be drawn, lengthening Division 1 odds.
#--------------------------------------------------------------------------------------------------

#### Libraries

suppressPackageStartupMessages(library(dplyr))


#### Get data 

setwd('C:/Users/Muhsin Karim/Documents/GitHub/ozlotto')
df <- read.csv('Ozlotto.csv', stringsAsFactors = F)
#dfPrevious <- read.csv('OzLotto.txt', stringsAsFactors = F) # Don't use - missing 7th winning draw


#### Rename columns

## Select columns for dfCurrent
df <- df %>%
    select(
        draw_number = Format..Draw.Number,
        date = Draw.Date..yyyymmdd., 
        winning_1 = Winning.Number.1,     
        winning_2 = X2,                  
        winning_3 = X3,
        winning_4 = X4,
        winning_5 = X5,
        winning_6 = X6,  
        winning_7 = X7,
        supplementary_1 = Supplementary.1,
        supplementary_2 = X2.1,
        division_1 = Division.1,
        division_2 = X2.2, 
        division_3 = X3.1, 
        division_4 = X4.1, 
        division_5 = X5.1,
        division_6 = X6.1,
        division_7 = X7.1
        )


#### Formatting

### Date

df$date <- as.Date(as.character(df$date), format = '%Y%m%d')


### Division columns as numeric

df2 <- as.data.frame(apply(df[ , 12:18], 2, function(x) gsub("\\$", "", x))) # Remove "$" from Division columns
df2 <- as.data.frame(apply(df2, 2, function(x) gsub(",", "", x))) # Remove "," from Division columns
df2 <- data.frame(lapply(df2, as.character), stringsAsFactors = F) # As character
df2 <- data.frame(lapply(df2, as.numeric)) # As numeric


### Bind data frames

df <- cbind.data.frame(df[ , 1:11], df2)


#### Percentages of division 1 draws (seven numbers)

## Stack all winning numbers as one data frame column
all_draws <- c(df$winning_1,
               df$winning_2,
               df$winning_3,
               df$winning_4,
               df$winning_5,
               df$winning_6,
               df$winning_7)

## Build division 1 table
all_division1_percentages = as.data.frame(table(all_draws))

## Total draws
total_draws <- length(all_draws)

## Percentage of number drawn out of all draws
all_division1_percentages$Percentage <- round(all_division1_percentages$Freq / total_draws * 100, 1)
all_division1_percentages$all_draws <- as.numeric(all_division1_percentages$all_draws)
colnames(all_division1_percentages) <- c("winning_draw", "frequency", "percentage")


#### Percentages of winning division 1 draws

## Subset winning division 1 draws (prize awarded)
df_winning_division1 <- df[-which(df$division_1 == 0), ]

## Stack all winning numbers as one data frame column
all_draws <- c(df_winning_division1$winning_1,
               df_winning_division1$winning_2,
               df_winning_division1$winning_3,
               df_winning_division1$winning_4,
               df_winning_division1$winning_5,
               df_winning_division1$winning_6,
               df_winning_division1$winning_7)

## Build winning division 1 table
winning_division1_percentages = as.data.frame(table(all_draws))

## Total winning draws
total_draws <- length(all_draws)

## Percentage of number drawn out of all nights
winning_division1_percentages$Percentage <- round(winning_division1_percentages$Freq / total_draws * 100, 1)
winning_division1_percentages$all_draws <- as.numeric(winning_division1_percentages$all_draws)
colnames(winning_division1_percentages) <- c("winning_draw", "frequency", "percentage")


#### Save tables as CSVs

write.csv(all_division1_percentages, file = "all_division1_percentages.csv", row.names = F)
write.csv(winning_division1_percentages, file = "winning_division1_percentages.csv", row.names = F)




# #---------------------------------------------------------------------------------------------------------------------------
# ## Check the probability of winning division 1
# # 1/45 * 1/44 * 1/43 * 1/42 * 1/41 * 1/40 * 1/39
# # 45 * 44 * 43 * 42 * 41 * 40 * 39 # 1 in 228,713,284,800
# # 45 * 44 * 43 * 42 * 41 * 40 * 39 / factorial(7) # 1 in 45,379,620 because order does not matter
# 
# ## Plot division 1
# library(ggplot2)
# ggplot(division1, aes(x = reorder(Draw, Freq), y = Freq)) + 
#     geom_bar(stat = "identity") +
#     coord_flip()
