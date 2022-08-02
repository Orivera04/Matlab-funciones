x = 0.1:0.4:pi-0.2;
y = sin(x);
xi=linspace(0,pi,100);
s = {'nearest','linear','spline','pchip','v5cubic'};
for i= 1:length(s)
  subplot(1,length(s),i);
  yi = interp1(x,y,xi,s{i});
  plot(x,y,'r+',xi,yi,'b-');
  axis([0,pi,0,1]);
  title(['\bf' s{i}], 'fonts',14);
end;
