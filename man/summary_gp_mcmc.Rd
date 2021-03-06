\name{summary_gp_mcmc}
\alias{summary_gp_mcmc}
\title{Summary plots showing the trace and posteriors for the gp_mcmc estimates}
\usage{
  summary_gp_mcmc(gp, burnin = 0, thin = 1)
}
\arguments{
  \item{gp}{a fit of the gaussian process from gp_mcmc}

  \item{burnin}{length of sequence to discard as a
  transient}

  \item{thin}{frequency of sub-sampling (make posterior
  distribution smaller if necessary)}
}
\value{
  two ggplot2 objects, one plotting the trace and one
  plotting the posteriors in black with priors overlaid in
  red.
}
\description{
  Summary plots showing the trace and posteriors for the
  gp_mcmc estimates
}

