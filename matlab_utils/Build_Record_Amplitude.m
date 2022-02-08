function [ record ] = Build_Record_Amplitude( time_series, X)
%Build_Record take time series and output full stochastic record

%   Detailed explanation goes here

record.time_series=time_series; %accel

% Peaks are the amplitude
% [record.time_series_peaks, record.time_series_locs]=findpeaks(record.time_series);
% 
% [record.time_series_phat, record.time_series_ci]=gamfit(record.time_series_peaks);
% 
% [record.time_series_mean, record.time_series_var]=gamstat(record.time_series_phat(1), record.time_series_phat(2));
% 
% record.mean_sfifted=abs(record.time_series_mean-record.time_series);

BW1=imregionalmax(record.time_series); 
BW2=imregionalmin(record.time_series);     % finding the local maxima and local minima
MinIndex=find(BW2==1); 
MinValue_Speed=record.time_series(MinIndex);
MaxIndex=find(BW1==1); 
MaxValue_Speed=record.time_series(MaxIndex);

[ ~, record.MicroMov,record.MaxIndex] = Get_MicroMovements( MinIndex, MaxIndex, MaxValue_Speed, record.time_series );

[record.phat, record.ci] = gamfit(record.MicroMov);

record.MicroMov_full(record.MaxIndex(1:end))=record.MicroMov;         %for cross-coherence

[record.mean, record.var]=gamstat(record.phat(1), record.phat(2));

record.sk=skewness(record.MicroMov);  %2/sqrt(record.phat(1));  %

record.kt=kurtosis(record.MicroMov);  %6/record.phat(1);        %


record.gampdf_Y=gampdf(X,record.phat(1), record.phat(2));
record.gampdf_X=X;
end

