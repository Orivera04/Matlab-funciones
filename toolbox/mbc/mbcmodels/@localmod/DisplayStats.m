function [Stats,RMSE,InSig]= DisplayStats(L);
% LOCALMOD/DISPLAYSTATS display statistics for localmod
%
% [Stats,RMSE,InSig]= DisplayStats(L);
%  Outputs
%    Stats = [rf std(rf)]
%    RMSE  = sweep RMSE
%    Insig = Insignificant rfs abs(t) < tinv(0.99,df)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:38:37 $

% rfs

warning([mfilename, 'is obsolete. Please report to The MathWorks Ltd (UK).'])
[Vals,Bad]= evalfeatures(L);
Vals(Bad)=NaN;


[ri,s2,df]= var(L);
RMSE= sqrt(s2);

% should really use X data here
S= sigma(L);
% display rf and std
Stats= [Vals(:) sqrt(diag(S))];

InSig= abs(Stats(:,1)./Stats(:,2))<tinv(0.99,df);
