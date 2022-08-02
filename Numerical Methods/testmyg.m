
% Script testmyg.m

format long
disp('        t              mygamma             gamma')
disp(sprintf('\n  _____________________________________________________'))
s = [];
for t=1:.1:2
   s1 = mygamma(t);
   s2 = gamma(t);
   disp(sprintf('%1.14f   %1.14f   %1.14f',t,s1,s2))
end

