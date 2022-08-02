function [data,factors,specialPlots,olIndex]= diagnosticStats(m,X,Y)
% LOCALMOD/diagnosticStats
% 
% [data,factors,specialPlots,olIndex]= diagnosticStats(m)
%
% This is an overloaded function to return
% stats and factors for the diagnostic plots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:38:55 $



% This returns the names of the statistics
% sname= get(X,'name');
% snamey= get(Y,'name');
sname = InputLabels(m);
snamey= ResponseLabel(m);

if isTBS(m) | isTransOneSide(m)
    snamey = [snamey '(transformed)'];
    factors=[sname(:)',...
            {'Residuals (transformed)',...
                'Weighted residuals',...
                'Studentized residuals',...
                snamey,...
                ['Predicted ',snamey],...
                'Leverage',...
                'Obs. number'}];
else
    % make it a row
    factors=[sname(:)',...
            {'Residuals',...
                'Weighted residuals',...
                'Studentized residuals',...
                snamey,...
                ['Predicted ',snamey],...
                'Leverage',...
                'Obs. number'}];
end
% This is a list of special plots. This can be empty
specialPlots= {'Local response',...
      'Normal plot'};

if nfactors(m)==2 & all(InputFactorTypes(m)==1)
	specialPlots= [specialPlots  {'Contour','Surface'}];
end

olIndex=[];

[xs,ys,OK]= checkdata(m,X,Y);
if ~OK(1)
   data=zeros(0,length(factors));
   return
end
X= invcode(m,xs{1});
Y= ys{1};
xd= xs{1};
[Xd,Y]= symmetric(m,xd,Y);

[r,J,yhat]= lsqcost(m,Xd,Y);

df= (length(Y)-size(m,1));
if df~=0
   RMSE= sqrt(sum(r.^2)/df);
else
   RMSE=0;
end

if ~isempty(m.covmodel);
   Wc= choltinv(m.covmodel,yhat,Xd);
   [rw,Jw]= lsqcost(m,Xd,Y,Wc);
   [Q,R]= qr(Jw,0);
   Qw= Wc\Q;
   lev= sum(Q.^2,2);
   hi= diag(cov(m.covmodel,yhat,Xd))- sum(Qw.^2,2);
else
   rw= r;
   Jw= J;
   
   [Q,R]= qr(J,0);
   %P= eye(size(J,1)) - Q*Q';
   lev = sum(Q.^2,2);
   hi = 1-lev;
end
if RMSE~=0
   rw = rw/RMSE;
   tol= max(hi)*1e-8;
   hi= max(tol,sqrt(hi));
   rs=zeros(size(r));
   rs(hi>tol) = r(hi>tol)./hi(hi>tol)/RMSE;
else
   % all residuals will be zero
   rs= r;
end
obs=[1:length(r)]';
data= [r,...
      rw,...
      rs,...
      Y,...
      yhat,...
      lev,...
      obs];
data=[X data(1:size(xs,1),:)];

% outlier index.
olIndex= outliers(m,data,factors);
