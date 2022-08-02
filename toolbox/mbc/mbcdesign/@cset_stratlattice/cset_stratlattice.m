function obj=cset_stratlattice(varargin)
% CSET_STRATLATTICE Stratified Lattice CandidateSet generator object
%
%  OBJ=CSET_STRATLATTICE
%  OBJ=CSET_STRATLATTICE(CS)
%  OBJ=CSET_STRATLATTICE(STRUCT)
%  OBJ=CSET_STRATLATTICE(OPTS)
%  OBJ=CSET_STRATLATTICE(CS,OPTS)
%
%   Where OPTS={{LIMITS},g,Nlevels,N};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:01:15 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.g= varargin{2}{2};
    obj.Nlevels= varargin{2}{3};
    obj.N= varargin{2}{4};
    obj=doRealGCalc(obj);
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        obj.g= i_createg(nfactors(cs),10000);
        obj.Nlevels= zeros(size(obj.g));
        obj.Nlevels(end)=3;
        obj.N= 10000;
        obj=doRealGCalc(obj);
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        cs= rmfield(cs,'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs= candidateset(lims);
        obj.g= varargin{1}{2};
        obj.Nlevels= varargin{1}{3};
        obj.N= varargin{1}{4};
        obj=doRealGCalc(obj);
    end
else
    cs= candidateset(repmat([-1 1],4,1));
    obj.g= i_createg(4,10000);
    obj.Nlevels= zeros(size(obj.g));
    obj.Nlevels(end)=3;
    obj.N= 10000;
    obj.RealG=obj.g;  obj.RealG(end)=10000/3;
    obj.ScaleFudge=[1 1 1 obj.RealG(end)];
end

obj.version=1;
obj=class(obj,'cset_stratlattice',cs);
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
