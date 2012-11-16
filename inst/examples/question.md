




To provide a minimal working example for comparison: If I were to do this manually (following [Rasmussen & Williams (2006)](http://www.GaussianProcess.org/gpml) Chapter 2), I would do:


Consider we have the observed `x,y` points and `x` values where we desire predicted `y` values:


```r
obs <- data.frame(x = c(-4, -3, -1,  0,  2),
                  y = c(-2,  0,  1,  2, -1))
x_predict <- seq(-5,5,len=50)
```



Use a radial basis kernel:


```r
SE <- function(Xi,Xj, l=1) exp(-0.5 * (Xi - Xj) ^ 2 / l ^ 2)
cov <- function(X, Y) outer(X, Y, SE)
```


Calculate mean and variance: 


```r
sigma.n <- 0.3
cov_xx_inv <- solve(cov(obs$x, obs$x) + sigma.n^2 * diag(1, length(obs$x)))
Ef <- cov(x_predict, obs$x) %*% cov_xx_inv %*% obs$y
Cf <- cov(x_predict, x_predict) - cov(x_predict, obs$x)  %*% cov_xx_inv %*% cov(obs$x, x_predict)
```



## kernlab

I think I see how I get the equivalent expected values in kernlab:


```r
library(kernlab)
gp <- gausspr(obs$x, obs$y, kernel="rbfdot", kpar=list(sigma=1/(2*l^2)), fit=FALSE, scaled=FALSE, var=0.8)
Ef_kernlab <- predict(gp, x_predict)
```


but I don't see how I get the associated covariances?  Perhaps I have missed something in the documentation?  


There are many cases where it would be nice to have access to the resulting Gaussian process, such as in generating plots as in Rasmussen and Williams:


```r
require(ggplot2)
dat <- data.frame(x=x_predict, y=(Ef), ymin=(Ef-2*sqrt(diag(Cf))), ymax=(Ef+2*sqrt(diag(Cf))))    
ggplot(dat) +
  geom_ribbon(aes(x=x,y=y, ymin=ymin, ymax=ymax), fill="grey80") + # Var
  geom_line(aes(x=x,y=y), size=1) + #MEAN
  geom_point(data=obs,aes(x=x,y=y)) +  #OBSERVED DATA
  scale_y_continuous(lim=c(-3,3), name="output, f(x)") + xlab("input, x") 
```

![plot of chunk unnamed-chunk-6](http://carlboettiger.info/assets/figures/2012-11-15-28b3256dfe-unnamed-chunk-6.png) 






