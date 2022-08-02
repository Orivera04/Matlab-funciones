[x,y]=meshgrid(-2:.1:2,-2:.1:2);
z=3*ones(41,41);
surf(x,y,z,'AlphaDataMapping','scaled',...
'AlphaData',gradient(z),'FaceColor','green');alpha(0.5);
hold on;
w=x.^2+y.^2;
surf(x,y,w,'AlphaDataMapping','scaled',...
     'AlphaData',gradient(z),'FaceColor','red');alpha(0.5);
h=3;
r=sqrt(3);
c=[0 0];
cilindrofC(h,r,c)
 