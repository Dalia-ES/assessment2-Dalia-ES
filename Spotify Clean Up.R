#Install tidyverse packages for data manipulation
install.packages("tidyr")
install.packages("dplyr")

#Load tidyverse packages into R session
library(tidyr) #Package for data tidying and reshaping
library(dplyr) #Package for data manipulation and transformation

#Tidy data
spotify <- read.table("Spotify_Messy_200034287.txt", #Read Spotify text file into a data frame called spotify
                      sep="\t", #Tab separated
                      header=T, #True headers
                      na.strings=c("NA"))

#Print all column names of the spotify data frame
colnames(spotify)[1:ncol(spotify)]

#Reshape spotify dataset using pivot_longer, creating a new column called playlist_genre
spotify <- spotify %>%
  pivot_longer(cols=c("pop","rap","rock","r.b","edm"),
               names_to="playlist_genre",
               values_to="playlist_subgenre",
               values_drop_na=T)

#Renaming columns
spotify <- spotify %>%
  rename(c(track_name=ZZtrack_name89,
           tempo_bpm=tempo,
           loudness_db=loudness))

#Changes row values 0 and 1 to major or minor
spotify <- spotify %>%
  mutate(mode=gsub("1", "major", mode),
         mode=gsub("0", "minor", mode),
         mode=gsub("A", "", mode))

#Separating danceability and energy into two columns
spotify <- spotify %>%
  separate_wider_delim("danceability.energy", "_", names=c("danceability", "energy")) %>%
  mutate(across(c(danceability,energy),as.numeric)) #Adjusts columns to numeric

#Calculating mean danceability for each playlist
spotify <- spotify %>%
  group_by(playlist_name) %>%
  mutate(mean_danceability=round(mean(danceability,na.rm=T), digits=3)) %>%
  ungroup()

#Reorganising column order
spotify <- spotify %>%
  select(track_id, track_name, track_artist, track_popularity, track_album_id, track_album_name, track_album_release_date, playlist_name, playlist_id, playlist_genre, playlist_subgenre, danceability, mean_danceability, energy, key, loudness_db, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo_bpm, duration_ms)

#Searching for all NA values
na_values <- spotify %>%
  filter(if_any(everything(), is.na))
na_values
View(na_values)

#Finds unique track album dates
unique(spotify$track_album_release_date)

#Removes the year 3000 from track album dates
spotify <- spotify %>%
  mutate(track_album_release_date=gsub("3000-", "", track_album_release_date))

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

#Correcting Taylor Swift misspelling
spotify <- spotify %>% mutate(track_artist=gsub("Tailor Swift", "Taylor Swift", track_artist))
spotify

#Display structure of the spotify data frame
str(spotify)

#View the spotify data frame in a table
View(spotify)

sessionInfo()