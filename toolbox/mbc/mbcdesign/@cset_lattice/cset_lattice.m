function obj=cset_lattice(varargin)
% CSET_LATTICE  Lattice CandidateSet generator object
%
%  OBJ=CSET_LATTICE
%  OBJ=CSET_LATTICE(CS)
%  OBJ=CSET_LATTICE(STRUCT)
%  OBJ=CSET_LATTICE(OPTS)
%  OBJ=CSET_LATTICE(CS,OPTS)
%
%   Where OPTS={{LIMITS},g,N};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:01:00 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.g= varargin{2}{2};
    obj.N= varargin{2}{3};
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        obj.g= i_createg(nfactors(cs),10000);
        obj.N= 10000;
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        cs= rmfield(cs,'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs= candidateset(lims);
        obj.g= varargin{1}{2};
        obj.N= varargin{1}{3};
    end
else
    cs= candidateset(repmat([-1 1],4,1));
    obj.g= i_createg(4,10000);
    obj.N= 10000;
end

obj.version=1;
obj=class(obj,'cset_lattice',cs);
return




function g=i_createg(nf, N)
% create a vector of primes, g, all less than N and preferably different
g=primes(max(N/50,30));
g=g(5:end);
if length(g)<nf
    g=g(floor(rand(1,nf)*(length(g)))+1);
else
    g=g(randperm(length(g)));
    g=g(1:nf);
end
return
