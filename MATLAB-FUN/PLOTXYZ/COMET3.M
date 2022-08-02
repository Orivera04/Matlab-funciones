function comet3(x,y,z,p)
%COMET3	3-D Comet plot.
%	COMET3(Z) displays an animated three dimensional plot of the vector Z.
%	COMET3(X,Y,Z) displays an animated comet plot of the curve through the
%	points [X(i),Y(i),Z(i)].
%	COMET3(X,Y,Z,p) uses a comet of length p*length(Z). Default is p = 0.1.
%	COMET3, by itself, is self demonstrating.
%	Example:
%	    t = -pi:pi/500:pi;
%	    comet3(sin(5*t),cos(3*t),t)
%	See also QUAKEDEMO, COMET.

%	Charles R. Denham, MathWorks, 1989.
%	Revised 2-9-92, LS and DTP; 8-18-92, 11-30-92 CBM.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0,
   z = -pi:pi/500:pi;
   y = cos(3*z);
   x = sin(5*z);
   p = 0.1;
else
  if nargin < 3, z = x; x = 1:length(z); y = 1:length(z); end
  if nargin < 4, p = 0.10; end
end

clf
axis([min(x(finite(x))) max(x(finite(x))) min(y(finite(y)))  ...
      max(y(finite(y))) min(z(finite(z))) max(z(finite(z)))])

% Cyan circle head, yellow line body, and magenta line tail.
head = line('color','c','linestyle','o','erase','xor','xdata',x(1),'ydata',y(1), ...
       'zdata',z(1));
body = line('color','y','linestyle','-','erase','none','xdata',[],'ydata',[], ...
       'zdata',[]);
tail = line('color','m','linestyle','-','erase','none','xdata',[],'ydata',[], ...
       'zdata',[]);

m = length(z);
k = round(p*m);

% Grow the body
for i = 2:k+1
   j = i-1:i;
   set(head,'xdata',x(i),'ydata',y(i),'zdata',z(i))
   set(body,'xdata',x(j),'ydata',y(j),'zdata',z(j))
   drawnow
end

% Primary loop
m = length(x);
for i = k+2:m
   j = i-1:i;
   set(head,'xdata',x(i),'ydata',y(i),'zdata',z(i))
   set(body,'xdata',x(j),'ydata',y(j),'zdata',z(j))
   set(tail,'xdata',x(j-k),'ydata',y(j-k),'zdata',z(j-k))
   drawnow
end

% Clean up the tail
for i = m+1:m+k
   j = i-1:i;
   set(tail,'xdata',x(j-k),'ydata',y(j-k),'zdata',z(j-k))
   drawnow
end
