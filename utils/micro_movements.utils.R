library (pracma)

plot_peaks <- function(ts,cex=1){
  require(pracma)
  
  peaks = data.frame(findpeaks(x = ts,zero = '0',nups = 1,ndowns = 0))
  valleys = data.frame(findpeaks(x = -ts,zero = '0',nups = 0,ndowns = 1))
  
  plot(ts,type = 'l',)
  points(y = ts, x = seq(1:length(ts)),pch=1,col='black',cex=cex)
  points(y = peaks$X1, x = peaks$X2,pch=1,col='red',cex=cex)
  points(y = -valleys$X1, x = valleys$X2,pch=1,col='yellow',cex=cex)
}
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


