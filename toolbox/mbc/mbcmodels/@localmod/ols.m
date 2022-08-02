function [L,B,Wc,sigma2,J]= ols(L,X,Y,B,Wc);
% LOCALMOD/OLS ordinary least squares (with weights)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:30 $

if nargin<5
   Wc=[];
end

DATA= [X,Y];


% need to initialise parameter estimates
if ~isempty(Wc)
   [res,J,yhat]= gls_costB(B,L,DATA);
   for i=1:size(Y,3)
      if isempty(Wc{i}) & ~isempty(L.covmodel)
         % have to calculate weights
         Wc{i}= choltinv(L.covmodel,yhat{i},X{i});
      end
   end
end

% fit with current weights
[B,yhat,res,J]= gls_fitB(L,B,DATA,Wc);



df= (size(Y,1)- size(Y,3)*size(L,1));

[res,J]= gls_costB(B,L,DATA,Wc);
Cost= sqrt(sum(double(res).^2)/df);

sigma2= Cost.^2;

str= sprintf('   %9s %9s %9s %9s','sigma','norm(B)','norm(C)','cparam');
DisplayFit(L,str);
str= sprintf('OLS:%9.5g ',Cost);
str = [str sprintf('%9.5g ', norm(B),norm(double(L.covmodel)))];
str = [str sprintf('%9.5g ', double(L.covmodel))];
DisplayFit(L,str);
