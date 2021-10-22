# Reading in and analysing the lyrics downloaded using python 


library(pacman)

p_load(tidyjson, # piping functions with JSON files 
       rjson, # reading in JSON files 
       tidyverse, # data manipulation and visualization
       tidytext, # working with text data w/ tidy rules 
       furrr, # future mapping but with purr
       gsubfn, # regular expressions and whatnot 
       plyr) # allows for the merging of datasets. 


# Data ----------------------------------------------------------------------------------------------------------------------

# Selecting the files to read
json.files <- list.files("data", ".json")

# editing them to match what R registers 
json.files <- gsubfn("Lyrics", "data/Lyrics", json.files)


# Define function to fetch lyrics 
get.song.lyrics <- function(x) {
  artist <- fromJSON(file = x)
  
  artist_song <- artist$songs %>%
    spread_all()
  
  returnValue(artist_song)
}


# Map function to vector of file names 
song.list <- future_map(json.files, get.song.lyrics)

# turn large list into data frame 

song.list <- do.call(rbind.fill, song.list)


# Check to see if all artists are present
unique(song.list$artist) %>%
  length() # they are 


# Shrink to relevant columns 
colnames(song.list) # only three (artists, lyrics)

song.list <- song.list %>%
  select(artist, lyrics)


# Need to include a genre for the column, this is where the old categories come in handy! 
artists <- read_csv("data/Artist_List.csv")

artists$artist_name[c(20, 11, 5)] <- c("Guns N' Roses", "Céline Dion", "Beyoncé")

pop <- artists$artist_name[artists$genre == "Pop"]

rock <- artists$artist_name[artists$genre == "Rock"]
rock[c(11,12)] <- c("Bruce Springsteen", "The Beatles")

rap <- artists$artist_name[artists$genre == "Hip Hop"]
rap[11] <- "Doja Cat" # had to make additions to make up for the songs excluded for the downloads. 

country <- artists$artist_name[artists$genre == "Country"]
country[11] <- "Blake Shelton"

rnb <- artists$artist_name[artists$genre == "R&B"]
rnb[11] <- "Sade"



song.list$genre[song.list$artist %in% pop] = "Pop"
song.list$genre[song.list$artist %in% rap] = "Hip Hop"
song.list$genre[song.list$artist %in% country] = "Country"
song.list$genre[song.list$artist %in% rnb] = "R&B"
song.list$genre[song.list$artist %in% rock] = "Rock"


# Checking for completeness -------------------------------------------------------------------------------------------------
# Each artist should have 150 songs, so 10 * 150: 1500 songs per genre. Lets see if this is the case. 

track <- tibble(genre = character(0), 
                amount = character(0))

for (genre in unique(artists$genre)) {
   dat <- length(which(song.list$genre == genre)) %>%
     as.character()
  
  print(c(dat, genre))
  
}
# Pop needs 1 less
# Rock needs 188 (adding bruce springsteen & the beatles)
# Country needs 75 (adding Blake shelton)
# rnb/hip hop need 55 (adding Sade and Doja Cat) 

# rerun script after additions are made 


write.csv(song.list, file = "data/song.list.csv")

# Going to write different genres into .txt files, maybe this'll be easier to do analysis with? 

# Data
song.list <- read_csv("data/song.list.csv") %>%
  select(-c(1))


# Filter based on genre 
pop <- song.list %>%
  filter(genre == "Pop")

rap <- song.list %>%
  filter(genre == "Hip Hop")

rnb <- song.list %>%
  filter(genre == "R&B")

country <- song.list %>%
  filter(genre == "Country")

rock <- song.list %>%
  filter(genre == "Rock")

# Turning them into text files 
pop <- pop[-1501, ]

write.table(pop$lyrics, "data/pop.lyrics.txt")
write.table(rap$lyrics, "data/rap.lyrics.txt")
write.table(country$lyrics, "data/country.lyrics.txt")
write.table(rnb$lyrics, "data/rnb.lyrics.txt")
write.table(rock$lyrics, "data/rock.lyrics.txt")
