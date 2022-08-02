function squarrun    
% Example:  squarrun
% ~~~~~~~~~~~~~~~~~~~
%
% Driver program to plot the mapping of a 
% circular disk onto the interior of a square 
% by the Schwarz-Christoffel transformation.
%
% User m functions required: 
%    squarmap, inputv, cubrange

% Illustrate use of the functions input and
% inputv to interactively read one or several 
% data items on the same line

fprintf('\nCONFORMAL MAPPING OF A SQUARE ')
fprintf('BY USE OF A\n')           
fprintf('TRUNCATED SCHWARZ-CHRISTOFFEL ') 
fprintf('SERIES\n\n')

fprintf('Input the number of series ')
fprintf('terms used ')
m=input('(try 20)? ');

% Illustrate use of the function disp
disp('')
str=['\nInput the inner radius, outer ' ...
     'radius and number of increments ' ...
     '\n(try .5,1,8)\n'];
fprintf(str);

% Use function inputv to input several variables
[r1,r2,nr]=inputv; 

% Use function fprintf to print more 
% complicated heading
str=['\nInput the starting value of ' ...
     'theta, the final value of theta \n' ...
     'and the number of theta increments ' ...
     '(the angles are in degrees) ' ...
     '\n(try 0,360,120)\n'];
fprintf(str); [t1,t2,nt]=inputv;

% Call function squarmap to make the plot
hold off; close;
[w,b]=squarmap(m,r1,r2,nr,t1,t2,nt+1);

% Save the plot
% print -deps squarplt 

disp(' '); disp('All Done');

%==============================================

function [w,b]=squarmap(m,r1,r2,nr,t1,t2,nt)
%
% [w,b]=squarmap(m,r1,r2,nr,t1,t2,nt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the conformal mapping
% produced by the Schwarz-Christoffel 
% transformation w(z) mapping abs(z)<=1 inside 
% a square having a side length of two.  The 
% transformation is approximated in series form 
% which converges very slowly near the corners.
%
% m        - number of series terms used
% r1,r2,nr - abs(z) varies from r1 to r2 in 
%            nr steps
% t1,t2,nt - arg(z) varies from t1 to t2 in 
%            nt steps (t1 and t2 are measured 
%            in degrees)
% w        - points approximating the square
% b        - coefficients in the truncated 
%            series expansion which has the 
%            form
%
%            w(z)=sum({j=1:m},b(j)*z*(4*j-3))
%
% User m functions called:  cubrange
%----------------------------------------------

% Generate polar coordinate grid points for the
% map.  Function linspace generates vectors 
% with equally spaced components.
r=linspace(r1,r2,nr)'; 
t=pi/180*linspace(t1,t2,nt);
z=(r*ones(1,nt)).*(ones(nr,1)*exp(i*t));

% Use high point resolution for the 
% outer contour
touter=pi/180*linspace(t1,t2,10*nt);
zouter=r2*exp(i*touter);

% Compute the series coefficients and 
% evaluate the series
k=1:m-1; 
b=cumprod([1,-(k-.75).*(k-.5)./(k.*(k+.25))]);
b=b/sum(b); w=z.*polyval(b(m:-1:1),z.^4);
wouter=zouter.*polyval(b(m:-1:1),zouter.^4);

% Determine square window limits for plotting
uu=real([w(:);wouter(:)]); 
vv=imag([w(:);wouter(:)]);
rng=cubrange([uu,vv],1.1);
axis('square'); axis(rng); hold on 

% Plot orthogonal grid lines which represent 
% the mapping of circles and radial lines
x=real(w); y=imag(w); 
xo=real(wouter); yo=imag(wouter);
plot(x,y,'-k',x(1:end-1,:)',y(1:end-1,:)',...
	'-k',xo,yo,'-k')

% Add a title and axis labels
title(['Mapping of a Square Using a ', ...
       num2str(m),'-term Polynomial'])
xlabel('x axis'); ylabel('y axis')
figure(gcf); hold off;

%==============================================

function range=cubrange(xyz,ovrsiz)
%
% range=cubrange(xyz,ovrsiz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines limits for a square 
% or cube shaped region for plotting data values 
% in the columns of array xyz to an undistorted 
% scale
%
% xyz    - a matrix of the form [x,y] or [x,y,z]
%          where x,y,z are vectors of coordinate
%          points
% ovrsiz - a scale factor for increasing the
%          window size. This parameter is set to
%          one if only one input is given.
%
% range  - a vector used by function axis to set
%          window limits to plot x,y,z points
%          undistorted. This vector has the form
%          [xmin,xmax,ymin,ymax] when xyz has
%          only two columns or the form 
%          [xmin,xmax,ymin,ymax,zmin,zmax]
%          when xyz has three columns.
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, ovrsiz=1; end
pmin=min(xyz); pmax=max(xyz); pm=(pmin+pmax)/2;
pd=max(ovrsiz/2*(pmax-pmin));
if length(pmin)==2
  range=pm([1,1,2,2])+pd*[-1,1,-1,1];
else
  range=pm([1 1 2 2 3 3])+pd*[-1,1,-1,1,-1,1];
end

%==============================================

% function varargout=inputv(prompt)
% See Appendix B
