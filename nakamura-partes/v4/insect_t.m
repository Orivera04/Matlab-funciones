% Illustrates application of insect_.
% Right side of Figure 2.30 was plotted by this M-file.
% Copyright S. Nakamura, 1995 
clear, clg
set(gcf, 'NumberTitle','off','Name', 'insect_t')
axis([-0, 10, -0, 10])
axis('square')  
for k=1:20
  r  = rand(size(1:6));
  r(1:4)=r(1:4)*10; 
  p1 = [r(1), r(2)];
  p2 = [r(1)+(2*r(5)-1)*2, r(2)+(2*r(6)-1)*2];
  insect_(p1,p2)*2;
end
axis('off')
