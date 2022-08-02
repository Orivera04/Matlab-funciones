function m = mean(S,level);
% SWEEPSET/MEAN sweep mean of data in sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:06:37 $



% Call private mex function GetMean with the data matrix
% and a uint32 version of the dataset sizes. Second tsizes parameter
% is required sweep level

if nargin==1
	level = 1;
end
AsUInt32 = 1;

m = GetMean(S.data, tsizes(S, level, AsUInt32));
