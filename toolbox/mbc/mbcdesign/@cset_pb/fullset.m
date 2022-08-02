function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:54 $
nf = nfactors(obj);
lims=limits(obj.candidateset)';

% generate Hadamard matrix
H=hadamard(obj.Nr);
out=H(:,2:nf+1);    % miss out initial column of ones


% re-scale output
for k=1:nf
   out(:,k) = lims(1,k) + (out(:,k)+1).*(lims(2,k)-lims(1,k))./2;
end