%WARNING WORKSPACE WILL BE CLEARED

clc
%clearvars
close all


%Uncomment one of the folleing lines and runs

 load JuliusCesar.mat
  load Bimba_Par.mat
  %load Foot_Par.mat
  load hhh.mat





%Run Program


uv=CircularParametrizer(t);


%Display Results

%% plot the surface
figure(1);
set(gcf,'position',[0,0,1280,800]);
subplot(1,2,1)
hold on
axis equal
title('Surface','fontsize',14)
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c')
rotate3d on



%% plot the parametrization
figure(1)
subplot(1,2,2)
hold on
title('Parametrization','fontsize',14)
axis equal
trimesh(t,uv(:,1),uv(:,2),'color','g')
view([0,0,1]);
