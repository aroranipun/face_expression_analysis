#NOtes---------------------------
# 1.get_dist_stats
#---- Add gettings tstas for normal and exponential distribution
#---- 
library(raster)
library (pracma)
library(fitdistrplus)
library(spatialEco)
library(dplyr)
library(tidyr)
library(fitdistrplus)
library(gridExtra)
Build_Record_Amplitude <- function(time_series,dist_ts = "gamma", dist_mm= "gamma",valleys = F) {
  
  #handle -ve and 0 values
  if(min(time_series)<0) time_series = time_series - min(time_series)
  
  #This function takes time series and X vector of data range to build the PDF
  #and outputs full stochastic record with Gamma estimates, confidence inter and Gamma moments the record in in relation to the peak amplitude
  
  record <- list()
  
  record$time_series = time_series
  if(valleys){
    record$time_series = -time_series - min(-time_series)
  }
  
  #Peaks---------------------
  peaks = data.frame(findpeaks(x = record$time_series ,zero = '0',nups = 0, ndowns =1))
  record$peaks = peaks$X1
  record$peak_locs = peaks$X2
  
  # statistics for distribution of peaks----------
  set.seed(2013)
  
  db = dist_best(ts = record$peaks)
  record$time_series_bd = db[[1]]["max_ll"]
  
  fit.dist <- fitdist(data = record$peaks, distr = dist_ts, method = "mle",)
  dist_stats <- get_dist_stats(fit.dist)
  
  #Get stats for distribution
  record$time_series_phat <- dist_stats$time_series_phat
  record$time_series_ci <- dist_stats$time_series_ci
  record$time_series_mean <- dist_stats$time_series_mean
  record$time_series_var <- dist_stats$time_series_var
  
  record$mean_shifted <- abs(record$time_series - record$time_series_mean)
  
  mean_shifted_max <- findpeaks(record$mean_shifted, zero = '0', nups = 0, ndowns =0)
  mean_shifted_min <- findpeaks(-record$mean_shifted, zero = '0', nups = 0 ,ndowns = 0)
  
 # plot_peaks(record$mean_shifted)
  
  min_index <- mean_shifted_min[,2]
  min_value <- -mean_shifted_min[,1]
  max_index <- mean_shifted_max[,2]
  max_value <- mean_shifted_max[,1]
  
  #Get micro movements-------------------------------------------------
  micro_moves <- get_micro_mov(min_index =min_index , 
                               max_index = max_index ,
                               max_value = max_value,
                               time_series =record$mean_shifted )
  
  record$micro_moves <- micro_moves$norm_max_value
  record$max_index <- micro_moves$n_max_index
  
  db = dist_best(ts = record$micro_moves,distr = ,plot = ,sep_dist = )
  record$bd = db[[1]]["max_ll"]
  record$bd_2 = db[[1]]["sec_max_ll"]
  record$bd_diff = db[[1]]["diff"]
  
  fit.dist <- fitdist(data = record$micro_moves, distr = dist_mm, method = "mle",)
  dist_stats <- get_dist_stats(fit.dist)
  
  #Get stats for distribution
  record$phat = dist_stats$time_series_phat
  record$mean <- dist_stats$time_series_mean
  record$var <- dist_stats$time_series_var
  record$ci <- dist_stats$time_series_ci
  
  record$sk <- dist_stats$sk
  record$kt <- dist_stats$kt
  record$dist_Y =dist_stats$dist_Y
  
  record$micromov_full[record$max_index] <- record$micro_moves

  return(record)
}

