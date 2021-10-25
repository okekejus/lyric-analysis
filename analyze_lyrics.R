# Analyzing Lyrics 
library(pacman)
p_load(tidyverse, # data manipulation and visualization
       tidytext, # working with text data w/ tidy rules
       textdata, 
       ggthemes) # framework for mining text 


# Reading in text -----------------------------------------------------------------------------
song.list <- read_csv("data/song.list.csv") %>%
  select(-c(1))# csv

which_na <- function(x) {
  which(is.na(x))
} # finding missing vals 
 
song.list$artist[c(which_na(song.list$genre))] = "Guns N' Roses" # need to relabel - gets messed up during read 
song.list$genre[song.list$artist == "Guns N' Roses"] = "Rock"

which_na(song.list$genre)

# text is based on lines of lyrics, not words.

song.list <- song.list %>%
  unnest_tokens(word, lyrics) %>%
  drop_na(word) # tokenization + drop missing rows 


# First time I did this I noticed something - "nigga" and "niggas" were counted as separate words, and 
# both appeared in the top 6 for Hip Hop. I'll combine them into one word to make room for another word 
# (and more accurate analysis)

song.list$word[song.list$word == "nigga"]
song.list$word[song.list$word == "niggas"] = "nigga"

song.list <- song.list %>%
  anti_join(stop_words) # remove stop words

# Count ---------------------------------------------------------------------------------------------------------------------
# First, we'll examine the most common words in each genre 

word.count <- song.list %>%
  group_by(genre) %>%
  count(word, sort = TRUE)

total.words <- word.count %>%
  tally()

total.words %>%
  select(genre, n)

# easier to view as a graph 
word.count %>%
  tally() %>% # counts rows per group - each row is a word. 
  ggplot(aes(genre, n)) + 
  geom_col(fill = "#FCF3F0", color = "black") + 
  labs(title = "Total words per genre", 
       x = "Genre",  
       y = "Words") +
  theme_hc()


# Top words per genre 
genres <- c("Pop", "Hip Hop", "Country", "R&B", "Rock")

output <- vector("list", length = length(genres))

for (g in genres) {
 
  count.plot <- word.count %>%
    filter(genre == g) %>%
    arrange(desc(n)) %>%
    head() %>%
    ggplot(aes(n, word)) +
    geom_col(fill = "#C5D4EB", color = "black") + 
    labs(title = str_glue("Top six words in {g}"),  
         x = "Word", 
         y = "Count") + 
    theme_hc()

  output[[g]] <- count.plot
  
}


top.six.plot <- gridExtra::grid.arrange(output$Pop, output$`Hip Hop`, 
                                        output$Country, output$`R&B`, 
                                        output$Rock, nrow = 3)




# Love ----------------------------------------------------------------------------------------------------------------------


love.count <- word.count %>%
  group_by(genre) %>%
  filter(word == "love") %>%
  rename(love = n) %>%
  select(genre, love)

total.words <- left_join(total.words, love.count)

total.words %>%
  mutate(love.percent = (love/n) * 100) %>% 
  ggplot(aes(genre, love.percent)) +
  geom_col(fill = "#EDCCDC", color = "black") + 
  theme_hc() + 
  labs(title = "Love mentions by genre", 
       x = "Genre", 
       y = "Percentage")

total.words <- left_join(total.words, love.count)
remove(love.count)

total.words %>%
  mutate(love.percent = (love/n) * 100) %>%
  select(genre, love.percent)

# Swear Words ---------------------------------------------------------------------------------------------------------------

swears <- c("fuck", "shit", "bitch", "damn", "cunt", "slut", "whore", "ho", "piss", "bollocks", 
            "dick", "cock")


swear.count <- word.count %>%
  filter(word %in% swears)

swear.count.sum <- swear.count %>%
  group_by(genre) %>%
  mutate(swear = sum(n)) %>%
  select(genre, swear) %>%
  distinct()
  
total.words <- left_join(total.words, swear.count.sum)  

total.words %>%
  mutate(swear.percent =(swear/n) * 100) %>%
  select(genre, swear.percent)

output <- vector("list", length = length(genres))

for (g in genres) {
  
  count.plot <- swear.count %>%
    filter(genre == g) %>%
    arrange(desc(n)) %>%
    head() %>%
    ggplot(aes(n, word)) +
    geom_col(fill = "#B2C0BE", color = "black") + 
    labs(title = str_glue("Top swear words in {g}"),  
         x = "Count", 
         y = "Word") + 
    theme_hc()
  
  output[[g]] <- count.plot
  
}


top.swear.plot <- gridExtra::grid.arrange(output$Pop, output$`Hip Hop`, 
                                        output$Country, output$`R&B`, 
                                        output$Rock, nrow = 3)



total.words %>%
  mutate(swear.percent = (swear/n) * 100) %>% 
  ggplot(aes(genre, swear.percent)) +
  geom_col(fill = "#B2C0BE", color = "black") + 
  theme_hc() +
  labs(title = "Use of swear words by genre", 
       x = "Genre", 
       y = "Percentage")


# Substances ----------------------------------------------------------------------------------------------------------------
drug.count <- function(a) {
  word.count %>%
    filter(word %in% a) %>%
    group_by(genre) %>%
    mutate(drug = sum(n)) %>%
    select(genre, drug) %>%
    distinct()
}


# Weed 
weed <- c("weed", "kush", "joint", "blunt", "spliff", "mary jane", "marijuana", "pot")
weed.count <- drug.count(weed) %>%
  rename(weed = drug)


total.words <- left_join(total.words, weed.count)

