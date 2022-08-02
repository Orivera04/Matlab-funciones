function sseJ = knot_optim(knots,X,Y,k,m,varargin)
% This is the cost function for FminUnc

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:33 $

% if any knots fall outside the interval [-1 1] force them back in
knots(knots<-1)=-1+eps;
knots(knots>1)=1-eps;

h=diff([-1;knots(:);1])./2;
h(h<1e-6)=1e-6;
penalty= -varargin{1}*sum(log((k+1)*h))+1;

m3= set(m.mv3xspline,'knots',knots);

m3=leastsq(m3,X,Y);
sseJ=penalty*sum(abs(Y-m3(X)));

%f=figure(7);
%set(f,'doublebuffer','on');
%plot(X,Y,'bo',...
%   xdata,m.mv3xspline(xdata),'r*-',...
%   knots,0.0005*ones(size(knots)),'b^');
%title([num2str(k),' knots']);grid
%drawnow
%pause(0.1);
