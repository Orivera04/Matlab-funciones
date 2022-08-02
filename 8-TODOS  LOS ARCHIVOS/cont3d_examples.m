%uncomment the example tha you want to view
clear
% example_1
 for i=1:1:30
     for j=1:1:30
         for k=1:1:30
             x(i,j,k)=1/((i-13.1)^2+(j-8.1)^2+(k-3.1)^2);
         end
     end
end
cont3d(x,[1 2],[2 3],[4 6],17,0.1,'v',1,'z');
cont3d(x,[1 2],[2 3],[4 6],17,.1,'v',1,'x');
cont3d(x,[1 2],[2 3],[4 6],17,.1,'v',1,'z');
xlabel('x')
ylabel('y')
zlabel('z')
view(30,40)
colormap hot,colorbar
 
% %%example_2
% load mri
% D=squeeze(D);
% d2 = smooth3(D);
% md2=double(max(max(max(d2))));
% cont3d(md2-double(d2),[1 2],[2 3],[4 6],1,0.8,'m',2,'z');colormap hot%try to make nlines bigger
% view(50,60)

% example_3
% [x,y,z,v]=flow; 
% cont3d(v,[1 2],[2 3],[4 6],10,0.8,'v',2,'y');colormap jet;colorbar;view(140,30)

% % example_4
% load wind
% vv=u.^2+v.^2+w.^2;
% cont3d(vv,[1 2],[2 3],[4 6],10,0.8,'v',3,'x');
% cont3d(vv,[1 2],[2 3],[4 6],10,0.8,'v',3,'y');
% cont3d(vv,[1 2],[2 3],[4 6],10,0.8,'v',3,'z');
%

 %%example_5_"psi function"
% for i=1:10
%      for j=1:10
%          for k=1:10
%              r=norm([i-5.1 j-5.1 k-5.1]);
%              x(i,j,k)=exp(1/2*r^2)*exp(-r^2);
%          end
%      end
%  end
% 
% cont3d(x.^2,[1 2],[2 3],[4 6],10,0.8,'v',4,'x');
% cont3d(x.^2,[1 2],[2 3],[4 6],10,0.8,'v',4,'y');
% cont3d(x.^2,[1 2],[2 3],[4 6],10,0.8,'v',4,'z');
% colormap hot
% colorbar
% 
% 
%   
%    %figure settings
%    set(gca,'color',[0 0.5 0],'xcolor','white', ...
%    'ycolor','white','zcolor','white')
%    set(gca,'xgrid','on')
%    set(gca,'ygrid','on')
%    set(gca,'zgrid','on')
% %    set(gca,'alim',[0,0.01])
% %    set(gca,'cameraposition',[10 10 10],'cameratarget',[5 5 5])
hpop = uicontrol('Style', 'popup',...
       'String', 'hsv|hot|cool|gray|pink',...
        'Position', [20 320 100 50],...
        'Callback', 'setmap','backgroundcolor','w');
