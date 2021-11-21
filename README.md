# Lyric Analysis
Text analysis of songs from five genres (Pop, Hip-Hop, Country, Rock, R&amp;B) to see which references substances the most.


I decided to do something different from numbers this time, and include some Python in the procedure. For this project, I used the genius API to download the songs for 10 different artists from 5 different genres. 

The objective is to do some text analysis in order to determine which genre makes references to drugs/substance use the most. Data collection was done using Python, while lyric extraction and data visualization was done using R. The results are below if you're interested!


## Total words per genre

When all the lyrics were downloaded and filtered, Hip Hop was the genre with the most words, with over 20,000 in comparison to other genres: 

![image](https://user-images.githubusercontent.com/91495866/138732444-a2902f4a-7631-4d72-9c07-7b61dbbb754b.png)

![image](https://user-images.githubusercontent.com/91495866/138732316-2f4cc004-07d1-4b4f-9450-b8a247eda654.png)


## Top words per genre

"Love" and "Yeah" were top words in all genres. 

![image](https://user-images.githubusercontent.com/91495866/138732750-033f8b96-14e0-48f7-a802-8e7b47032d99.png)


I thought it would be cool to see which genre made reference to love the most, so I did just that. By dividing the number of mentiones of the word "love" by the total words in each song, I was able to get percentage values. 

![image](https://user-images.githubusercontent.com/91495866/138733347-dca26725-dba4-4242-bb69-4a65ab924a91.png)

![image](https://user-images.githubusercontent.com/91495866/138733234-6c1126ff-ed68-45f7-a4ed-8a382432232e.png)

R&B makes the most references to love (duh), with Pop in second place. Hip Hop mentions it the least of all genres. 

## Swear words 
"swear words" were words in this list found within the lyrics:  "fuck", "shit", "bitch", "damn", "cunt", "slut", "whore", "ho", "piss", "bollocks" (for the British artists!), "dick", "cock". 

First, I found the most common swear words per genre: 

![image](https://user-images.githubusercontent.com/91495866/138734514-b06ffd16-a8e2-4fc4-b20a-1b87679f24ef.png)


For this category, I expected Hip Hop to be at the top, by a lot (it was). I wasn't too sure what the rest of the rankings would look like for the other genres, and I was a little surprised by the results: 

![image](https://user-images.githubusercontent.com/91495866/138734063-9ca7bd36-3086-4787-9a44-b940a1ac7ee7.png)

**43%** of rap music is swear words! R&B is in second place, with a shocking 36% difference. 

![image](https://user-images.githubusercontent.com/91495866/138734851-d3bc4b4c-1916-435e-87d4-f6addcabeceb.png)

I didn't bother looking through the most common swear words to figure out who would reference them the most - safe to say Hip Hop wins this round. 


## Substance References 

I grouped "Substances" into 7 categories: Marijuana (weed), Alcohol, Heroin, Meth, Pills, Cocaine, Ecstasy (including LSD, shrooms, molly). Hip Hop was in first place in terms of substance mentions, but I was shocked to see what was in second place: 

![image](https://user-images.githubusercontent.com/91495866/138735184-5dce147c-1aca-4032-8a81-2225d3412e01.png)

Country music! I expected Pop/R&B to be in second, but apparently that isn't the case. Of all substances, Alcohol was the most commonly referenced, with Marijuana in 2nd place. 

I decided to compare references to these two substances between groups: 

### Alcohol 
![image](https://user-images.githubusercontent.com/91495866/138735583-159425f9-a6ab-4a90-ac67-35039045ec4b.png)

Country music references alcohol the most! By quite a lot in comparison to the other genres as well. Hip Hop is in second place with this one.


### Marijuana 

![image](https://user-images.githubusercontent.com/91495866/138735824-10bb6eff-74f1-4be6-8bb6-73cc6d681694.png)

Hip Hop references marijuana the most, far more than other genres! 


## Violence
To capture mentions of violence, I gathered words related to aggression (as much as I could think of, present in the code) and filtered each genre for mentions. Hip Hop was once again first in this category, with Pop narrowly beating out Rock for second place. 

![image](https://user-images.githubusercontent.com/91495866/138736512-b3ac33d7-aa83-4364-9c00-56b3da053d38.png)

![image](https://user-images.githubusercontent.com/91495866/138736456-6c9fc4fa-95e9-4bca-ae21-f4f2e33bb24b.png)


## Sentiment Analysis 

Lastly, I thought it would be cool to add a sentiment score to see how the genres stacked up against each other. I expected Hip-Hop to be far in the negatives due to the quantity of violence/substance/swear words present. 

![image](https://user-images.githubusercontent.com/91495866/138736884-85634702-081f-4570-81d8-c8bee14fb2ea.png)


![image](https://user-images.githubusercontent.com/91495866/138736713-0e75c83c-7ff8-4b17-9792-5acc7a617676.png)

As you can see, that is the case! In face, all genres are in the negatives, with the exception of R&B music, which is in the low positives (makes sense because they're talking about love so much). 


I decided to do the same thing, but by artist to see if any were far more negative than others

![image](https://user-images.githubusercontent.com/91495866/138736965-113ff48e-2532-42bb-be91-904550470d4f.png)

### Most negative artists 
1. Eminem 
2. 2Pac
3. Lil Wayne 
4. DMX
5. JAY-Z

### Most positive artists 
1. Whitney Houston
2. Mary J. Blige
3. Celine Dion
4. Stevie Wonder 
5. Janet Jackson




