function [X,Y,OK,badIndex]= checkdata(L,X,Y);
% LOCALUSERMOD/CHECKDATA check X and Y data for fitting

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:39 $

if isGrowth(L)
	% remove non-positive data for growth models
	Y(X<=0 | Y <= 0)= NaN;
end

% call localmod/checkdata
[X,Y,OK,badIndex]= checkdata(L.localmod,X,Y,L);