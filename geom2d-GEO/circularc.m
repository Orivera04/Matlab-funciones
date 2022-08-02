function hl=circularc(varargin)
%CIRCULARC Draw Circular Arc Using Line Object.
% Hl=CIRCULARC(X,Y) draws a circular arc on the current axes where
% X and Y are three element vectors containing x- and y- coordinates
% of distinct points on the arc. The first element marks the start of 
% the arc, the second marks an arbitrary point on the arc, and the last
% marks the end of the arc.
%
% Hl=CIRCULARC(ARC) draws a circular arc in a counterclockwise direction
% on the current axes where ARC = [Xc Yc Ra Astart Aend] is a row vector
% containing the x- and y- coordinates of the arc center in Xc and Yc,
% the radius of the arc in Ra, the starting angle in Astart, and the ending
% angle in Aend.
%
% CIRCULARC(X,Y,'PName',Pvalue,...) or CIRCULARC(ARC,'PName',Pvalue,...)
% sets specified line object property values using the supplied pairs of
% property names and property values.
%
% Hl is the handle of the line object created.

% D.C. Hanselman, University of Maine, Orono, ME  04469-5708
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
% www.eece.maine.edu/mm
% 10/26/03 many bugs fixed

rev=2*pi;
ni=nargin;
if ni==1 | ischar(varargin{2})
   arc=varargin{1}(:);
   if ~isnumeric(arc)| length(arc)~=5
      error('ARC = [Xc Yc Ra Astart Aend] Required.')
   end
   xc=arc(1);
   yc=arc(2);
   rc=abs(arc(3));
   th=rem(arc(4:5),rev);   % wrap angles into one circle
   idx=find(th<0);
   th(idx)=th(idx)+rev;    % make angles positive, 0 to 2pi
   if th(2)<th(1)
      th(2)=th(2)+rev;
   end
   np=max(ceil(abs(th(2)-th(1))*500/(2*pi)),2);
   thp=linspace(th(1),th(2),np);
   PnamePvals=varargin(2:end);
elseif ni==2 | ischar(varargin{3})
   x=varargin{1}(:);
   y=varargin{2}(:);
   if ~isnumeric(x) | ~isnumeric(y) | ...
         length(x)~=3 | length(y)~=3
      error('X and Y must be Numeric Vectors of Length 3.')
   end
   PnamePvals=varargin(3:end);
   
	xy=[x y];   % pack point data into a data matrix
	A=ones(3);  % find center and radius of circle that fits three points
	A(:,1:2)=2*xy;
	b=sum(xy.^2,2);
	def=A\b;
	xc=def(1);  % x center
	yc=def(2);  % y center
	rc=sqrt(xc^2 + yc^2 + def(3));% radius of circle
	xyn=xy-repmat([xc yc],3,1);   % move arc to origin
	th=atan2(xyn(:,2),xyn(:,1));  % angles of points relative to center 
   idx=find(th<0);
   th(idx)=th(idx)+rev;          % make angles positive, 0 to 2pi
   dth=sign(diff([th.' th(1)])); % [tm-ts te-tm ts-te]
   if all(dth==[1 -1 -1])        % handle jump at 2pi to 0 transition
      th(1)=th(1)+rev;
   elseif all(dth==[1 -1 1])
      th(3)=th(3)+rev;
   elseif all(dth==[-1 1 1])
      th(1)=th(1)-rev;
   elseif all(dth==[-1 1 -1])
      th(3)=th(3)-rev;
   end
   np=max(ceil(abs(th(1)-th(3))*500/(2*pi)),2);
   thp=linspace(th(1),th(3),np);
else
   error('Unknown Input Syntax.')
end
if rem(length(PnamePvals),2)
   error('Pairs of Property Names and Property Values Required.')
end

xp=rc*cos(thp)+xc;   % x axis points
yp=rc*sin(thp)+yc;   % y axis points

h=line(xp,yp,'Color','k','Tag','circularc',PnamePvals{:});
if nargout, hl=h; end