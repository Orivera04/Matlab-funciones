% L2_24 :  Figure 2.21
% Copyright S. Nakamura 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.21')

clear,clf
for i=1:4    %  corresponds to x direction
   for j=1:7 %  corresponds to y direction
      z(j,i) = sqrt(i^2 + j^2);
   end
end
mesh(z)
xlabel('i')
ylabel('j')
zlabel('z')

