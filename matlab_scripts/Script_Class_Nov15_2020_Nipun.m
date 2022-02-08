%Script to process all 7FUME from Nipun's data

clear all;

X=0:.001:2;
%to use consistent colors throughout
colores=[0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250;0.4940 0.1840 0.5560;...
         0.4660 0.6740 0.1880;0.3010 0.7450 0.9330;0.6350 0.0780 0.1840; 1 0 0; 0 1 0; 1 0 1];
SCALEit=4; %for visibility of the size of the marker proportional to 4th moment (kurtosis)
%for consistency saving and plotting the 7FUME in alphabetical order
Anger=1;
Contempt=2;
Disgust=3;
Fear=4;
Happiness=5;
Sadness=6;
Surprise=7;

%% Nipun Anger
load('../data/Nipun_Anger_processed_segmented_processed.mat')
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Anger_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Anger_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Anger_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Nipun Happiness
load('Nipun_Happiness_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Happiness_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Happiness_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Happiness_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Here plot these raw waveforms as an example
figure; 
subplot(2,3,1); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V1.time_series,'r')
[pks,locs]=findpeaks(Nipun_Happiness_V1.time_series);
plot(locs,pks,'ro'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Happiness V1');

subplot(2,3,2); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V2.time_series,'b')
[pks,locs]=findpeaks(Nipun_Happiness_V2.time_series);
plot(locs,pks,'bo'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Happiness V2');

subplot(2,3,3); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V3.time_series,'k')
[pks,locs]=findpeaks(Nipun_Happiness_V3.time_series);
plot(locs,pks,'ko'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Happiness V3');

subplot(2,3,4); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V1.time_series,'r')
[pks,locs]=findpeaks(Nipun_Anger_V1.time_series);
plot(locs,pks,'ro'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Anger V1');

subplot(2,3,5); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V2.time_series,'b')
[pks,locs]=findpeaks(Nipun_Anger_V2.time_series);
plot(locs,pks,'bo'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Anger V2');

subplot(2,3,6); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V3.time_series,'k')
[pks,locs]=findpeaks(Nipun_Anger_V3.time_series);
plot(locs,pks,'ko'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Speed pixels/unit time'); title('Anger V3');
maximize;
print -dtiff Raw_Speed_Nipun

%% Plot the Micro-Movements, which are the standardized scaled waveform to do the Gamma analysis on
figure; 
subplot(2,3,1); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V1.MicroMov,'r')
[pks,locs]=findpeaks(Nipun_Happiness_V1.MicroMov);
plot(locs,pks,'ro'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Happiness V1');

subplot(2,3,2); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V2.MicroMov,'b')
[pks,locs]=findpeaks(Nipun_Happiness_V2.MicroMov);
plot(locs,pks,'bo'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Happiness V2');

subplot(2,3,3); hold on; set(gca,'FontSize', 16);
plot(Nipun_Happiness_V3.MicroMov,'k')
[pks,locs]=findpeaks(Nipun_Happiness_V3.MicroMov);
plot(locs,pks,'ko'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Happiness V3');

subplot(2,3,4); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V1.MicroMov,'r')
[pks,locs]=findpeaks(Nipun_Anger_V1.MicroMov);
plot(locs,pks,'ro'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Anger V1');

subplot(2,3,5); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V2.MicroMov,'b')
[pks,locs]=findpeaks(Nipun_Anger_V2.MicroMov);
plot(locs,pks,'bo'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Anger V2');

subplot(2,3,6); hold on; set(gca,'FontSize', 16);
plot(Nipun_Anger_V3.MicroMov,'k')
[pks,locs]=findpeaks(Nipun_Anger_V3.MicroMov);
plot(locs,pks,'ko'); axis tight; box on; axis square;
xlabel('Frames @25Hz'); ylabel('Scaled MMS'); title('Anger V3');
maximize;
print -dtiff Micro_Movements_Nipun

%% Nipun Contempt
load('Nipun_Contempt_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Contempt_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Contempt_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Contempt_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Nipun Disgust
load('Nipun_Disgust_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Disgust_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Disgust_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Disgust_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Nipun Fear
load('Nipun_Fear_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Fear_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Fear_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Fear_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Nipun Sadness
load('Nipun_Sadness_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Sadness_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Sadness_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Sadness_V3 ] = Build_Record_Amplitude( speedV3, X);

%% Nipun Surprise
load('Nipun_Surprise_processed_segmented_processed.mat');
[speedV1,speedV2,speedV3] = GetSpeed_Trigeminal(V1,V2,V3);
%Reference signature for Anger
[ Nipun_Surprise_V1 ] = Build_Record_Amplitude( speedV1, X);
[ Nipun_Surprise_V2 ] = Build_Record_Amplitude( speedV2, X);
[ Nipun_Surprise_V3 ] = Build_Record_Amplitude( speedV3, X);

%% save all of Nipun's data
Nipun_7FUME(Anger).V1=Nipun_Anger_V1;
Nipun_7FUME(Anger).V2=Nipun_Anger_V2;
Nipun_7FUME(Anger).V3=Nipun_Anger_V3;

Nipun_7FUME(Contempt).V1=Nipun_Contempt_V1;
Nipun_7FUME(Contempt).V2=Nipun_Contempt_V2;
Nipun_7FUME(Contempt).V3=Nipun_Contempt_V3;

Nipun_7FUME(Disgust).V1=Nipun_Disgust_V1;
Nipun_7FUME(Disgust).V2=Nipun_Disgust_V2;
Nipun_7FUME(Disgust).V3=Nipun_Disgust_V3;

Nipun_7FUME(Fear).V1=Nipun_Fear_V1;
Nipun_7FUME(Fear).V2=Nipun_Fear_V2;
Nipun_7FUME(Fear).V3=Nipun_Fear_V3;

Nipun_7FUME(Happiness).V1=Nipun_Happiness_V1;
Nipun_7FUME(Happiness).V2=Nipun_Happiness_V2;
Nipun_7FUME(Happiness).V3=Nipun_Happiness_V3;

Nipun_7FUME(Sadness).V1=Nipun_Sadness_V1;
Nipun_7FUME(Sadness).V2=Nipun_Sadness_V2;
Nipun_7FUME(Sadness).V3=Nipun_Sadness_V3;

Nipun_7FUME(Surprise).V1=Nipun_Surprise_V1;
Nipun_7FUME(Surprise).V2=Nipun_Surprise_V2;
Nipun_7FUME(Surprise).V3=Nipun_Surprise_V3;

save Nipun_7FUME Nipun_7FUME;

%% Plot All Signatures
figure; hold on; set(gca,'FontSize',16);
a1=plot3(Nipun_Anger_V1.mean, Nipun_Anger_V1.var, Nipun_Anger_V1.sk, 'o', 'MarkerFace', colores(Anger,:),...
    'MarkerEdge', colores(Anger,:),'MarkerSize', SCALEit*Nipun_Anger_V1.kt);
a2=plot3(Nipun_Anger_V2.mean, Nipun_Anger_V2.var, Nipun_Anger_V2.sk, 'd', 'MarkerFace', colores(Anger,:),...
    'MarkerEdge', colores(Anger,:), 'MarkerSize', SCALEit*Nipun_Anger_V2.kt);
a3=plot3(Nipun_Anger_V3.mean, Nipun_Anger_V3.var, Nipun_Anger_V3.sk, 'v', 'MarkerFace', colores(Anger,:),...
    'MarkerEdge', colores(Anger,:), 'MarkerSize', SCALEit*Nipun_Anger_V3.kt);

h1=plot3(Nipun_Happiness_V1.mean, Nipun_Happiness_V1.var, Nipun_Happiness_V1.sk, 'o', 'MarkerFace', colores(Happiness,:),...
    'MarkerEdge', colores(Happiness,:),'MarkerSize', SCALEit*Nipun_Happiness_V1.kt);
h2=plot3(Nipun_Happiness_V2.mean, Nipun_Happiness_V2.var, Nipun_Happiness_V2.sk, 'd', 'MarkerFace', colores(Happiness,:),...
    'MarkerEdge', colores(Happiness,:),'MarkerSize', SCALEit*Nipun_Happiness_V2.kt);
h3=plot3(Nipun_Happiness_V3.mean, Nipun_Happiness_V3.var, Nipun_Happiness_V3.sk, 'v', 'MarkerFace', colores(Happiness,:),...
    'MarkerEdge', colores(Happiness,:),'MarkerSize', SCALEit*Nipun_Happiness_V3.kt);

c1=plot3(Nipun_Contempt_V1.mean, Nipun_Contempt_V1.var, Nipun_Contempt_V1.sk, 'o', 'MarkerFace', colores(Contempt,:),...
    'MarkerEdge', colores(Contempt,:),'MarkerSize', SCALEit*Nipun_Contempt_V1.kt);
c2=plot3(Nipun_Contempt_V2.mean, Nipun_Contempt_V2.var, Nipun_Contempt_V2.sk, 'd', 'MarkerFace', colores(Contempt,:),...
    'MarkerEdge', colores(Contempt,:), 'MarkerSize', SCALEit*Nipun_Contempt_V2.kt);
c3=plot3(Nipun_Contempt_V3.mean, Nipun_Contempt_V3.var, Nipun_Contempt_V3.sk, 'v', 'MarkerFace', colores(Contempt,:),...
    'MarkerEdge', colores(Contempt,:), 'MarkerSize', SCALEit*Nipun_Contempt_V3.kt);

d1=plot3(Nipun_Disgust_V1.mean, Nipun_Disgust_V1.var, Nipun_Disgust_V1.sk, 'o', 'MarkerFace', colores(Disgust,:),...
    'MarkerEdge', colores(Disgust,:),'MarkerSize', SCALEit*Nipun_Disgust_V1.kt);
d2=plot3(Nipun_Disgust_V2.mean, Nipun_Disgust_V2.var, Nipun_Disgust_V2.sk, 'd', 'MarkerFace', colores(Disgust,:),...
    'MarkerEdge', colores(Disgust,:), 'MarkerSize', SCALEit*Nipun_Disgust_V2.kt);
d3=plot3(Nipun_Disgust_V3.mean, Nipun_Disgust_V3.var, Nipun_Disgust_V3.sk, 'v', 'MarkerFace', colores(Disgust,:),...
    'MarkerEdge', colores(Disgust,:), 'MarkerSize', SCALEit*Nipun_Disgust_V3.kt);

f1=plot3(Nipun_Fear_V1.mean, Nipun_Fear_V1.var, Nipun_Fear_V1.sk, 'o', 'MarkerFace', colores(Fear,:),...
    'MarkerEdge', colores(Fear,:),'MarkerSize', SCALEit*Nipun_Fear_V1.kt);
f2=plot3(Nipun_Fear_V2.mean, Nipun_Fear_V2.var, Nipun_Fear_V2.sk, 'd', 'MarkerFace', colores(Fear,:),...
    'MarkerEdge', colores(Fear,:), 'MarkerSize', SCALEit*Nipun_Fear_V2.kt);
f3=plot3(Nipun_Fear_V3.mean, Nipun_Fear_V3.var, Nipun_Fear_V3.sk, 'v', 'MarkerFace', colores(Fear,:),...
    'MarkerEdge', colores(Fear,:), 'MarkerSize', SCALEit*Nipun_Fear_V3.kt);

s1=plot3(Nipun_Sadness_V1.mean, Nipun_Sadness_V1.var, Nipun_Sadness_V1.sk, 'o', 'MarkerFace', colores(Sadness,:),...
    'MarkerEdge', colores(Sadness,:),'MarkerSize', SCALEit*Nipun_Sadness_V1.kt);
s2=plot3(Nipun_Sadness_V2.mean, Nipun_Sadness_V2.var, Nipun_Sadness_V2.sk, 'd', 'MarkerFace', colores(Sadness,:),...
    'MarkerEdge', colores(Sadness,:), 'MarkerSize', SCALEit*Nipun_Sadness_V2.kt);
s3=plot3(Nipun_Sadness_V3.mean, Nipun_Sadness_V3.var, Nipun_Sadness_V3.sk, 'v', 'MarkerFace', colores(Sadness,:),...
    'MarkerEdge', colores(Sadness,:), 'MarkerSize', SCALEit*Nipun_Sadness_V3.kt);

su1=plot3(Nipun_Surprise_V1.mean, Nipun_Surprise_V1.var, Nipun_Surprise_V1.sk, 'o', 'MarkerFace', colores(Surprise,:),...
    'MarkerEdge', colores(Surprise,:),'MarkerSize', SCALEit*Nipun_Surprise_V1.kt);
su2=plot3(Nipun_Surprise_V2.mean, Nipun_Surprise_V2.var, Nipun_Surprise_V2.sk, 'd', 'MarkerFace', colores(Surprise,:),...
    'MarkerEdge', colores(Surprise,:), 'MarkerSize', SCALEit*Nipun_Surprise_V2.kt);
su3=plot3(Nipun_Surprise_V3.mean, Nipun_Surprise_V3.var, Nipun_Surprise_V3.sk, 'v', 'MarkerFace', colores(Surprise,:),...
    'MarkerEdge', colores(Surprise,:), 'MarkerSize', SCALEit*Nipun_Surprise_V3.kt);

X1=[Nipun_Anger_V1.mean  Nipun_Anger_V2.mean  Nipun_Anger_V3.mean Nipun_Anger_V1.mean];
Y1=[Nipun_Anger_V1.var  Nipun_Anger_V2.var  Nipun_Anger_V3.var Nipun_Anger_V1.var];
Z1=[Nipun_Anger_V1.sk  Nipun_Anger_V2.sk  Nipun_Anger_V3.sk Nipun_Anger_V1.sk];
l1=line(X1,Y1,Z1, 'Color','k', 'LineWidth',3);

X2=[Nipun_Happiness_V1.mean  Nipun_Happiness_V2.mean  Nipun_Happiness_V3.mean Nipun_Happiness_V1.mean];
Y2=[Nipun_Happiness_V1.var  Nipun_Happiness_V2.var  Nipun_Happiness_V3.var Nipun_Happiness_V1.var];
Z2=[Nipun_Happiness_V1.sk  Nipun_Happiness_V2.sk  Nipun_Happiness_V3.sk Nipun_Happiness_V1.sk];
l2=line(X2,Y2,Z2, 'Color','k', 'LineWidth',3);

X3=[Nipun_Contempt_V1.mean  Nipun_Contempt_V2.mean  Nipun_Contempt_V3.mean Nipun_Contempt_V1.mean];
Y3=[Nipun_Contempt_V1.var  Nipun_Contempt_V2.var  Nipun_Contempt_V3.var Nipun_Contempt_V1.var];
Z3=[Nipun_Contempt_V1.sk  Nipun_Contempt_V2.sk  Nipun_Contempt_V3.sk Nipun_Contempt_V1.sk];
l3=line(X3,Y3,Z3, 'Color','k', 'LineWidth',3);

X4=[Nipun_Disgust_V1.mean  Nipun_Disgust_V2.mean  Nipun_Disgust_V3.mean Nipun_Disgust_V1.mean];
Y4=[Nipun_Disgust_V1.var  Nipun_Disgust_V2.var  Nipun_Disgust_V3.var Nipun_Disgust_V1.var];
Z4=[Nipun_Disgust_V1.sk  Nipun_Disgust_V2.sk  Nipun_Disgust_V3.sk Nipun_Disgust_V1.sk];
l4=line(X4,Y4,Z4, 'Color','k', 'LineWidth',3);

X5=[Nipun_Fear_V1.mean  Nipun_Fear_V2.mean  Nipun_Fear_V3.mean Nipun_Fear_V1.mean];
Y5=[Nipun_Fear_V1.var  Nipun_Fear_V2.var  Nipun_Fear_V3.var Nipun_Fear_V1.var];
Z5=[Nipun_Fear_V1.sk  Nipun_Fear_V2.sk  Nipun_Fear_V3.sk Nipun_Fear_V1.sk];
l5=line(X5,Y5,Z5, 'Color','k', 'LineWidth',3);

X6=[Nipun_Sadness_V1.mean  Nipun_Sadness_V2.mean  Nipun_Sadness_V3.mean Nipun_Sadness_V1.mean];
Y6=[Nipun_Sadness_V1.var  Nipun_Sadness_V2.var  Nipun_Sadness_V3.var Nipun_Sadness_V1.var];
Z6=[Nipun_Sadness_V1.sk  Nipun_Sadness_V2.sk  Nipun_Sadness_V3.sk Nipun_Sadness_V1.sk];
l6=line(X6,Y6,Z6, 'Color','k', 'LineWidth',3);

X7=[Nipun_Surprise_V1.mean  Nipun_Surprise_V2.mean  Nipun_Surprise_V3.mean Nipun_Surprise_V1.mean];
Y7=[Nipun_Surprise_V1.var  Nipun_Surprise_V2.var  Nipun_Surprise_V3.var Nipun_Surprise_V1.var];
Z7=[Nipun_Surprise_V1.sk  Nipun_Surprise_V2.sk  Nipun_Surprise_V3.sk Nipun_Surprise_V1.sk];
l7=line(X7,Y7,Z7, 'Color','k', 'LineWidth',3);

legend([a1,h1,c1,d1,f1,s1,su1],'Anger-V1','Happiness-V1','Contempt-V1',...
    'Disgust-V1','Fear-V1','Sadness-V1','Surprise-V1');

box on; grid on;
view(158,9);
xlabel('\mu'); ylabel('\sigma'); zlabel('skewness')
title('Nipun 7FUME');

maximize;
print -dtiff Nipun_7FUME;