remove(weed.count)

# Alcohol 
alcohol <- c("vodka", "tequila", "rum", "gin", "champagne", "d'usse", "liquor", 
             "bubbly", "drunk", "drink", "bottles")

alcohol.count <- drug.count(alcohol) %>%
  rename(alcohol = drug)

total.words <- left_join(total.words, alcohol.count)

remove(alcohol.count)

# Heroin 
heroin <- c("heroin", "dope", "skag")

heroin.count <- drug.count(heroin) %>%
  rename(heroin = drug)

total.words <- left_join(total.words, heroin.count)
remove(heroin.count)

# Meth 
meth <- c("meth", "methamphetamine", "crank", "chalk", "pookie", "crystal")

meth.count <- drug.count(meth) %>%
  rename(meth = drug)

total.words <- left_join(total.words, meth.count)

remove(meth.count)

# Pills 
pills <- c("pills", "benzo", "addy", "adderall", "oxy", "oxycontin", "painkiller", "painkillers", "pill")
pill.count <- drug.count(pills) %>%
  rename(pills = drug)

total.words <- left_join(total.words, pill.count)
remove(pill.count)


# Cocaine 
cocaine <- c("cocaine", "crack", "coke", "snort", "speedball")
cocaine.count <- drug.count(cocaine) %>%
  rename(cocaine = drug)

total.words <- left_join(total.words, cocaine.count)

remove(cocaine.count)

# Ecstasy 
ecstasy <- c("molly", "mdma", "lsd", "shrooms", "mushrooms")
ecstasy.count <- drug.count(ecstasy) %>%
  rename(ecstasy = drug)

total.words <- left_join(total.words, ecstasy.count)


total.words <- total.words %>%
  mutate(drugs = weed + alcohol + heroin + meth + pills + cocaine + ecstasy)

remove(ecstasy.count)

Mentions 

total.words %>%
  mutate(drug.percent = (drugs/n) * 100) %>%
  ggplot(aes(genre, drug.percent)) + 
  geom_col(fill = "#B7CC98", color = "black") + 
  theme_hc() + 
  labs(title = "Drug mentions by genre", 
       x = "Genre", 
       y = "Total Mentions (%)")
 
 total.words %>%
   mutate(alc.percent = (alcohol/n) * 100) %>%
   ggplot(aes(genre, alc.percent)) + 
   geom_col(fill = "#957DAD", color = "black") + 
   theme_hc() + 
   labs(title = "Alcohol mentions by genre", 
        x = "Genre", 
        y = "Total Mentions (%)")
 
 
 total.words %>%
   mutate(wd.percent = (weed/n) * 100) %>%
   ggplot(aes(genre, wd.percent)) + 
   geom_col(fill = "#B7CC98", color = "black") + 
   theme_hc() + 
   labs(title = "Alcohol mentions by genre", 
        x = "Genre", 
        y = "Total Mentions (%)")


# Violence ------------------------------------------------------------------------------------------------------------------

violence <- c("gun", "shoot", "stab", "kill", "beat", "fist", "fight", "war", "battle", "damage", "guns", "kills", 
              "kick", "rage", "violent", "attack", "jail", "shank")

violence.count <- drug.count(violence) %>%
  rename(violence = drug)

total.words <- left_join(total.words, violence.count)


total.words %>%
  mutate(viol.percent = (violence/n) *100 ) %>%
  select(genre, viol.percent) %>%
  ggplot(aes(x = genre, y = viol.percent)) + 
  geom_col(fill = "#ff6961", color = "black") + 
  theme_hc() + 
  labs(title = "References to violence by genre", 
       y = "Percentage", 
       x = "Genre")

remove(violence.count)

# Sentiment Analysis -----------------------------------------------------------------------------------------------------------------

# First by artist 
artist.sentiment <- song.list %>%
  group_by(artist) %>%
  inner_join(get_sentiments("bing")) %>%
  count(artist, word, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  group_by(artist) %>%
  summarise(score = sum(sentiment))


artist.sentiment$artist[c(5, 12, 23)] = c("Beyoncé", "Céline Dion", "Guns N' Roses")

  
artist.list <- read_csv("data/Artist_List.csv") %>%
  select(-c(1))

artist.list$artist_name[c(5, 11, 20)] = c("Beyoncé", "Céline Dion", "Guns N' Roses")

additions <- tibble(artist_name = c("Doja Cat", "The Beatles", "Sade", "Blake Shelton", "Bruce Springsteen"), 
                    genre = c("Hip Hop", "Rock", "R&B", "Country", "Rock"), 
                    artist_id = c(NA, NA, NA, NA, NA), 
                    artist_url = c(NA, NA, NA, NA, NA)) # not in the original list


artist.list <- rbind(artist.list, additions) %>%
  select(artist_name, genre) %>%
  rename(artist = artist_name)


artist.sentiment <- left_join(artist.sentiment, artist.list)

genre.sentiment <- artist.sentiment %>%
  group_by(genre) %>%
  summarise(genre_score = sum(score))

genre.sentiment %>%
  ggplot(aes(genre, genre_score)) + 
  geom_col(fill = "#FDFD96", color = "black") + 
  theme_hc() + 
  labs(title = "Sentiment scores for each genre", 
       x = "Genre", 
       y = "Sentiment Score")

artist.sentiment %>%
  ggplot(aes(score, artist)) + 
  geom_col(fill = "#D6CDB9", color = "black") + 
  theme_hc() + 
  labs(title = "Sentiment scores per artist", 
       x = "Sentiment Score", 
       y = "Artist")

