% Fits curves of degrees 1-3 to temperature
%  data and plots in a subplot
x= 2:6;
y =[65 67 72 71 63];
morex = linspace(min(x),max(x));
for pd = 1:3
   coefs = polyfit(x,y,pd);
   curve = polyval(coefs,morex);
   subplot(1,3,pd)
   plot(x,y,'ro',morex,curve)
   xlabel('Time')
   ylabel('Temperatures')
   title(sprintf('Degree %d',pd))
   axis([1 7 60 75])
end