get_micro_mov <- function(min_index, max_index, max_value, time_series){
  
  # Normalize_Max_Vel_Value 
  #time_series = input the raw data time series with peaks and valleys 
  #(e.g. speed recorded continuosly, IMU accel data, etc)
  # min_index, max_index = enter the values of the peaks and the indexes of the
  # outputs the series of averaged speed values between local minima surrounding a local maxima
  # and the scaled fluctuations in peak amplitude, as normalized
  
  
  # Check the first values using MinIndex as a guide-----------------
  #always ensure that the series starts and ends with a local minima
  
  if (max_index[1] < min_index[1]) {
    #max is  shifted to the left
    max_index = max_index[-1]
    max_value = max_value[-1]
  }
  if (length(max_index) > length(min_index)) {
    #max is  shifted to the left
    max_index = max_index[-length(max_index)]
    max_value = max_value[-length(max_index)]
  }
  
  avg_values = n_max_index = norm_max_value=  c()
  loop_length = min(length(max_index),length(min_index))-1
  
  for(i in 1:loop_length){
    
    segment = time_series[min_index[i]:min_index[i+1]]
    
    avg_values = append(avg_values,mean(segment))
    
    n_max_index = append(n_max_index,max_index[i])
    
    norm_value = max_value[i]/(max_value[i]+avg_values[i])
    norm_max_value = append(norm_max_value,norm_value)
  }
  micro_move= list(avg_values= avg_values,
                   n_max_index= n_max_index,
                   norm_max_value= norm_max_value)
}

plot_peaks <- function(ts,cex=1){

  peaks = data.frame(findpeaks(x = ts,zero = '0',nups = 1,ndowns = 0))
  valleys = data.frame(findpeaks(x = -ts,zero = '0',nups = 0,ndowns = 1))
  
  plot(ts,type = 'l',)
  points(y = ts, x = seq(1:length(ts)),pch=1,col='black',cex=cex)
  points(y = peaks$X1, x = peaks$X2,pch=1,col='red',cex=cex)
  points(y = -valleys$X1, x = valleys$X2,pch=1,col='yellow',cex=cex)
}

angle <- function(a, b) {
  a = a / sqrt(sum(a^2))
  b = b / sqrt(sum(b^2))
  theta <- acos(sum(a * b) / (sqrt(sum(a * a)) * sqrt(sum(b * b))))
  return(theta)
}

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


get_parameters = function(list_of_data,mappings){
  
  mapped_data = re_process_data(list_of_data,mappings)
  list_of_speeds = get_speed(mapped_data)
  #lisp = list_of_speeds_processed
  lisp = speed_combine(list_of_speeds=list_of_speeds, type = "concatenate")
  
  mat = matrix(data = NA,nrow = length(lisp),ncol = 7)
  
  for( i in 1: length(lisp)){
    mat[i,1] = names(lisp[i])
    record = Build_Record_Amplitude(lisp[[i]])
    mat[i,c(2:7)] = c(record$phat,
                      sk=record$sk,
                      mu=record$mean,
                      kt=record$kt,
                      sd = sqrt(record$var)
    )
  }
  df = data.frame(mat)
  colnames(df)<-c("Location","shape","scale","skew","mu","kt","sd") # be sure to match it with above matrix
  num_cols = c( "shape","scale","skew","mu","kt","sd")
  df <- df %>% 
    mutate(across(num_cols, as.numeric))
  
  # df <- df %>% mutate(across(num_cols, round, 2)) 
  
  return(df)
  
}

plot_params = function(data, emotion_fil=c(), subject_fil= c(), location_fil =c(),scene=NA){
  
  d = data %>% 
    mutate(
      subject_emotion = paste(subject,"-", emotion)
    )
  
  if(!length(subject_fil)==0){
    d = d %>% filter(subject %in% subject_fil)
  }
  if(!length(location_fil)==0){
    d = d %>% filter(Location %in% location_fil)
  }
  if(!length(emotion_fil)==0){
    d = d %>% filter(emotion %in% emotion_fil)
  }
  
  fig = plot_ly(data = d,
                x = ~shape,
                y = ~mu,
                z = ~kt ,
                color = ~ emotion ,
                type="scatter3d", 
                mode = "markers",
                symbol = ~ subject,  
                symbols = c('circle','x','o',"diamond","sqaure","cross","star","hash"),
                marker = list(size = 5),
                scene = scene,
                hoverinfo = ~Location 
  )
  
  fig = fig %>%  add_paths( split= ~ subject_emotion, showlegend=F)
  
  fig = fig %>% layout(title = ' Locating in Paramter Space',
                       scene = list(xaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1),
                                    yaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1),
                                    zaxis = list(gridcolor = 'rgb(0, 0, 0)',
                                                 zerolinewidth = 5,
                                                 ticklen = 5,
                                                 gridwidth = 1)
                       ),
                       paper_bgcolor = 'rgb(243, 243, 243)',
                       plot_bgcolor = 'rgb(243, 243, 230)')
  return(fig)
}
