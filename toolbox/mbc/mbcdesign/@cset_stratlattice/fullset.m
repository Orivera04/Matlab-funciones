function out=fullset(obj);
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:01:16 $

% Created 12/3/2001

out= zeros(obj.N,length(obj.RealG));
lims=limits(obj.candidateset);
% The limits need adjusting to account for the stratification effect
for i=1:length(obj.RealG)
   if obj.Nlevels(i)
      % avoid numerical errors in the rem statement for stratified levels
      nfull = floor(obj.N./obj.Nlevels(i));
      nleft = obj.N - nfull*obj.Nlevels(i);
      base = (0:obj.RealG(i):(obj.N-1))';
      out(1:(end-nleft),i) = repmat(base, nfull, 1);
      out((end-nleft+1):end,i) = base(1:nleft);
   else
      out(:,i)=rem(obj.RealG(i).*(0:(obj.N-1))',obj.N);
   end
end
lowpnt=repmat(lims(:,1)',obj.N,1);
scaling=repmat((diff(lims,1,2)')./(obj.N-obj.ScaleFudge),obj.N,1);
out=lowpnt+out.*scaling;
return