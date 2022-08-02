x = linspace(2*pi/3,pi/4,30);
bruit = 0.01*randn(size(x)); s = std(bruit);
y = sin(x); y1 = y+bruit;
errorbar(x,y1,2*s(ones(size(x)))); hold on
plot(x,y,'r--');
count = round(100*sum(abs(y1-y)<2*s)/length(x));
title([num2str(count) '% de points non bruités dans l''intervalle'], ...
      'fontsize', 14); 
