---
title: "Untitled"
output: github_document
---

## About this Word Prediction App

So this is it: the Data Science Specialization SwiftKey Capstone Project. This is the final step that marks the completion of my journey with John Hopkins University's Data Science Coursera Specialization.   

![image of the app](https://github.com/ckenlam/Word-Prediction-App/blob/master/app%20image.jpeg?raw=true)

As the name suggests, the [Word Prediction App](https://kenlam.shinyapps.io/capstone_project/) predicts the next word that completes an user's input message by providing 5 potential words to choose from. The training data that forms the basis of this application can be downloaded from [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). The algorithm of the application is based on the Stupid Backoff smoothing model, which is relatively inexpensive to calculate in a distributed environment while approaching the quality of Kneser-Ney smoothing for large amounts of data.


### Reference
“Large language models in machine translation” by T. Brants et al, in EMNLP/CoNLL 2007 @ http://www.aclweb.org/anthology/D07-1090.pdf



