% L2_31 illustrates plotting points interactively  
% by clicking mouse. Command ginput is used. 
% See Fig. 2.35.  More application of ginput is found 
% in k_wheel in Example 9.3. Copyright S. Nakamura, 1995 
clear, clf, hold off
set(gcf, 'NumberTitle','off','Name', 'Figure 2.35')

axis([0,10,0,10])
disp 'Click mouse any where inside axis.  Different buttons'
disp 'will mark different symbols.  To terminate, click in the box'
hold on
plot([1,2,2,1,1],[2,2,3,3,2])
text(1,1.6,'Click inside the box to terminate')
while 1
   [x,y,button] = ginput(1);
   if button==1, plot(x,y,'+r'), end
   if button==2, plot(x,y,'oy'), end
   if button==3, plot(x,y,'*g'), end
   if x>1 & x<2 & y>2 & y<3, break;end
end
hold off
