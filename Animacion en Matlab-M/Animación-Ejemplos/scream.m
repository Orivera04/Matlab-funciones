function scream
% SCREAM  The Wilhelm scream, a classic film sound bite.
% For over 50 years, this was an in-group joke among
% Hollywood sound editors, who have used in over 130 films.
%    Google: "Wilhelm scream".
%    See: 
%    http:www.youtube.com/watch?v=_PxALy22utc
%    http:en.wikipedia.org/wiki/Wilhelm_scream 
%    http:www.hollywoodlostandfound.net/wilhelm

load wilhelm.mat
fig = figure('position',[400 400 206 134],'menubar', ...
   'none','numbertitle','off','name','Wilhelm scream');
axes('position',[0 0 1 1])
image(W.jpeg)
soundsc(double(W.wave),length(W.wave))
pause(1.5)
close(fig)
