%figure(1)
%colormap(flipud(gray))
%q = double(imread('ngc6543a.jpg'));               
%qq = 0.3*q(:,:,1) + 0.59*q(:,:,2) + 0.11*q(:,:,3);
%clf
%imagesc(qq(1:550,1:598))
%axis image off
%hold on
%ax = axis;
%plot([ax(1) ax(2) ax(2) ax(1) ax(1)],...
%     [ax(3) ax(3) ax(4) ax(4) ax(3)])
% 
%figure(2)
%clf
%colormap(gray(256))
%q = double(imread('ambass.jpg'));
%qq = 0.3*q(:,:,1) + 0.59*q(:,:,2) + 0.11*q(:,:,3);
%clf
%imagesc(qq)
%brighten(0.6)
%axis image off
%hold on
%ax = axis;
%plot([ax(1) ax(2) ax(2) ax(1) ax(1)],...
%     [ax(3) ax(3) ax(4) ax(4) ax(3)])
% 
figure(3)
clf
t = linspace(0,2*pi,200);
x = (10 - t).*cos(4.3*t);
y = (10 - t).*sin(4.3*t);
z = 1+t;
surf(x'*[1 1],y'*[1 1],z'*[0 1],z'*[1 1])
colormap(range(gray,.5,.9))
hold on
axis tight
ax = axis;
plot([ax(1) ax(2) ax(2) ax(1) ax(1)],...
      [ax(3) ax(3) ax(4) ax(4) ax(3)])
view([24 65])
axis off

