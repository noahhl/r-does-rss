\name{getFeed}
\alias{getFeed}
\title{Get RSS/Atom feed data}
\description{Get data contained in an RSS or Atom feed. Supports the use of basic 
  HTTP authentication (username:password) and returns a named list with two items: a header and a 
  list of items. The contents of the items may vary based on specification used (RSS vs Atom as well
  as specific generator used to create the feed). }
\usage{getFeed(feed, auth=NULL)}
\arguments{
  \item{feed}{the path to the feed, beginning with http://, https://, or feed://. Alternately, the prefix may be ommitted}
  \item{auth}{an authentication string for basic HTTP authentication, in the format of username:password}
}
\seealso{}
\examples{
  getFeed("http://feeds.feedburner.com/LatestActivityOnCrantastic")
}