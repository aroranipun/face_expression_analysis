%Copyright (c) 2019-2020, Elizabeth B Torres All Rights Reserved
%Functions developed for Patents US20190333629A1;
%US20190254533A1; US20190261909A1; EP3229684B1
%This script plots the stochastic signatures of each of the 7FUMEs as
%reference and uses them to localize a narrative on the Gamma moments space
%by first obtaining the Gamma-frame by Gamma-frame characterization of the
%narrative and then examining each frame in relation to the base signatures
%Functions called are
%GetSpeed_Trigeminal
%SlideWin_Traj
%Build_Record_Amplitude
%EMDistance_V1Region
%plot_EbarsNew
%==========================================================================
clear all;
%7FUMEs in alphabetical order
Anger=1;
Contempt=2;
Disgust=3;
Fear=4;
Happiness=5;
Sadness=6;
Surprise=7;

%% Faces
%here define the points to plot PDFs values later at .001 intervals
X=0:0.001:2;
%
load('Full_Movie_Vanessa.mat'); % full movie
%use sliding window to get traj
%1 scond is 30 frames
segln=30*60; %segment length is 1min window
overlap=.1;  %10percent overlap
Fs=30;       %30FPS is the resolution of a webcam

% Process data to reshape pixels position and get pixels's position rate of 
%change per unit time (1000ms/30FPS), the speed of the face points
%69 points make up the face grid, changing over time
%V1 faceregion has 28 points; V2 14 points and V3 27 points
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);

