function polyplot    
% Example:  polyplot
% ~~~~~~~~~~~~~~~~~~
% This program illustrates polynomial and
% spline interpolation methods applied to 
% approximate the function 1/(1+x^2). 
%
% User inline functions used: 
%   cbp, Ylsq, yexact 

% Function for Chebyshev data points
cbp=inline(['(a+b)/2+(a-b)/2*cos(pi/n*',...
		    '(1/2:n))'],'a','b','n');

% Polynomial of degree n to least square fit
% data points in vectors xd,yd
Ylsq=inline('polyval(polyfit(xd,yd,n),x)',...
'xd','yd','n','x');

% Function to be approximated by polynomials
yexact=inline('1./(1+abs(x).^p)','p','x');

% Set data parameters. Functions linspace and 
% cbp generate data with even and Chebyshev 
% spacing
n=10; nd=n+1; a=-4; b=4; p=2; 
xeven=linspace(a,b,nd); yeven=yexact(p,xeven);
xcbp=cbp(a,b,nd); ycbp=yexact(p,xcbp);

nlsq=501; % Number of least square points
xlsq=linspace(a,b,nlsq); ylsq=yexact(p,xlsq);

% Compute interpolated functions for plotting
xplt=linspace(0,b,121); yplt=yexact(p,xplt);
yyeven=Ylsq(xeven,yeven,n,xplt);
yycbp=Ylsq(xcbp,ycbp,n,xplt); 
yylsq=Ylsq(xlsq,ylsq,n,xplt);
yyspln=spline(xeven,yeven,xplt);

% Plot results
j=6:nd; % Plot only data points for x>=0 
close; plot(xplt,yplt,'-',xplt,yyeven,'--',...
	xplt,yyspln,'.',xeven(j),yeven(j),...
    's','linewidth',2)
legend('Exact Function',...
	   'Poly. for Even Spacing',...
       'Spline Curve',...
	   'Interpolation Points',2)
title(['SPLINE CURVE AND POLYNOMIAL ',...
		'USING EVEN SPACING'])
xlabel('x axis'), ylabel('function values')
% print(gcf,'-deps','splpofit')
shg, pause
plot(xplt,yplt,'-',xplt,yycbp,'--',...	
xplt,yylsq,'.',xcbp(j),ycbp(j),'s',...
'linewidth',2)
legend('Exact Function',...
       'Poly. for Chebyshev Points',...
       'Least Square Poly. Fit',...
       'Interpolation Points',1)
title(['LEAST SQUARE POLY. AND POLY. ',...
		'USING CHEBYSHEV POINTS'])
xlabel('x axis'), ylabel('function values')
% print(gcf,'-deps','lsqchfit')
shg, disp(' '), disp('All Done')