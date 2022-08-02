function dout=createcandset(din,cs,varargin)
% CREATECANDSET  Set up sensible candidate defaults
%
%   D=CREATECANDSET(D,TP) sets up a candidate set with "good"
%   properties.  TP indicates the candidate set type - 'fullgrid',
%   'lattice10k', etc.
%
%   For example, asking for a lattice will, if possible, set up a
%   lattice using prime number generators which are known to work.
%
%   The current available presets are:
%
%       'FULLGRID' 
%       'LATTICE'
%       'GRIDLATT'
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:21 $

% Created 21/6/2000



switch lower(cs)
case 'lattice'
   % preset decent numbers
   g=[9257  977  5689  5179  2579 101];
   nf=nfactors(din);
   N=10000;
   if nf>6
      %make up some extra random ones - probably no good, but I can't do much about that!
      p=primes(N);
      p=p(25:end);
      p=setdiff(p,g);
      p=p(randperm((length(p))));
      g=[g p(1:(nf-6))];
   elseif nf<6
      g=g(1:nf);
   end
	lims= gettarget(model(din));
   dout = candspace(din,'lattice',num2cell(lims,2)',g,N);
case 'fullgrid'
   
case 'gridlatt'
   
end
return
   



