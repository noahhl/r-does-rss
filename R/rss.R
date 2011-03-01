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
  results$items <- lapply(results$items, AtomToRSS)
  names(results$items) <- rep("item", length(results$items))
  return(results)
}

parseRSS <- function(content) {
  channel <- xmlToList(content$children$rss[['channel']])
  results <- list()
  results$header <- channel[names(channel) != "item"]
  results$items <- channel[names(channel) == "item"]
  results$items <- lapply(results$items, cleanRSS)
  names(results$items) <- rep("item", length(results$items))
  return(results)

}

AtomToRSS <- function(atom) {
  item <- list()
  item$title <- atom$title
  item$creator <-   atom$author
  item$description <- atom$summary
  item$link <- atom$origlink
  for (i in atom[grep("link", names(atom))]) {
    if (i["rel"] == "replies")
      item$comments <-i["href"]
  }
  for (i in atom[grep("category", names(atom))]) {
      item$categories <- paste(item$categories, i['term'], sep =";")
  }
  item$categories <- sub(";", "", item$categories)
  item$guid <- atom$id
  item$pubDate <- as.POSIXlt(atom$published)
  item$source <-  atom$content$.attrs['base']
  return(item)
}

cleanRSS <- function(rss) {
  tryCatch(rss$pubDate <- as.POSIXlt(rss$pubDate), error=function(e) {rss$pubDate <<- as.POSIXlt(rss$pubDate,format="%a, %d %b %Y %H:%M:%S")})
  rss$link <- rss$origLink
return(rss)
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
