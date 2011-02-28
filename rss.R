library(RCurl)
library(XML)

getFeed <- function(feed, auth=NULL) {
  feed <- cleanFeedURL(feed)
  opts <- curlOptions()

  if(!is.null(auth))
    opts <- curlOptions(userpwd = auth)

  content <- xmlTreeParse(getURL(feed, .opts=opts))$doc

  if(!is.null(names(content$children$rss))) {
    results <- parseRSS(content)
  } else if (!is.null(names(content$children$feed))) {
    results <- parseAtom(content)
  }
  return(results)
}


parseAtom <- function(content) {
  results <- list()
  results$header <- lapply(content$children$feed[names(content$children$feed) != "entry"], xmlToList)
  results$items <- lapply(content$children$feed[names(content$children$feed) == "entry"], xmlToList)
  return(results)
}

parseRSS <- function(content) {
  channel <- xmlToList(content$children$rss[['channel']])
  results <- list()
  results$header <- channel[names(channel) != "item"]
  results$items <- channel[names(channel) == "item"]

  return(results)

}


cleanFeedURL <- function(feed) {
    if(!grepl("http://|https://", feed)) {
      if(grepl("://", feed)) {
        feed <- strsplit(feed, "://")[[1]][2]
      }
      feed <- paste("http://", feed, sep="")
    }    
    return(feed)
}