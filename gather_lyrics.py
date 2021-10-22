# -*- coding: utf-8 -*-
"""

@author: Justin Okeke

Lyric Analysis 

Comparing mentions of drugs in 5 different genres, for 10 different artists. 
Can download as df/csv in R, but comes out rather messy. 

"""

import lyricsgenius as genius
import pandas as pd


# set api up, create conditions for downloads (excluding remixes and live), 
# skipping songs the artist is featured on as well.
genius = genius.Genius('xgHL7_q6VGQaKz5Id0HhDCyIncpineDkZX8ovvORsO2Wum_c3-hUFr-7pK56ukyH', 
                   skip_non_songs=True, 
                   excluded_terms=["(Remix)", "(Live)"], 
                   remove_section_headers=True)

# Testing the api to see if it works 
artist = genius.search_artist("Drake", max_songs=5)

del artist


# Read in the list of artists made before
main_list = pd.read_csv("data/Artist_List.csv")

# correcting issues with the names
artists = list(main_list['artist_name'])
artists[4] = 'Beyoncé'
artists[10] = "Céline Dion"
artists[19] = "Guns N' Roses"

main_list['artist_name'] = artists
 

# downloading lyrics to .json file
for artist in artists: 
    try: 
        lyrics = genius.search_artist(artist, max_songs = 150) 
        lyrics.save_lyrics() 
    except: 
        print(["API timeout at ", artist]) # the API times out, so when it does, we want it to start over with the same artist it was on - preventing losses. 
        lyrics = genius.search_artist(artist, max_songs = 150) 
        lyrics.save_lyrics() 
        
        
 # EDIT: Making up for missing songs (songs excluded from the downloads due to the filtered keywords)
artists = ["Doja Cat", "Sade", "Blake Shelton", "Bruce Springsteen", "The Beatles"]

for artist in artists: 
    try: 
        lyrics = genius.search_artist(artist, max_songs = 150) 
        lyrics.save_lyrics() 
    except: 
        print(["API timeout at ", artist]) # the API times out, so when it does, we want it to start over with the same artist it was on - preventing losses. 
        lyrics = genius.search_artist(artist, max_songs = 150) 
        lyrics.save_lyrics() 
 

        
        
        
        
