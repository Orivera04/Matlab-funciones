function pred = nnetlin(indat,pts,N,dummyin)
%NNETLIN Linear Neural Network demo for Financial Expo.
%   NNETLIN is a Neural Network example for predicting future stock prices
%   using linear prediction methods.
%   SOLVELIN returns the weights and biases based on PTS data points as the
%   input stock prices. The actual and predicted data is plotted
%   along with an error plot of the difference between the actual and
%   predicted data.   
%   This example is part of MATLAB Financial Expo.

%       Author(s): C.F. Garvin, 6-07-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.10 $   $Date: 2002/04/14 21:43:21 $

set(gcf,'pointer','watch')
if nargin < 2
  pts = 50;
end
[row,col] = size(indat);                              % determine data size

if pts >= row-N-25                                       % PTS must be < ROW
   pts = row-N-25;
end
if col == 1
  errordlg('Please specify at least one Input.');
  return
elseif col == 2
  P = delaysig(indat(1:pts,2)',1,N);
  T = diff(indat(N:pts,1)');
  P(:,1:N) = [];
  TESTP = delaysig(indat(pts+1:pts+26,2)',1,N);
else
  P = indat(1:pts,2:col)';                        % Specify input data
  T = diff(indat(1:pts+1,1)');                    % Specify target data
  TESTP = indat(pts+1:pts+26,2:col)';
end
[w,b] = solvelin(P,T);                           % Linear solver
pred = simulin(TESTP,w,b);                       % Simulate linear layer
actual = diff(indat(pts+N:pts+N+25,1))';          % Known output
subplot(2,1,1)                                   % Plot actual and predicted
plot(1:25,actual,1:26,pred,'--',1:25,actual,'o',1:26,pred,'x')
title('Linear Estimation')
ylabel('Daily Price Change Difference ($)')
xlabel('O: actual  X: estimated')
ax = axis;
dateaxis('x',6,today+pts)
grid on
subplot(2,1,2),plot(1:25,actual-pred(1:25),1:25,actual-pred(1:25),'o') 
title('Estimation Error')
ylabel('Dollars')
set(gca,'xlim',[ax(1) ax(2)])
grid on
dateaxis('x',6,today+pts)
set(gcf,'pointer','arrow')
