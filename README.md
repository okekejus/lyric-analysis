# Lyric Analysis
Text analysis of songs from five genres (Pop, Hip-Hop, Country, Rock, R&amp;B) to see which references substances the most.


I decided to do something different from numnbers this time, and include some Python in the procedure. For this project, I used the genius API to download the songs for 10 different artists from 5 different genres. 

The objective is to do some text analysis in order to determine which genre makes references to drugs/substance use the most. Data collection was done using Python, while lyric extraction and data visualization was done using R. The results are below if you're interested!


## Total words per genre

When all the lyrics were downloaded and filtered, Hip Hop was the genre with the most words, with over 20,000 in comparison to other genres: 

![image](https://user-images.githubusercontent.com/91495866/138732444-a2902f4a-7631-4d72-9c07-7b61dbbb754b.png)

![image](https://user-images.githubusercontent.com/91495866/138732316-2f4cc004-07d1-4b4f-9450-b8a247eda654.png)


## Top words per genre

"Love" and "Yeah" were top words in all genres. 

![image](https://user-images.githubusercontent.com/91495866/138732750-033f8b96-14e0-48f7-a802-8e7b47032d99.png)


I thought it would be cool to see which genre made reference to love the most, so I did just that. By dividing the number of mentiones of the word "love" by the total words in each song, I was able to get percentage values. 

![image](https://user-images.githubusercontent.com/91495866/138732953-5e8c701e-2682-404c-a7d0-feff8e1d5273.png)

R&B makes the most references to love (duh), with Pop in second place. Hip Hop mentions it the least of all genres. 


