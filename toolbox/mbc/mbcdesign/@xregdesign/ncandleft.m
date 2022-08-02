function n=ncandleft(des)
% DESIGN/NCANDLEFT  Number of candidates remaining
%   N=NCANDLEFT(D) returns the number of candidates that
%   are not currently marked as being in the design.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:14 $

% Created 8/11/99

% get total number
n=ncand(des);

if ~des.replicatedpoints
   % get number of unique numbers in design index that are >0
   % but only if we're not allowed replicates; otherwise all
   % the candidate points are always available
   curind=unique(double(des.designindex));
   curind(curind<=0)=[];
   nin=length(curind);
   n=n-nin;
end