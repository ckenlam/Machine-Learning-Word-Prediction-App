library(magrittr)
library(tm)
library(stringr)

unigram<- read.csv("data/unigram_final.csv", stringsAsFactors = FALSE)[,2:3]
bigram<- read.csv("data/bigram_final.csv", stringsAsFactors = FALSE)[,2:3]
trigram<- read.csv("data/trigram_final.csv", stringsAsFactors = FALSE)[,2:3]
quadrigram<- read.csv("data/quadrigram_final.csv", stringsAsFactors = FALSE)[,2:3]
quintagram<- read.csv("data/quintagram_final.csv", stringsAsFactors = FALSE)[,2:3]

myRemovePunctuation <- function(x) {
  # replace everything that isn't alphanumeric, space, ', -, *
  gsub("[^[:alnum:][:space:]'-*]", " ", x)
}

myDashApos <- function(x) {
  x <- gsub("--+", " ", x)
  gsub("(\\w['-*]\\w)|[[:punct:]]", "\\1", x, perl=TRUE)    
}

prediction<- function(sentence) {
  
  allLines <- sentence %>% myRemovePunctuation %>% myDashApos %>% tolower %>% stripWhitespace
  allWords <- unlist(strsplit(allLines, split = " "))
  word_cnt <-length(allWords) 
  final_cand<- data.frame(word = character(), freq = integer(), score = numeric(), stringsAsFactors = FALSE)
  
  if (word_cnt > 3) {
    quin_search_terms <- paste(tail(allWords, 4), collapse = " ")
    quin_cand<- quintagram[grep(paste("^",quin_search_terms," ", sep=""), quintagram$word),]
    input4gram_cnt<- quadrigram[grep(paste("^",quin_search_terms,"$", sep=""), quadrigram$word),2]
    quin_cand$score<- quin_cand$freq/input4gram_cnt
    if (nrow(quin_cand)>0){
      final_cand<- quin_cand
    }
  }
  
  if (word_cnt > 2) {
    quad_search_terms <- paste(tail(allWords, 3), collapse = " ")
    quad_cand<- quadrigram[grep(paste("^",quad_search_terms," ", sep=""), quadrigram$word),]
    input3gram_cnt<- trigram[grep(paste("^",quad_search_terms,"$", sep=""), trigram$word),2]
    quad_cand$score<- quad_cand$freq/input3gram_cnt
    if (nrow(quad_cand)>0){
      final_cand<- quad_cand
    }
  }
  
  if (word_cnt > 1 & nrow(final_cand)<5 ) {
    tri_search_terms  <- paste(tail(allWords, 2), collapse = " ")
    tri_cand <- trigram[grep(paste("^",tri_search_terms," ", sep=""), trigram$word),]
    input2gram_cnt<- bigram[grep(paste("^",tri_search_terms,"$", sep=""), bigram$word),2]
    tri_cand$score<- 0.4*tri_cand$freq/input2gram_cnt
    if (nrow(tri_cand)>0){
      final_cand<- rbind(final_cand,tri_cand)
    }
  }
  
  if (nrow(final_cand)<5) {
    bi_search_terms   <- paste(tail(allWords, 1), collapse = " ")
    bi_cand  <- bigram[grep(paste("^",bi_search_terms," ", sep=""), bigram$word),]
    input1gram_cnt<- unigram[unigram$word == bi_search_terms,2]
    input1gram_cnt_alt<- sum(bigram[grep(paste("^",bi_search_terms," ", sep=""),bigram$word),2])
    if(length(input1gram_cnt)>0){
      bi_cand$score<- 0.4*0.4*bi_cand$freq/input1gram_cnt
    } else{
      bi_cand$score<- 0.4*0.4*bi_cand$freq/input1gram_cnt_alt  
    }
    if (nrow(bi_cand)>0){
      final_cand<- rbind(final_cand,bi_cand)
    }
  }
  
  if (nrow(final_cand)<5) {
    uni_cand  <- unigram[order(unigram$freq,decreasing=TRUE)[1:(5-nrow(final_cand))],]
    uni_cand$score<- 0.4*0.4*0.4*uni_cand$freq/sum(unigram$freq)
    final_cand<- rbind(final_cand,uni_cand)
  }
  
  final_cand$next_candidate <- word(final_cand$word,-1)
  final_cand<- aggregate(score ~ next_candidate, data = final_cand, max) 
  #final_cand[order(final_cand$score,decreasing=TRUE)[1:5], ]
  
  return(final_cand[order(final_cand$score,decreasing=TRUE)[1:5], ])
}


