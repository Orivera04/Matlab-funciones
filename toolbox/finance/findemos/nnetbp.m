function nnetbp(indat,pts,N,neurons)
%NNETBP Neural Net Fast Backpropagation demo for Financial Expo.
%   PRED = NNETBP(INDAT,PTS,N,NEURONS) Neural Network Fast Backpropagation       
%   demonstration for Financial Expo.  PTS species the total number of data
%   set points to be used.  N is the number of points in PTS which are used
%   to predict the next output.  NEURONS specifies the number of hidden 
%   neurons to be used by the neural network.
%         
%   For example, from a data set of 300 points (PTS = 300), use 10 points
%   (N = 10) at a time to predict the next point.  That is, the first 10
%   points are used to predict the 11th point, points 2 through 11 are used
%   to predict the 12th point and so on.  Increase the number of NEURONS
%   being used for more accurate results.
%   
%   This function is called by NEURDEMO.M.

%       Author(s): C.F. Garvin, 6-21-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.9 $   $Date: 2002/04/14 21:43:46 $


[rn,cn] = size(indat);

if pts >= rn-N-25                                       % PTS must be < ROW
   pts = rn-N-25;
end

if cn == 1
  errordlg('Please specify at least one Input.');
  return
elseif cn == 2
  P = delaysig(indat(1:pts,2)',1,N);
  T = diff(indat(N:pts,1)');
  P(:,1:N) = [];
  TESTP = delaysig(indat(pts+1:pts+26,2)',1,N);
else
  P = indat(1:pts,2:cn)';                        % Specify input data
  T = diff(indat(1:pts+1,1)');                    % Specify target data
  TESTP = indat(pts+1:pts+26,2:cn)';
end

tp = [10 100 .01];
[w1,b1,w2,b2] = initff(P,neurons,'tansig',1,'purelin');
TRFIG = figure('Numbertitle','off','Name','Training...');
[w1,b1,w2,b2] = trainbpx(w1,b1,'tansig',w2,b2,'purelin',P,T,tp);
pred = simuff(TESTP,w1,b1,'tansig',w2,b2,'purelin');
close(TRFIG)
actual = diff(indat(pts+N:pts+N+25,1))';         % Known output
subplot(2,1,1)                                   % Plot actual and predicted
plot(1:25,actual,'-',1:26,pred,'--',1:25,actual,'o',1:26,pred,'x')
grid on
title('Fast Backpropagation Estimation')
xlabel('O: actual  X: estimated')
ylabel('Daily Price Change Difference ($)')
ax = axis;
dateaxis('x',6,today+pts)
subplot(2,1,2),plot(1:25,actual-pred(1:25),'-',1:25,actual-pred(1:25),'o')
set(gca,'xlim',[ax(1) ax(2)])
grid on
title('Estimation Error')
ylabel('Dollars')
dateaxis('x',6,today+pts)
