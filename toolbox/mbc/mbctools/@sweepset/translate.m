function S=Translate(S,M,C);
% SWEEPSET/TRANSLATE translate units in sweepset
%
% S= translate(S,M,C);
%   translates the units using the conversion factors in M (gain) and C (offset)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:45 $



for i= 1:size(S,2)
   S.data(:,i) = M(i)*S.data(:,i) + C(i);
   bdind= find(S.baddata(:,i));
   S.baddata(bdind,i)=  M(i)*S.baddata(bdind,i) + C(i);
end
   