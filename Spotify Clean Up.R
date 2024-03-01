#Install tidyverse packages for data manipulation
install.packages("tidyr")
install.packages("dplyr")

#Load tidyverse packages into R session
library(tidyr) #Package for data tidying and reshaping
library(dplyr) #Package for data manipulation and transformation

#Read Spotify text file into a data frame labelled spotify
spotify <- read.table("Spotify_Messy_200034287.txt",
                      sep="\t",
                      header=T)

#Display structure of the spotify data frame
str(spotify)

#View the spotify data frame in a table
View(spotify)

#Print all column names of the spotify data frame
colnames(spotify)[1:ncol(spotify)]

#Reshape spotify dataset using pivot_longer, creating a new column called playlist_genre
spotify <- spotify %>% pivot_longer(cols = c("pop","rap","rock","r.b","edm"),
             names_to="playlist_genre")
spotify
