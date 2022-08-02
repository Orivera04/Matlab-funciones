function pos = pickbox(m,n,boxnum,xgap,ygap,lspace,rspace,tspace,bspace)

% function pos = pickbox(m,n,boxnum,xgap,ygap,lspace,rspace,tspace,bspace)
% 
% Returns a vector, pos = [left bottom width height] corresponding to box
% number 'boxnum' out of an array of boxes on the page.  
%
% 'Boxnum' starts from 1 at the top left hand corner of the page and
% increases from left to right and from top to bottom. The page is divided
% into m boxes in the vertical direction and n boxes in the horizontal
% direction.
%
% If the argument "space" is present then a certain amount of whitespace
% will be added between the plots to allow for axes, labels etc.  space=0
% means no space, space=1 is lots of space (the default value is
% space=0.05).  space is in screen coordinates.
%
% pos can be used as input to the axes command to define a plot area.
%
% lspace, rspace, tspace, bspace if present, refer, respectively, to regions
% left blank at the left, right, top and bottom of the figure. They are
% specified in normalised units and the default is 0.1.
%
% If only xgap is given then ygap=xgap, otherwise the x and y
% whitespace is given separately.  

% (A. Knight Oct. 1992) 

if nargin<4 
  xgap = 0.05; 
  ygap = 0.05; 
end 
if nargin<5 
  ygap = xgap;
end
if nargin<6
  lspace = 0.1;
  rspace = 0.1;
  tspace = 0.1;
  bspace = 0.1;
end
if nargin<7
  rspace = 0.1;
  tspace = 0.1;
  bspace = 0.1;
end
if nargin<8
  tspace = 0.1;
  bspace = 0.1;
end 
if nargin<9
  bspace = 0.1;
end  

nx = rem(boxnum - 1,n) + 1;
ny = fix((boxnum - 1)/n) + 1;
xtotal = 1 - lspace - rspace;
xleft = lspace + xtotal*(nx - 1)/n;
xright = xleft + xtotal*1/n;

ytotal = 1 - tspace - bspace;
ybot = 1 - tspace - ytotal*ny/m;
ytop = ybot + ytotal*1/m;

left = xleft;
width = xright - xleft - xgap;

bot = ybot;
height = ytop - ybot - ygap;
								 
pos = [left bot width height];

