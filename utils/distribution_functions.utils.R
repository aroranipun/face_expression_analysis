#NOtes---------------------------
# 1.get_dist_stats
#---- Add gettings tstas for normal and exponential distribution
#---- 

library(fitdistrplus)
library(spatialEco)

#Distribution functions--------------------------
get_dist_stats <- function(fit.dist){
  stats = list()
  X = seq(0,1,length.out = 10000)
  
  stats$time_series_phat = fit.dist$estimate
  
  stats$time_series_ci <- rbind(fit.dist$estimate + 1.96*fit.dist$sd,
                                fit.dist$estimate - 1.96*fit.dist$sd)
  
  #Get parameters-------------------------
  e1 = as.numeric( stats$time_series_phat[1])
  e2 = as.numeric( stats$time_series_phat[2])
  
  #
  if(fit.dist$distname=="gamma"){
    
    stats$time_series_mean <-e1/e2
    stats$time_series_var <- e1/(e2^2)
    stats$sk <- 2/sqrt(e1)
    stats$kt <- 6/e1
    stats$dist_Y = dgamma(x = X,shape = e1, rate = e2)
    
  }else if(fit.dist$distname=="lnorm"){
    stats$time_series_mean <- exp(e1 + e2^2/2)
    stats$time_series_var <- (exp(e2^2)-1) * exp(2*e1+e2^2)
    stats$sk <- (exp(e2^2)+2) * sqrt((exp(e2^2)-1))
    stats$kt <- exp(4*e2^2) + 2*exp(3*e2^2) + 3*exp(2*e2^2)-6
    stats$dist_Y = dlnorm(x = X,meanlog = e1,sdlog = e2)
  }
  return(stats)
}
dist_best <-  function(ts, distr = c("gamma", "lnorm", "exp", "norm"), plot =F, sep_dist = F) {
  require(fitdistrplus)
  require(gridExtra)
  fits = list()
  ll = c()
    for (i in distr) {
      fit = fitdist(data = ts, distr = i)
      ll = append(ll, fit$loglik)
      fits[[i]] <- fit$estimate
    }

    
    ll = round(ll, 2)
    names(ll) = distr
    
    ll_sorted = sort(ll, decreasing = T)
    
    ll = append(ll, c(
      max_ll = names(ll_sorted[1]),
      sec_max_ll = names(ll_sorted[2]),
      diff = as.numeric(round(ll_sorted[1] / ll_sorted[2], 2))
      )
    )
    d_shift = mean(ts)
    
    #if plotting needed
    plt = list()
    if(plot){
      if(sep_dist) d_shift = .1*d_shift else d_shift = 0
      datf = data.frame(org = ts,
                       gamma = d_shift + rgamma(n = length(ts),shape = fits$gamma[[1]],rate = fits$gamma[[2]]),
                       norm = 2*d_shift + rnorm(n = length(ts),mean = fits$norm[[1]],sd = fits$norm[[2]]),
                       lnorm = 3*d_shift + rlnorm(n = length(ts),meanlog =  fits$lnorm[[1]],sdlog =  fits$lnorm[[2]]),
                       exp = 4*d_shift + rexp(n = length(ts),rate =   fits$exp[[1]]) 
      )
      datf <- datf %>% gather() %>% group_by(key)
      
      bw = .01
      
      plot = ggplot(datf) + 
        geom_density(mapping = aes(x = value, fill = key),
                     alpha = 0.2,
                     show.legend = T)
      
      build = ggplot_build(plot)
      xmean = mean(build$layout$panel_scales_x[[1]]$range$range)
      ymax = build$layout$panel_scales_y[[1]]$range$range[2]
       
      plt = plot + annotation_custom(tableGrob(t(data.frame(ll_sorted))),ymin = ymax-.1*ymax )

      }
    return(list(ll,plt))
}