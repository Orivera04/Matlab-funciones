function S3=setsweeps(S1,S2);
% SWEEPSET/SETSWEEPS sets sweep definition 
%
%  S3=setsweeps(S1,S2);
% Defines the sweep information of S1 to be the same as S2 if
% they have the same number of records.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:33 $




if size(S1,1)~=size(S2,1)
   error('Incompatible Sweeps');
end

S3= S1;
S3.xregdataset= S2.xregdataset;