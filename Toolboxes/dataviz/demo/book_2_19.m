%  book_2_19.m
%  calls quantileplot

load fusion

%  set uniform plot scale
allMax = max(max(NV),max(VV));
allAxis = [0 1 0 allMax];

subplot(1,2,1)
quantileplot(NV,'Time (seconds)')
axis(allAxis)
axis('square')
grid on
subplot(1,2,2)
quantileplot(VV)
axis(allAxis)
axis('square')
grid on
pos = get(gcf,'Position');
pos(4) = pos(3)/2;
set(gcf,'Position',pos)
papos = get(gcf,'Position');
papos(4) = papos(3)/2;
set(gcf,'Position',papos)