%output the windowed data as a cell array 
[newV1] = SlideWin_Traj(segln,overlap,Fs, speedV1');
[newV2] = SlideWin_Traj(segln,overlap,Fs, speedV2');
[newV3] = SlideWin_Traj(segln,overlap,Fs, speedV3');

% for each Face Region build the Gamma-trajectory of the narrative
for i=1:size(newV1,2)
    [ MovieFace(i).V1 ] = Build_Record_Amplitude( newV1{i}, X);
end
for i=1:size(newV2,2)
    [ MovieFace(i).V2 ] = Build_Record_Amplitude( newV2{i}, X);
end
for i=1:size(newV3,2)
    [ MovieFace(i).V3 ] = Build_Record_Amplitude( newV3{i}, X)
end

%% Gamma Moments Summary for REFERENCE FUMEs extracted from movie explaining each
colores=[0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250;0.4940 0.1840 0.5560;...
         0.4660 0.6740 0.1880;0.3010 0.7450 0.9330;0.6350 0.0780 0.1840; 1 0 0; 0 1 0; 1 0 1];
load('Face7.mat')
SCALEit=4;  %this makes the points more visible on the Gamma moments space
figure; hold on; set(gca,'FontSize',16);
for i=1:size(Face7,2)
    plot3(Face7(i).V1.mean, Face7(i).V1.var, Face7(i).V1.sk, 'o', 'MarkerFace', colores(i,:),...
        'MarkerEdge', colores(i,:),'MarkerSize', SCALEit*Face7(i).V1.kt);
    plot3(Face7(i).V2.mean, Face7(i).V2.var, Face7(i).V2.sk, 'd', 'MarkerFace', colores(i,:),...
        'MarkerEdge', colores(i,:),'MarkerSize', SCALEit*Face7(i).V2.kt);
    plot3(Face7(i).V3.mean, Face7(i).V3.var, Face7(i).V3.sk, 'v', 'MarkerFace', colores(i,:),...
        'MarkerEdge', colores(i,:),'MarkerSize', SCALEit*Face7(i).V3.kt);
end
box on; axis square; view(130,20)
xlabel('\mu'); ylabel('\sigma'); zlabel('skewness');
title('7 Universal Facial Micro Expressions');
toprint=sprintf('%s_GammaMoments', Face7(i).name);
print(toprint, '-dtiff');

%% Here Plot the Gamma Trajectory from the MovieFace containing the 
%Gamma Characterization of the Narrative for the given window and overlap
for i=1:size(newV1,2)
    plot3(MovieFace(i).V1.mean, MovieFace(i).V1.var, MovieFace(i).V1.sk, 'o', 'MarkerFace', 'k',...
        'MarkerEdge', 'k','MarkerSize', SCALEit*MovieFace(i).V1.kt);
end
for i=1:size(newV2,2)
    plot3(MovieFace(i).V2.mean, MovieFace(i).V2.var, MovieFace(i).V2.sk, 'd', 'MarkerFace', 'b',...
        'MarkerEdge', 'b','MarkerSize', SCALEit*MovieFace(i).V2.kt);
end
for i=1:size(newV3,2)
    plot3(MovieFace(i).V3.mean, MovieFace(i).V3.var, MovieFace(i).V3.sk, 'v', 'MarkerFace', 'r',...
        'MarkerEdge', 'r','MarkerSize', SCALEit*MovieFace(i).V3.kt);
end
% Place legend
legend('V1-Anger','V2','V3',...
'V1-Contempt','V2','V3',...
'V1-Disgust','V2','V3',...
'V1-Fear','V2','V3',...
'V1-Happiness','V2','V3',...
'V1-Sadness','V2','V3',...
'V1-Surprise','V2','V3',...
'Location','Best');

%% Here obtain the EMD profile
%for the Gamma trajectory compute the EMD which is the speed profile of each
%face zone going from Gamma frame to Gamma frame
%to later Localize the frames where EMD is minimal wrt to the Gamma signature in
%Gamma moments space of the 7FUME. The EMDist allows us to compare
%Gamma-frame by Gamma-frame the FaceRegion V1,V2, V3 with the corresponding
%Reference Face Region
FaceRegion=1; %V1
[EMDist_V1] = EMDistance_V1Region(MovieFace,Face7, FaceRegion);

FaceRegion=2; %V2
[EMDist_V2] = EMDistance_V1Region(MovieFace,Face7, FaceRegion);

FaceRegion=3; %V3
[EMDist_V3] = EMDistance_V1Region(MovieFace,Face7, FaceRegion);

%% EMD trajectory V1 Face Region
figure;
hold on; set(gca,'FontSize',16)
for i=1:size(EMDist_V1,2)
    plot(EMDist_V1(:,i), '-', 'Color', colores(i,:),'LineWidth',2);
end
axis square; axis tight; grid on; box on;
xlabel('Frames@5s win 10%overlap');
ylabel('EMDistance to FUME'); title('V1 Face Region')

% Place legend
legend('V1-Anger','V1-Contempt','V1-Disgust','V1-Fear',...
    'V1-Happiness','V1-Sadness','V1-Surprise',...
    'Location','Best');

print -dtiff Trajectory_EMD_V1;

%% EMD trajectory V2 Face Region
figure;
hold on; set(gca,'FontSize',16)
for i=1:size(EMDist_V2,2)
    plot(EMDist_V2(:,i), '-', 'Color', colores(i,:),'LineWidth',2);
end
axis square; axis tight; grid on; box on;
xlabel('Frames@5s win 10%overlap');
ylabel('EMDistance to FUME'); title('V2 Face Region')

% Place legend
legend('V2-Anger','V2-Contempt','V2-Disgust','V2-Fear',...
    'V2-Happiness','V2-Sadness','V2-Surprise',...
    'Location','Best');
print -dtiff Trajectory_EMD_V2;

%% EMD trajectory V3 Face Region
figure;
hold on; set(gca,'FontSize',16)
for i=1:size(EMDist_V3,2)
    plot(EMDist_V3(:,i), '-', 'Color', colores(i,:),'LineWidth',2);
end
axis square; axis tight; grid on; box on;
xlabel('Frames@5s win 10%overlap');
ylabel('EMDistance to FUME'); title('V3 Face Region')

% Place legend
legend('V3-Anger','V3-Contempt','V3-Disgust','V3-Fear',...
       'V3-Happiness','V3-Sadness','V3-Surprise',...
       'Location','Best');
print -dtiff Trajectory_EMD_V3;

%% Face maps V1 another way to visualize with colormaps
EMOTIONS={'Anger','Contempt','Disgust','Fear',...
           'Happiness','Sadness','Surprise'};
figure; 
imagesc(EMDist_V1); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks([1:7]); xticklabels(EMOTIONS);
ylabel('FPS@5swin10%OveL');
xlabel('7FacialUnivMicroExpr'); title('EMDist V1 FaceRegion')

print -dtiff Colormap_V1_EMDist_Trajectory

%% Face maps  V2
figure; 
imagesc(EMDist_V2); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks([1:7]); xticklabels(EMOTIONS);
ylabel('FPS@5swin10%OveL');
xlabel('7FacialUnivMicroExpr'); title('EMDist V2 FaceRegion')

print -dtiff Colormap_V2_EMDist_Trajectory

%% Face maps  V3
figure; 
imagesc(EMDist_V3); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks([1:7]); xticklabels(EMOTIONS);
ylabel('FPS@5swin10%OveL');
xlabel('7FacialUnivMicroExpr'); title('EMDist V3 FaceRegion')

print -dtiff Colormap_V3_EMDist_Trajectory

%% Some non parametric stats V1
figure; hold on; set(gca,'FontSize',16)
for i=1:7 %7FUME
    histogram(EMDist_V1(:,i),'FaceColor',colores(i,:), 'EdgeColor','k');
end
axis tight; box on; grid on;
xlabel('EMDistance'); ylabel('Frequency'); title('FaceRegion V1');
legend('V1-Anger','V1-Contempt','V1-Disgust','V1-Fear',...
    'V1-Happiness','V1-Sadness','V1-Surprise',...
    'Location','Best');
print -dtiff histograms_EMDist_V1

for i=1:7 %7FUME
    for j=1:7
        PVals_V1(i,j)=ranksum(EMDist_V1(:,i),EMDist_V1(:,j))
    end
end

figure;
imagesc(PVals_V1); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks(1:7); xticklabels(EMOTIONS);
yticks(1:7); yticklabels(EMOTIONS);
title('Face Region V1');
for i=1:7
    for j=1:7
        if PVals_V1(i,j)<=.01
            plot(i,j,'wp')
        end
        if PVals_V1(i,j)>0.01 && PVals_V1(i,j)<=.05
            plot(i,j,'wo')
        end
    end
end
print -dtiff RankSumTest_FaceV1;

%% Some non parametric stats V2
figure; hold on; set(gca,'FontSize',16)
for i=1:7 %7FUME
    histogram(EMDist_V2(:,i),'FaceColor',colores(i,:), 'EdgeColor','k');
end
axis tight; box on; grid on;
xlabel('EMDistance'); ylabel('Frequency'); title('FaceRegion V2');
legend('V2-Anger','V2-Contempt','V2-Disgust','V2-Fear',...
    'V2-Happiness','V2-Sadness','V2-Surprise',...
    'Location','Best');
print -dtiff histograms_EMDist_V2

for i=1:7 %7FUME
    for j=1:7
        PVals_V2(i,j)=ranksum(EMDist_V2(:,i),EMDist_V2(:,j))
    end
end

figure;
imagesc(PVals_V2); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks(1:7); xticklabels(EMOTIONS);
yticks(1:7); yticklabels(EMOTIONS);
title('Face Region V2');
for i=1:7
    for j=1:7
        if PVals_V2(i,j)<=.01
            plot(i,j,'wp')
        end
        if PVals_V2(i,j)>0.01 && PVals_V2(i,j)<=.05
            plot(i,j,'wo')
        end
    end
end
print -dtiff RankSumTest_FaceV2;

%% Some non parametric stats V3
figure; hold on; set(gca,'FontSize',16)
for i=1:7 %7FUME
    histogram(EMDist_V3(:,i),'FaceColor',colores(i,:), 'EdgeColor','k');
end
axis tight; box on; grid on;
xlabel('EMDistance'); ylabel('Frequency'); title('FaceRegion V3');
legend('V3-Anger','V3-Contempt','V3-Disgust','V3-Fear',...
    'V3-Happiness','V3-Sadness','V3-Surprise',...
    'Location','Best');
print -dtiff histograms_EMDist_V3

for i=1:7 %7FUME
    for j=1:7
        PVals_V3(i,j)=ranksum(EMDist_V3(:,i),EMDist_V3(:,j))
    end
end

figure;
imagesc(PVals_V3); colorbar;
hold on; set(gca,'FontSize',16);
xtickangle(45);
xticks(1:7); xticklabels(EMOTIONS);
yticks(1:7); yticklabels(EMOTIONS);
title('Face Region V3');
for i=1:7
    for j=1:7
        if PVals_V3(i,j)<=.01
            plot(i,j,'wp')
        end
        if PVals_V3(i,j)>0.01 && PVals_V3(i,j)<=.05
            plot(i,j,'wo')
        end
    end
end
print -dtiff RankSumTest_FaceV3;

%% Gamma Plane V1
g=[];
figure; hold on; set(gca,'FontSize',14);
for i=1:size(Face7,2)
    g(i)=plot_EbarsNew(log(Face7(i).V1.phat), log(Face7(i).V1.ci), 'o', colores(i,:));
end

for j=1:size(MovieFace,2)
    if ~isempty(MovieFace(j).V1)
        g(8)=plot_EbarsNew(log(MovieFace(j).V1.phat), log(MovieFace(j).V1.ci), 'o', 'r');
    end
end
legend(g,'V1-Anger','V1-Contempt','V1-Disgust','V1-Fear','V1-Happiness',...
'V1-Sadness','V1-Surprise','V1-Traj','Location','Best') 

xlabel('log shape'); ylabel('log scale');
box on; axis square; grid on
toprint=sprintf('7FUME_V1_GammaPlane');
print(toprint, '-dtiff');

%% Gamma Plane V2
h=[];
figure; hold on; set(gca,'FontSize',14);
for i=1:size(Face7,2)
    h(i)=plot_EbarsNew(log(Face7(i).V2.phat), log(Face7(i).V2.ci), 'd', colores(i,:));
end
for j=1:size(MovieFace,2)
    if ~isempty(MovieFace(j).V2)
        h(8)=plot_EbarsNew(log(MovieFace(j).V2.phat), log(MovieFace(j).V2.ci), 'd', 'b');
    end
end

legend(h,'V2-Anger','V2-Contempt','V2-Disgust','V2-Fear','V2-Happiness',...
'V2-Sadness','V2-Surprise','V2-Traj','Location','Best') 

xlabel('log shape'); ylabel('log scale');
box on; axis square; grid on
toprint=sprintf('7FUME_V2_GammaPlane');
print(toprint, '-dtiff');

%% Gamma Plane V3
figure; hold on; set(gca,'FontSize',14);
m=[];
for i=1:size(Face7,2)
    m(i)=plot_EbarsNew(log(Face7(i).V3.phat), log(Face7(i).V3.ci), 'v', colores(i,:));
end
for j=1:size(MovieFace,2)
    if ~isempty(MovieFace(j).V3)
        m(8)=plot_EbarsNew(log(MovieFace(j).V3.phat), log(MovieFace(j).V3.ci), 'v', 'k');
    end
end
legend(m,'V3-Anger','V3-Contempt','V3-Disgust','V3-Fear','V3-Happiness',...
'V3-Sadness','V3-Surprise','V3-Traj','Location','Best') 

xlabel('log shape'); ylabel('log scale');
box on; axis square; grid on
toprint=sprintf('7FUME_V3_GammaPlane');
print(toprint, '-dtiff');

%% Plot PDFs
colores=[0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250;0.4940 0.1840 0.5560;...
    0.4660 0.6740 0.1880;0.3010 0.7450 0.9330;0.6350 0.0780 0.1840; 1 0 0; 0 1 0; 1 0 1];

figure; hold on; set(gca,'FontSize',16);
for i=1:size(Face7,2)
    
    plot(Face7(i).V1.gampdf_X, Face7(i).V1.gampdf_Y, '-', 'LineWidth',2,'Color', colores(i,:));
    plot(Face7(i).V2.gampdf_X, Face7(i).V2.gampdf_Y, '--', 'LineWidth',2,'Color', colores(i,:));
    plot(Face7(i).V3.gampdf_X, Face7(i).V3.gampdf_Y, ':', 'LineWidth',2,'Color', colores(i,:));
end
legend('V1-Anger','V2','V3',...
'V1-Contempt','V2','V3',...
'V1-Disgust','V2','V3',...
'V1-Fear','V2','V3',...
'V1-Happiness','V2','V3',...
'V1-Sadness','V2','V3',...
'V1-Surprise','V2','V3',...
'Location','Best');
box on; axis square;grid on;
xlabel('Speed Micro-Mov Spikes'); ylabel('PDF');
title_name=sprintf('%s', 'All 7FUME');
title(title_name);
toprint=sprintf('%s_PDF', 'all_PDF_reference');
print(toprint, '-dtiff');

%% Print Trajectories
figure; hold on; set(gca,'FontSize',20);
g=[];
for i=1:size(Face7,2)
    g(i)=plot(Face7(i).V1.gampdf_X, Face7(i).V1.gampdf_Y, '-', 'LineWidth',2,'Color', colores(i,:));
end
for i=1:size(MovieFace,2)
    if ~isempty(MovieFace(i).V1)
        g(8)=plot(MovieFace(i).V1.gampdf_X, MovieFace(i).V1.gampdf_Y, 'r-', ...
            'LineWidth',2);
    end
end

legend(g,'V1-Anger','V1-Contempt','V1-Disgust','V1-Fear','V1-Happiness',...
'V1-Sadness','V1-Surprise','V1-Traj','Location','Best') 
box on; axis square;grid on;
xlabel('Speed Micro-Mov Spikes'); ylabel('PDF');
title_name=sprintf('%s', 'V1Traj vs V1Reference');
title(title_name);
maximize;
toprint=sprintf('%s_PDF', 'V1_PDF');
print(toprint, '-dtiff');

%% Print Trajectories
figure; hold on; set(gca,'FontSize',20);
g=[];
for i=1:size(Face7,2)
    g(i)=plot(Face7(i).V2.gampdf_X, Face7(i).V2.gampdf_Y, '-', 'LineWidth',2,'Color', colores(i,:));
end
for i=1:size(MovieFace,2)
    if ~isempty(MovieFace(i).V2)
        g(8)=plot(MovieFace(i).V2.gampdf_X, MovieFace(i).V2.gampdf_Y, 'b-', ...
            'LineWidth',2);
    end
end

legend(g,'V2-Anger','V2-Contempt','V2-Disgust','V2-Fear','V2-Happiness',...
'V2-Sadness','V2-Surprise','V2-Traj','Location','Best') 
box on; axis square;grid on;
xlabel('Speed Micro-Mov Spikes'); ylabel('PDF');
title_name=sprintf('%s', 'V2Traj vs V2Reference');
title(title_name);
maximize;
toprint=sprintf('%s_PDF', 'V2_PDF');
print(toprint, '-dtiff');

%% Print Trajectories
figure; hold on; set(gca,'FontSize',20);
g=[];
for i=1:size(Face7,2)
    g(i)=plot(Face7(i).V3.gampdf_X, Face7(i).V3.gampdf_Y, '-', 'LineWidth',2,'Color', colores(i,:));
end
for i=1:size(MovieFace,2)
    if ~isempty(MovieFace(i).V3)
        g(8)=plot(MovieFace(i).V3.gampdf_X, MovieFace(i).V3.gampdf_Y, 'k-', ...
            'LineWidth',2);
    end
end

legend(g,'V3-Anger','V3-Contempt','V3-Disgust','V3-Fear','V3-Happiness',...
'V3-Sadness','V3-Surprise','V3-Traj','Location','Best') 
box on; axis square;grid on;
xlabel('Speed Micro-Mov Spikes'); ylabel('PDF');
title_name=sprintf('%s', 'V3Traj vs V3Reference');
title(title_name);
maximize;
toprint=sprintf('%s_PDF', 'V3_PDF');
print(toprint, '-dtiff');









