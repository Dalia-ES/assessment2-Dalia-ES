#Install tidyverse packages for data manipulation
install.packages("tidyr")
install.packages("dplyr")

#Load tidyverse packages into R session
library(tidyr) #Package for data tidying and reshaping
library(dplyr) #Package for data manipulation and transformation

#Read Spotify text file into a data frame labelled spotify
spotify <- read.table("Spotify_Messy_200034287.txt",
                      sep="\t",
                      header=T,
                      na.strings=c("NA"))

#Display structure of the spotify data frame
str(spotify)

#View the spotify data frame in a table
View(spotify)

#Print all column names of the spotify data frame
colnames(spotify)[1:ncol(spotify)]

#Reshape spotify dataset using pivot_longer, creating a new column called playlist_genre
spotify <- spotify %>% pivot_longer(cols = c("pop","rap","rock","r.b","edm"),
             names_to="playlist_genre",
             values_to="playlist_subgenre")
spotify

#Fills playlist_subgenre rows
spotify <- spotify %>% fill(playlist_subgenre)
spotify

#Separating danceability and energy into two columns
spotify <- spotify %>%
  separate_wider_delim("danceability.energy", "_", names=c("danceability", "energy"))
spotify

#Adjusts columns to numeric
spotify <- spotify %>%
  mutate(across(c(danceability,energy),as.numeric))
spotify


#Changes row values 0 and 1 to major or minor
spotify <- spotify %>% mutate(mode=gsub("1", "major", mode),
                   mode=gsub("0", "minor", mode),
                   mode=gsub("A", "", mode))
spotify

#Renaming track_name column
spotify <- spotify %>% rename(c(track_name=ZZtrack_name89))
spotify

spotify %>%
  pivot_longer(cols=starts_with("playlist"), names_to = "playlist", values_to = "danceability", names_repair = "universal")



unique_playlist_subgenres <- unique(spotify$playlist_subgenre)

#Finds unique playlist names
unique_playlist_names <- unique(spotify$playlist_name)

#Finding misspelled artist names
unique_artists <- unique(spotify$track_artist)
shakira <- grep("^Sh",
                unique_artists,
                ignore.case=T)
unique_artists[shakira]

taylor_swift <- grep("^Ta",
                unique_artists,
                ignore.case=T)
unique_artists[taylor_swift]

janis_joplin <- grep("^Ja",
                     unique_artists,
                     ignore.case=T)
unique_artists[janis_joplin]

the_four_owls <- grep("^Th",
                     unique_artists,
                     ignore.case=T)
unique_artists[the_four_owls]

bad_bunny <- grep("^Ba",
                      unique_artists,
                      ignore.case=T)
unique_artists[bad_bunny]

sessionInfo()
