function edges(h,xs,ys,zs)
%EDGES  Draw edges.
%   EDGES(H,XS,YS,ZS) draws out the edges for a
%   slice plot in figure with handle H, using the
%   slices XS, YS and ZS.

% Copyright (c) 2001-08-22, B. Rasmus Anthin.

figure(h)
ax=axis;
ish=ishold;
hold on
for i=1:length(ys)
   for j=1:length(zs)
      plot3(ax(1:2),ys([i i]),zs([j j]),'k')
   end
end
for i=1:length(zs)
   for j=1:length(xs)
      plot3(xs([j j]),ax(3:4),zs([i i]),'k')
   end
end
for i=1:length(xs)
   for j=1:length(ys)
      plot3(xs([i i]),ys([j j]),ax(5:6),'k')
   end
end
for i=1:length(xs)
   plot3(xs([i i i i i]),ax([3 4 4 3 3]),ax([5 5 6 6 5]),'k')
end
for i=1:length(ys)
   plot3(ax([1 2 2 1 1]),ys([i i i i i]),ax([5 5 6 6 5]),'k')
end
for i=1:length(zs)
   plot3(ax([1 2 2 1 1]),ax([3 3 4 4 3]),zs([i i i i i]),'k')
end
hold off
if ish,hold on,end