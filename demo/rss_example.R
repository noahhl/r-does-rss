since <- file.info("~/.Rapp.history")$ctime
if(is.null(since))
	since <- Sys.date - 7

crantastic <- getFeed("http://feeds.feedburner.com/LatestActivityOnCrantastic")

toPrint <-"\nCrantastic updates since your last use of R:\n"
printed <- 0
for(i in 1:length(crantastic$items)) {
	if(crantastic$items[[i]]$published > since & !is.null(crantastic$items[[i]]$title)) {
		toPrint <- paste(toPrint, crantastic$items[[i]]$title, "\n")
		printed <- printed +1
	}
}
if(printed==0) 
	toPrint <- paste(toPrint, "No new updates\n")
cat(toPrint)	

since <- file.info("~/.Rapp.history")$ctime
if(is.null(since))
	since <- Sys.date - 7
rbloggers <- getFeed("feed://www.r-bloggers.com/feed/")

toPrint <-"\nR-bloggers updates since your last use of R:\n"
printed <- 0
for(i in 1:length(rbloggers$items)) {
	if(as.POSIXlt(rbloggers$items[[1]]$pubDate, format="%a, %d %b %Y %H:%M:%S") > since & !is.null(rbloggers$items[[i]]$title)) {
		toPrint <- paste(toPrint, rbloggers$items[[i]]$title, "\n")
		printed <- printed +1
	}
}
if(printed==0) 
	toPrint <- paste(toPrint, "No new updates\n")
cat(toPrint)	