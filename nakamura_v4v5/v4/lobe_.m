% lobe_ same as List_B5: plots Figure B.4 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure B.4; lobe_')

clear, clf, hold on
dth=2*pi/40; th=0:dth:2*pi;
r = ones(size(th));
colormap gray
for n=1:51
   b=n-1;
   x(n,:)=cos(th)*(1-0.25*cos(b*0.3));
   y(n,:)=sin(th)*(1+0.25*cos(b*0.3));
   z(n,:)=n*0.3*ones(size(th));
   m=n+9;
   if floor(m/2)*2 == m
      plot3(z(n,:), x(n,:), y(n, :)-5)
   end
end
surfl(z,x,y+5, [0,80])
axis([0 13 -5 15 -10 10])
shading flat
view([10 -10 10])
text(5.2, 8.4, ' Flow direction')
text(-5, 8, 'Nozzle side')
xd= [5, 10, 9];
yd=[5,5, 4.5];
zd=[ 3,3,3];
plot3(xd, yd, zd)
axis('off')
text(10,-15,'Cross sectional views of jet')
hold off

