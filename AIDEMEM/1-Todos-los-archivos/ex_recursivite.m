function ex_recursivite

global u l d r
u = [0,1]; %up
l = [-1, 0]; %left
d = [0,-1]; %down
r = [1, 0]; %right


function hilbert(level, step)
hilb(up, left, down, right, level, step)

function ex_recursivite
delete(gcf);
hilbert(5)

function hilbert(level)

global st where
st = 1/(2^level+0.5);
u = [0,st]; %up
l = [-st, 0]; %left
d = [0,-st]; %down
r = [st, 0]; %right
where = [st/2, 1-st/2];

axis([0 1, 0, 1]), axis manual off
hold on
hilb(r, d, l, u, level)

function hilb(ri, do, le, up, level, st)
global where

if(level > 0)
  hilb(do, ri, up, le, level-1); 
  xy = where;  where = xy+ri; xy= [xy; where]; 
  plot(xy(:,1), xy(:,2),'r-'); 
  hilb(ri, do, le, up, level-1); 
  xy = where;  where = xy+do; xy= [xy; where]; 
  plot(xy(:,1), xy(:,2),'r-'); 
  hilb(ri, do, le, up, level-1); 
  xy = where;  where = xy+le; xy= [xy; where]; 
  plot(xy(:,1), xy(:,2),'r-'); 
  hilb(up, le, do, ri, level-1); 
end;

