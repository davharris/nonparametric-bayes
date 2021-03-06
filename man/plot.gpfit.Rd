\name{plot.gpfit}
\alias{plot.gpfit}
\title{Plot a Gaussian Process}
\usage{
  plot.gpfit(gp, true = NULL)
}
\arguments{
  \item{gp}{a gpfit object from \code{\link{gp_fit}}}

  \item{true}{an optional data.frame with columns "x" and
  "y" containing target curve.}
}
\value{
  a ggplot object of the plot
}
\description{
  Plot the mean (line) and 2 standard deviations (ribbon)
}

