GetCrantastic <- function() {
  since <- file.info("~/.Rapp.history")$ctime
  if(is.null(since))
  	since <- Sys.date - 7

  crantastic <- getFeed("http://feeds.feedburner.com/LatestActivityOnCrantastic")

  toPrint <-"\nCrantastic updates since your last use of R:\n"
  printed <- 0
  for(i in 1:length(crantastic$items)) {
  	if(crantastic$items[[i]]$pubDate > since & !is.null(crantastic$items[[i]]$title)) {
  		toPrint <- paste(toPrint, crantastic$items[[i]]$title, "\n")
  		printed <- printed +1
  	}
  }
  if(printed==0) 
  	toPrint <- paste(toPrint, "No new updates\n")
  cat(toPrint)	
}
.GetCrantastic()
