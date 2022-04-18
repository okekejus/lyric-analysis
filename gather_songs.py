# -*- coding: utf-8 -*-
"""

@author: Justin Okeke

Lyric Analysis 

Comparing mentions of drugs in 5 different genres, for 10 different artists. 
Can download as df/csv in R, but comes out rather messy. 

"""

import lyricsgenius as genius
import pandas as pd
import dask
from dask import delayed
import os, json
from pandas.io.json import json_normalize

api_token = "token"

artists = pd.read_csv("Artist_List.csv", encoding='latin-1', index_col=0)
artist_name = artists['artist_name']

genius = genius.Genius(api_token,
                   skip_non_songs=True, 
                   excluded_terms=["(Remix)", "(Live)"], 
                   remove_section_headers=True, 
                   retries=1,
                   timeout=10,
                )

genius.verbose = False

@delayed
def get_lyrics(artist):
    try:
        lyrics = genius.search_artist(artist, max_songs = 200)
        lyrics.save_lyrics()
    except HTTPError as e:
        print(e.errno)    # status code
        print(e.args[0])  # status code
        print(e.args[1])  # error message
        
        if e.args[1].startswith('5'):
            time.sleep(5)
            lyrics = genius.search_artist(artist, max_songs = 200)
            lyrics.save_lyrics()
    except Timeout:
        pass

delayed_results = []

for artist in artists:
    observed = get_lyrics(artist)
    delayed_results.append(observed)

results = dask.compute(*delayed_results)

# turning them all into one data frame 
json_files = [file for file in os.listdir() if file.endswith('.json')]


li = []


for file in json_files:
    with open(file) as json_data:
        data = json.load(json_data)
        df = pd.DataFrame(data['songs'])
        li.append(df)
        
songs = pd.concat(li, axis=0, ignore_index=True)
del data, df, file, json_data, json_files, li


# extracting just the songs
songs = songs[["artist","title", "lyrics"]]

  


