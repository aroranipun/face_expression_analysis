%Copyright (c) 2011-2018, Elizabeth B Torres All Rights Reserved
%Functions developed for digital biomarkers Patent Technology 
%US10176299B2
%Figures in paper http://www.mdpi.com/1424-8220/18/4/1025 

function [ Avrg_speed, Norm_MaxValue, nMaxIndex] = Get_MicroMovements( MinIndex, MaxIndex, MaxValue, speed )
%Normalize_Max_Vel_Value 
%input the raw data time series with peaks and valleys 
%(e.g. speed recorded continuosly, IMU accel data, etc)
%enter the values of the peaks and the indexes of the
%minima (these are time series) obtainable with findpeaks
%outputs the series of averaged speed values between local minima
%surrounding a local maxima
%and the scaled fluctuations in peak amplitude, as normalized

%always ensure that the series starts and ends with a local minima
%Check the first values using MinIndex as a guide
if MaxIndex(1)<MinIndex(1)   %max is  shifted to the left
    MaxIndex=MaxIndex(2:end);
    MaxValue=MaxValue(2:end);
end

%Check the last values using MinIndex as a guide
if length(MaxIndex)>(length(MinIndex))
    MaxIndex=MaxIndex(1:end-1);
    MaxValue=MaxValue(1:end-1);
end

    
Avrg_speed=[]; Norm_MaxValue=[];
%Compute using MaxIndex as a guide (for length)
for i=1 : min([length(MinIndex),length(MaxIndex)])-1

    segment=[]; segment=speed(MinIndex(i):MinIndex(i+1));
    %here the segment is between two minima surrounding a local maximum
    Avrg_speed(i)=mean(segment);
    nMaxIndex(i)=MaxIndex(i);
    Norm_MaxValue(i)= MaxValue(i)/(MaxValue(i)+Avrg_speed(i));
end





