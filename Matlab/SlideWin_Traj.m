function [new_trajectory] = SlideWin_Traj(segln,overlap,Fs, trajectory)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% segln = 101;       % 1 second window 
% overlap = 0.5;     % 50  % overlap 
% Fs=30;             % sampling resolution
seg_no = 1;
t1 = 0;              % start time for window 
t2 = t1+segln*Fs;    % end time for window 

slidestop = 1; 
% keyboard

while slidestop 
    t1 = t1 + overlap*segln*Fs;
    t2 = t1 + segln*Fs;
    if t2 > length(trajectory) 
        slidestop = 0; 
    else 
        if seg_no==1
            new_trajectory{seg_no} = trajectory(1:t1,:);
            slidestop = 1; seg_no = seg_no + 1;
        else
            
            new_trajectory{seg_no} = trajectory(t1:t2,:);
            slidestop = 1; seg_no = seg_no + 1;
        end
    end 
end

end

