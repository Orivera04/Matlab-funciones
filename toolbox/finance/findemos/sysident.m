function out = sysident(fun,indata,x)
%SYSIDENT System Identification data prediction.
%   OUT = SYSIDENT(FUN,INDATA,X) uses a given System Identification
%   Toolbox model to forecast the next value of a time series.
%   FUN is the model to use, i.e. 'ar   ', INDATA is the input-output
%   data to be used in the analysis, and X is the polynomial coefficient.
%
%   For example, sysident('bj   ',[ibm(:,4) ibm(:,5) ibm(:,3],10).

%       Author(s): C.F.Garvin
%       Copyright 1995-2002 The MathWorks, Inc.
%       $Revision: 1.11 $   $Date: 2002/04/14 21:43:30 $

[row,col] = size(indata);
if fun == 'ar   ' | fun == 'iv   '
    nn = x;
elseif fun == 'armax' 
  if col == 1
    nn = [x x];
  else
    nb = x(:,ones(col-1,1));
    nk = nb/x;
    nn = [x nb x nk];
  end
elseif fun == 'arx  '
  nb = x(:,ones(col-1,1));
  nk = nb/x;
  nn = [x nb nk];
elseif fun == 'oe   '
  nb = x(:,ones(col-1,1));
  nf = nb;
  nk = nb/x;
  nn = [nb nf nk];
elseif fun == 'bj   '
  nb = x(:,ones(col-1,1));
  nf = nb;
  nk = nb/x;
  nn = [nb x x nf nk];
elseif fun == 'iv4  '
  nn = [col-1 x*ones(1,col-1) ones(1,col-1)];
elseif fun == 'pem  '
  nb = x(:,ones(col-1,1));
  nf = nb;
  nk = nb/x;
  nn = [x nb x x nf nk];
end

midp = floor(row-row/2);
eval(['th = ',fun,'([indata(1:midp,:)],nn);'])
if isempty(th)
  errordlg('No model returned.  Please respecify inputs.','Error');
  out = [];
  return
end
subplot(2,1,1)
yp = predict([indata],th,1);
yp = [0;yp];
indata(row+1,1) = nan;
index = row+1-row/2:row+1;
plot(index,yp(fix(index)),'o')
hold on
plot(index,indata(fix(index),1),'x')
plot(index,[yp(fix(index)) indata(fix(index),1)])
hold off
ax = axis;
grid on
dateaxis('x',12,'Jan-01-1995')
xlabel('o: estimated,  x: actual')
ylabel('Price ($)')
title('Output')
d1 = yp(3:row+1)-indata(2:row,1);
subplot(2,1,2),plot(d1),set(gca,'xlim',[ax(1) ax(2)])
grid on
dateaxis('x',12,'Jan-01-1995')
ylabel('Dollars')
title('Estimation Error')

if nargout == 1
  out = yp;
end
