function obj=cset_spacefilllatt(varargin)
% CSET_SPACEFILLLATT  Wrapper class for space-filling lattices
%
%  OBJ=CSET_SPACEFILLLATT creates a Candidate set which wraps
%  a lattice and sets it to be appropriate for space-filling.
%
%  See CSET_LATTICE for more details
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:34 $

% Created 10/1/2001


prnt=cset_lattice(varargin{:});
prnt=set(prnt,'n',150);
prnt=set(prnt,'g',i_createg(nfactors(prnt),150));
obj.version=1;

obj=class(obj,'cset_spacefilllatt',prnt);
return


function g=i_createg(nf, N)
% create a vector of primes, g, all less than N and preferably different
g=primes(max(N,30));
g=g(5:end);
if length(g)<nf
   g=g(floor(rand(1,nf)*(length(g)))+1);
else
   g=g(randperm(length(g)));
   g=g(1:nf);
end
return