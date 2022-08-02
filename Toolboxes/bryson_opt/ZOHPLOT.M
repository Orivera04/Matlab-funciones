function zohplot(x,y,plotchar)
%ZOHPLOT  Plots the zero-order hold of two columns of data.
% zohplot(x,y,plotchar)
% Plots the zero-order hold of two columns of data. If y is a matrix then
% it plots each column of y vs the vector x; x and y must have the same
% row dimension; x=data in the x coordinate, y=data in the y coordinate,
% plotchar=the line or point-type as in plot(x,y,'plotchar');
% Daniel Abramovitch 2/87; modified 3/87 by FRH. 

[xlen,xwid]=size(x); xlen=xlen-1;
if xlen==0, x=x'; [xlen,xwid]=size(x); xlen=xlen-1; y=y'; end
[ylen,ywid]=size(y); ylen=ylen-1;
if xlen~=ylen
   disp('--ERROR-- xord and yord must have same number of rows')
   return
end
bigx=zeros(2*xlen,1); bigy=zeros(2*ylen,ywid);
txlm1=2*xlen-1; txl=2*xlen; xlp1=xlen+1;
bigx(1:2:txlm1)=x(1:xlen); bigx(2:2:txl)=x(2:xlp1);
bigy(1:2:txlm1,:)=y(1:xlen,:); bigy(2:2:txl,:)=y(1:xlen,:);
if(nargin <= 2), plot(bigx,bigy);
else plot(bigx,bigy,plotchar);
end

