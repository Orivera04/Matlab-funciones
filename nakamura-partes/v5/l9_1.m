% L9_1 same f9_3 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.3; List 9.1')

clear, clf
x=0:4;
x(2) = 0.5; x(4)=3.5;
y = [0 2 -2 2 0];
xp=0:0.05:4; % fine points for which spline
             % function is to be computed
h = xp(2)-xp(1);
yp = spline(x,y,xp);
n=length(xp);
for i=2:n-1
      ypd(i) = (yp(i-1) - 2*yp(i) + yp(i+1))/h^2;
end
ypd(1)=ypd(2)*2 - ypd(3);      %for graphics only
ypd(n)=ypd(n-1)*2 - ypd(n-2);  %for graphics only
plot(xp,yp,  xp,ypd/10, '--')
hold on
plot(x,y,'o')
xlabel('X')
ylabel('Y')
set(gca, 'FontSize',[12])
text(1,1.5,'C-spline','FontSize',[12])
text(0.3,2.3,'o: data points    -- (2nd deriv.) times (1/10)', ...
'FontSize',[12])
