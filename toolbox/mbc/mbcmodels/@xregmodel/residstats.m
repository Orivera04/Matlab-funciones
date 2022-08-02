function Data= residstats(m,X,Y)
% MODEL/RESIDSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:58 $

yhat = EvalModel(m,X);
y= double(Y);
r   = y - yhat;
z=   r/std(r(isfinite(r)));

if iscell(X)
	X= [X{1} expand(X{2},tsizes(X{1}))];
end
Data   = [[1:length(r)]' r,yhat,z,y,double(X)];
