%  book_2_24.m
%  calls normalqqplot

load fusion

ylab = 'Log Time (log_2 seconds)';

%  log transform
NV = log2(NV);
VV = log2(VV);

%  set uniform plot scale
allMax = max(max(NV),max(VV));
allAxis = [-inf inf 0 allMax];

subplot(1,2,1)
normalqqplot(NV,ylab)
axis(allAxis)
axis('square')
subplot(1,2,2)
normalqqplot(VV)
axis(allAxis)
axis('square')
pos = get(gcf,'Position');
pos(4) = pos(3)/2;
set(gcf,'Position',pos)
papos = get(gcf,'Position');
papos(4) = papos(3)/2;
set(gcf,'Position',papos)
