% f4_4
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.4')

clear, clf
for m=1:4

x= [1 2 3 4 5 6 7 8];
y = zeros(size(x)); y(m)=1;
xi=1:0.1:8;
yi=ones(size(xi));

 for k=1:8
if m ~= k
yi = yi.*(xi - x(k))./ (x(m) - x(k));
end
end
if m==1 subplot(221),
title('u1'), end
if m==2 subplot(222), end
if m==3 subplot(223), end
if m==4 subplot(224), end
plot(xi,yi, x,y,'o')
xlabel('x'); ylabel('y')
if m==1 
        title('v1(x)'), end
if m==2 title('v2(x)'), end
if m==3 title('v3(x)'), end
if m==4 title('v4(x)'), end

end 
