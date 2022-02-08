%Copyright (c) 2011-2018, Elizabeth B Torres All Rights Reserved
%Functions developed for digital biomarkers Patent Pending Technology 
%PCT/US2012/064805

function[h]=plot_EbarsNew(phat, ci, marker, facecolor)

%This function plots error bars denoting 95% confidence intervals
%from the gamfit estimation of the Gamma parameters shape and scale
%It takes phat (shape phat(1) and scale phat(2)) 
%and the ci 2x2 matrix with the lower and upper
%bounds of the 95% ci
%the marker is any of the allowed markers for the plot
%function and the facecolor can be entered as with the plot function, e.g
%'r' for red or the rgb code [1 0 0]

h=plot(phat(1), phat(2), marker,'MarkerSize',15,...
    'MarkerEdgeColor','k', 'MarkerFaceColor',facecolor)


ex=abs(ci(2,1)-ci(1,1));

line([phat(1)-ex phat(1)+ex], ...
     [phat(2) phat(2)],'Color','k');
 
ey=ci(2,2)-ci(1,2);

errorbar(phat(1),phat(2),ey, 'k');
