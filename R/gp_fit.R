#' gp_fit fits a Gaussian process to the observed data
#' 
#' API not yet stable! Arguments to this function will probably be updated to be much more generic
#' @param obs a data frame of observations with columns obs$x and obs$y
#' @param X the desired points over which to predict
#' @param pars a named numeric specifying "sigma_n" for the (additive) and "l" for the covariance length scale
#' @return a list with items "mu", the expected Y values at X (mean of the posterior Gaussian process), 
#' Sigma, the covariance matrix for the posterior Gaussian process, and 
#' "loglik", the log likelihood of observering the given data under the process, marginalized over the prior
#' @details so far treates the prior as mean 0 and covariance given by cov(X)
#' @export
#' @examples 
#' X <- seq(-5,5,len=50)
#' obs <- data.frame(x = c(-4, -3, -1,  0,  2),
#'                   y = c(-2,  0,  1,  2, -1))
#' gp <- gp_fit(obs, X, c(sigma_n=0.8, l=1))
#' 
#' df <- data.frame(x=X, y=gp$mu, ymin=(gp$mu-2*sqrt((gp$var))), ymax=(gp$mu+2*sqrt((gp$var))))
#' require(ggplot2)
#' ggplot(df)  + geom_ribbon(aes(x,y,ymin=ymin,ymax=ymax), fill="gray80") + geom_line(aes(x,y)) + geom_point(data=obs, aes(x,y))

gp_fit <- function(obs, X, pars=c(sigma_n=1, l=1)){
  
  sigma_n <- pars["sigma_n"]
  l <- pars["l"]
  
  ## Parameterization-specific
  SE <- function(Xi,Xj, l) exp(-0.5 * (Xi - Xj) ^ 2 / l ^ 2)
  cov <- function(X, Y) outer(X, Y, SE, l) 
   
  
  n <- length(obs$x)
  K <- cov(obs$x, obs$x)
  I <-  diag(1, n)
  
  
  ## Cholksy method -- Consider implementing in C
  L <- chol(K + sigma_n ^ 2 * I)
  alpha <- solve(t(L), solve(L, obs$y))
  loglik <- -.5 * t(obs$y) %*% alpha - sum(log(diag(L))) - n * log(2 * pi) / 2
  tmp <- lapply(X, function(x_i){  ## Must be a clever way to vectorize this...
    k_star <- cov(obs$x, x_i)
    Y <- t(k_star) %*% alpha
    v <- solve(L, k_star)
    Var <- cov(x_i,x_i) - t(v) %*% v
    list(Y=Y, Var=Var)
  })
  mu <- sapply(tmp,`[[`, "Y")
  var <- sapply(tmp,`[[`, "Var")
  
  ## Direct method 
  cov_xx_inv <- solve(K + sigma_n ^ 2 * I)
  Ef <- cov(X, obs$x) %*% cov_xx_inv %*% obs$y
  Cf <- cov(X, X) - cov(X, obs$x)  %*% cov_xx_inv %*% cov(obs$x, X)
  llik <- -.5 * t(obs$y) %*% cov_xx_inv %*% obs$y - 0.5 * log(det(cov_xx_inv)) - n * log(2 * pi) / 2
  
  out <- list(mu = mu, var = var, loglik=loglik, Ef = Ef, Cf = Cf, llik = llik)
  class(out) = "gp"
  out
  }



