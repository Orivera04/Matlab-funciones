function drawangle(xv,yv,col,ref_axis,r)
%DRAWANGLE   Draw semi-circle indicating the angle of the given line.
%     DRAWANGLE(xv,yv) plots a semi-circle touching the line and 
%     the x-axis indicating the angle of the line w.r.t the x-axis.
%     The line is defined by the vectors as, xv=[x1,x2], yv=[y1,y2].
%
%     DRAWANGLE(xv,yv,col) plots the semi-circle with color defined in
%     col. Default is red. 
%
%     DRAWANGLE(xv,yv,col,ref_axis) plots the semi-circle w.r.t the 
%     axis specified in ref_axis. Default is x-axis.
% 
%     DRAWANGLE(xv,yv,col,ref_axis,r), r is the radius of the semi-circle. 
%     With 1 as the default value.  
%
%     Examples 1:
%               x1 = [15 10]; y1 = [15 10]; 
%               line(x1,y1,'LineWidth',2), hold on
%               drawangle(x1,y1),grid, hold off
%
%     Examples 2:
%               x1 = [15 10]; y1 = [15 10]; 
%               line(x1,y1,'LineWidth',2), hold on
%               drawangle(x1,y1,'k','y',1),grid, hold off
%
%     Examples 3:
%               x1 = [5 10]; y1 = [15 10]; 
%               line(x1,y1,'LineWidth',2), hold on
%               drawangle(x1,y1,'k','x',1),grid, hold off
%
%     Examples 4:
%               x1 = [5 10]; y1 = [15 10]; 
%               line(x1,y1,'LineWidth',2), hold on
%               drawangle(x1,y1,'k','y',1),grid, hold off
%
%     Examples 5:
%               x1 = [15 5 5 15]; y1 = [15 15 5 5]; 
%               ref_axis = ['x','y']; xc = 10; yc = 10;
%               col = ['g' 'r' 'c' 'm' 'y' 'k']; colcount = 1;
%               for j = 1:length(ref_axis)
%                   for i = 1:length(x1)
%                       line([x1(i) xc],[y1(i) yc],'LineWidth',2),hold on
%                       drawangle([x1(i) xc],[y1(i) yc],col(colcount),ref_axis(j),1)
%                       colcount = colcount +1;
%                       if colcount > length(col), colcount = 1; end
%                   end
%               end, hold off, grid
%

%  Author : Mirza Faisal Baig
%  Version: 1.0
%  Date   : January 26, 2004

if nargin < 2
    error('Not enough input arguments. Please specify x and y vectors specifying start and end points of the line ')
elseif nargin < 3
    col = 'r'; ref_axis = 'x'; r = 1;
elseif nargin < 4
    ref_axis = 'x'; r = 1;
elseif nargin < 5
    r = 1;
end
if isempty(col), col = 'r'; end
if isempty(ref_axis), ref_axis = 'x'; end
if isempty(r), r = 1; end
lx = length(xv);
ly = length(yv);
if lx ~= ly
    error('x and y must be of same length')
end
if lx ~= 2
    error('x or y must have vectors of length 2 representing start and end points of the line')
end
    
x1 = xv(1); x_c = xv(2);
y1 = yv(1); y_c = yv(2);

m = (y1-y_c)/(x1-x_c);
x11 = 1+x_c;
y11 = m*(x11-x1)+y1;
a = 1+m^2;
b = 2*m*y11-2*m^2*x11-2*x_c-2*m*y_c;
c = x_c^2+m^2*x11^2+y11^2+y_c^2-2*y_c*y11-2*m*x11*y11+2*m*x11*y_c-r^2;

if ref_axis == 'x'
    if x1 > x_c & y1 > y_c
        x_12 = (-b+sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        y2 = y_12:-0.0001:y_c-0.0001;
        x2 = real(sqrt(r^2-(y2-y_c).^2))+x_c;
    elseif x1 < x_c & y1 > y_c
        x_12 = (-b-sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        x2 = x_12:-0.0001:x_c-r-0.0001;
        y2 = real(sqrt(r^2-(x2-x_c).^2))+y_c;
    elseif x1 < x_c & y1 < y_c
        x_12 = (-b-sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        y2 = y_12:0.001:y_c;
        x2 = -real(sqrt(r^2-(y2-y_c).^2))+x_c;
    elseif x1 > x_c & y1 < y_c    
        x_12 = (-b+sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        x2 = x_c+r:-0.0001:x_12;
        y2 = -real(sqrt(r^2-(x2-x_c).^2))+y_c;        
    end        
elseif ref_axis == 'y'
    if x1 > x_c & y1 > y_c
        x_12 = (-b+sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        x2 = x_12:-0.0001:x_c-0.0001;
        y2 = real(sqrt(r^2-(x2-x_c).^2))+y_c;
    elseif x1 < x_c & y1 > y_c
        x_12 = (-b-sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;        
        x2 = x_12:0.0001:x_c+0.001;
        y2 = real(sqrt(r^2-(x2-x_c).^2))+y_c;
    elseif x1 < x_c & y1 < y_c
        x_12 = (-b-sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;  
        y2 = y_12:-0.0001:y_c-r-0.0001;
        x2 = -real(sqrt(r^2-(y2-y_c).^2))+x_c;     
    elseif x1 > x_c & y1 < y_c   
        x_12 = (-b+sqrt(b^2-4*a*c))/(2*a);
        y_12 = m*x_12 - m*x11 + y11;
        y2 = y_c-r:0.0001:y_12;
        x2 = (real(sqrt(r^2-(y2-y_c).^2))+x_c);
    end
else 
    error('Reference axis not recognizable')
end
plot(x2,y2,'color',col,'LineWidth',2)