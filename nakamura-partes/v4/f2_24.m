% f2_24 plots Figure 2.24. 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.24')

clear, clg
for i=1:4;
   for j=1:5;
      z(j,i)=sqrt(i^2 + j^2);
   end
end
subplot(221)
mesh(z)
axis([0,5,0,5,0,10])
title('default view')
xlabel('X')
ylabel('Y')
zlabel('Z')

subplot(222)
mesh(z)
axis([0,5,0,5,0,10])
title('view[35,20]')
view([35,20])
xlabel('X')
ylabel('Y')
zlabel('Z')

subplot(223)
mesh(z)
axis([0,5,0,5,0,10])
title('view[35, -20]')
view([35, -20])
xlabel('X')
ylabel('Y')
zlabel('Z')

subplot(224)
mesh(z)
axis([0,5,0,5,0,10])
title('view[10,90]')
xlabel('X')
ylabel('Y')
zlabel('Z')
view([10,90])
axis('square')

