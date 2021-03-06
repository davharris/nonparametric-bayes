\name{par_est}
\alias{par_est}
\title{MLE estimate of parameters given by function f}
\usage{
  par_est(obs, init = c(r = 1.5, K = mean(obs$x), s = 1))
}
\arguments{
  \item{obs}{the observed data, two columns giving x_t,
  x_t+1 respectively}
}
\value{
  a list with the f given, the MLE estimated parameters,
  and estimated noise level
}
\description{
  MLE estimate of parameters given by function f
}

