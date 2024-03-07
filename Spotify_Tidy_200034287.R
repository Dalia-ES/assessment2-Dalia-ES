#Install and load tidyverse packages
install.packages(c("tidyr", "dplyr"))
library(tidyr) #Package for data tidying and reshaping
library(dplyr) #Package for data manipulation

#Tidy and reshape messy Spotify data
spotify <- read.table("Spotify_Messy_200034287.txt", #Read Spotify text file data into a data frame called "spotify"
                      sep = "\t", #Separate values by tabs
                      header = T, #Include a header line
                      na.strings = c("NA")) %>% #Treat "NA" strings as missing values
  pivot_longer(cols = c("pop", "rap", "rock", "r.b", "edm"), #Condense original column names, creating a new column
               names_to = "playlist_genre", #Name for the new column capturing original column names
               values_to = "playlist_subgenre", #Name for the new column capturing original values
               values_drop_na = T) %>% #Remove rows with NA values
  rename(c(track_name = ZZtrack_name89, #Rename column name
           tempo_bpm = tempo, #Rename column name
           loudness_db = loudness)) %>% #Rename column name
  mutate(mode = gsub("1", "major", mode), #Replace values "1" with "major" within the "mode" column
         mode = gsub("0", "minor", mode), #Replace values "0" with "minor" within the "mode" column
         mode = gsub("A", "", mode)) %>% #Remove values "A" from the "mode" column
  mutate(track_album_release_date = gsub("3000-", "", track_album_release_date)) %>% #Remove values "3000-" from the "track_album_release_date" column
  mutate(track_artist = gsub("Tailor Swift", "Taylor Swift", track_artist)) %>% #Replace values "Tailor Swift" with "Taylor Swift" within the "track_artist" column
  separate_wider_delim("danceability.energy", "_", names = c("danceability", "energy")) %>% #Separate "danceability.energy" column into "danceability" and "energy"
  mutate(across(c(danceability, energy), as.numeric)) %>% #Change values to numeric within the "danceability" and "energy" columns
  group_by(playlist_name) %>% #Group the data by "playlist_name" column values
  mutate(mean_danceability = round(mean(danceability, na.rm = T), digits = 3)) %>% #Calculate mean danceability, creating a new column called "mean_danceability", and rounding the vales to 3 decimal points
  ungroup() %>% #Ungroup the data
  select(track_id, track_name, track_artist, track_popularity, track_album_id, track_album_name, track_album_release_date, playlist_name, playlist_id, playlist_genre, playlist_subgenre, danceability, mean_danceability, energy, key, loudness_db, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo_bpm, duration_ms) #Change order of columns

#Export tidy Spotify data
write.table(spotify, "Spotify_Tidy_200034287.txt", sep = "\t", row.names = FALSE) #Export tidy data
spotify_tidy <- read.table("Spotify_Tidy_200034287.txt", #Read tidy spotify text file data into a data frame called "spotify_tidy"
                      sep = "\t", #Separate values by tabs
                      header = T, #Include a header line
                      na.strings = c("NA")) #Treat "NA" strings as missing values
View(spotify_tidy) #Table representation of "spotify_tidy" data frame

#Data analysing
str(spotify) #View internal structure of data frame
colnames(spotify)[1:ncol(spotify)] #Print all column names
spotify %>% select_if(~any(is.na(.))) #Search for columns containing NA values
unique(spotify$track_album_release_date) #Search for unique values from "track_album_release_date" column
unique_artist_names <- unique(spotify$track_artist) #Search for unique values from "track_artist" column
taylor_swift <- grep("^ta", #Search for values which start with "ta"
                unique_artist_names, #Search for these values within the "unique_artist_names" vector
                ignore.case = T) #Ignore case sensitivity
unique_artist_names[taylor_swift] #Print artist names starting with "ta"

#Session information
sessionInfo()