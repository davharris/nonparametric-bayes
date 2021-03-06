\name{plot_policies}
\alias{plot_policies}
\title{policy plot}
\usage{
  plot_policies(x_grid, gpD, estD, trueD, altD)
}
\arguments{
  \item{x_grid}{stock grid}

  \item{gpD}{gaussian process policy}

  \item{estD}{an estimated policy (e.g. parametric
  uncertainty only)}

  \item{trueD}{the true optimal policy}

  \item{altD}{an alternative (structurally incorrect)
  policy}
}
\value{
  the policy plot
}
\description{
  policy plot
}

