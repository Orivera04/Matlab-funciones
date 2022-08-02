function fuzfunc(indat,pts,N)
%FUZFUNC Fuzzy Logic Price Estimation demonstration for the MATLAB
%        Financial Expo.

%       Author(s): C.F. Garvin, 9-26-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.9 $   $Date: 2002/04/14 21:43:11 $

[row,col] = size(indat);
if col == 2
  DATA = delaysig(diff(indat(:,2)'),1,N);
  DATA(:,1:N) = [];
  DATA(1,:) = diff(indat(N+1:row,1)');
else
  DATA = [diff(indat(:,1)) diff(indat(1:row,2:col))]';
end
di = DATA(:,1:pts)';                         % Input data
do = DATA(1,2:pts+1)';                       % Output data
chdi = DATA(:,pts+1:pts+25)';                % Test input
chdo = DATA(1,pts+2:pts+26)';                % Test output
fismat = genfis2(di,do,.5);
fuzout = evalfis(di,fismat);
trnRMSE = norm(fuzout-do)/sqrt(length(fuzout));
chfuzout = evalfis(chdi,fismat);
chRMSE = norm(chfuzout-chdo)/sqrt(length(chfuzout));
subplot(2,1,1)
plot(chdo)
hold on
plot(chdo,'o')
plot(chfuzout,'m-')
plot(chfuzout,'mx')
dateaxis('x',6,today+pts)
xlabel('O: actual  X: estimated')
ylabel('Daily Price Change Difference ($)')
title('Fuzzy Inference System Estimation')
grid on
hold off
subplot(2,1,2)
plot(chfuzout-chdo)
hold on
plot(chfuzout-chdo,'o')
dateaxis('x',6,today+pts)
ylabel('Dollars')
title('Estimation Error')
grid on
hold off
