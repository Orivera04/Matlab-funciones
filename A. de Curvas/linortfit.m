function x=linortfit(xdata,ydata)
%%%% help linortfit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orthogonal linear least square fit of xdata and ydata vectors
% p=linortfit(xdata,ydata) gives the the coefficient-vector p that
% corresponds to the linear expression: y=p(1)+p(2)*x, where p
% is minimized with respect to the objective function
% sum((p(1)+p(2)*xdata-ydata).^2/(1+p(2)^2)).
%
% Example:
%
% %prepare some data
% xdata=0:0.1:10;
% ydata=2+7*xdata+6*randn(size(xdata));
% %orthogonal linear fit
% p=linortfit(xdata,ydata)
% yy=p(1)+p(2)*xdata;
% %compare with normal linear regression
% p0=polyfit(xdata,ydata,1);
% yy0=polyval(p0,xdata);
% %plot to compare data with linear fits
% plot(xdata,ydata,'.',xdata,yy,xdata,yy0,':');
%
%%%% By Per Sundqvist, 2005-01-11

fun=inline('sum((p(1)+p(2)*xdata-ydata).^2)/(1+p(2)^2)','p','xdata','ydata');
x0=flipdim(polyfit(xdata,ydata,1),2);
options=optimset('TolX',1e-6,'TolFun',1e-6);
x=fminsearch(fun,x0,options,xdata,ydata);

