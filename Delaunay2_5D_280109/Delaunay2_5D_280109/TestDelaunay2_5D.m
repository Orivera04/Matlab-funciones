

%WARNING WORKSPACE WILL BE CLEARED !!!!!
clc
clear
close all

%Instructions :

%just uncomment one of the following line and run


%% Open points cloud:

% load Nefertiti.mat
% load Hypersheet.mat
% load pipes.mat
% load Monkey2.mat
load Foot.mat
% load HandOliver
% load Falangi.mat
% load Mannequin




%% Run  program
[t]=Delaunay2_5D(p);

%% plot the points cloud
figure(1);
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Points Cloud','fontsize',14)
plot3(p(:,1),p(:,2),p(:,3),'g.')
view(3)


%% plot the output triangulation
figure(1)
subplot(1,2,2)
hold on
title('Output Triangulation','fontsize',14)
axis equal
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b')%plot della superficie
view(3)
