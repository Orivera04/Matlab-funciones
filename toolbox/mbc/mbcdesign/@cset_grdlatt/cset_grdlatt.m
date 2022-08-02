function obj=cset_grdlatt(varargin)
% CSET_GRDLATT  Grid/Lattice CandidateSet generator object
%
%  OBJ=CSET_GRDLATT
%  OBJ=CSET_GRDLATT(CS)
%  OBJ=CSET_GRDLATT(STRUCT)
%  OBJ=CSET_GRDLATT(OPTS)
%  OBJ=CSET_GRDLATT(CS,OPTS)
%
%   Where OPTS={{GRIDDIMS,LATDIMS},GRID_LEVELS,LATT_LIMS,g,N};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:00:31 $

if nargin==2
    cs=varargin{1};
    obj.griddims=varargin{2}{1}{1};
    obj.lattdims=varargin{2}{1}{2};
    obj.grid=cset_grid(varargin{2}{2});
    obj.lattice=cset_lattice(varargin{2}(3:5));

    lims=zeros(length(obj.griddims)+length(obj.lattdims),2);
    lims(obj.griddims,:)=limits(obj.grid);
    lims(obj.lattdims,:)=limits(obj.lattice);
    cs=limits(cs,lims);

elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs=varargin{1};
        nf=nfactors(cs);
        obj.griddims=nf;
        obj.lattdims=1:(nf-1);
        lims=limits(cs,nf);
        obj.grid=cset_grid({linspace(lims(1),lims(2),3)});
        obj.lattice=cset_lattice({num2cell(limits(cs,(1:(nf-1))'),2)', i_createg((nf-1),10000), 10000});
    elseif isa(varargin{1},'struct')
        cs=varargin{1}.candidateset;
        cs=rmfield(cs,'candidateset');
    else
        obj.griddims=varargin{1}{1}{1};
        obj.lattdims=varargin{1}{1}{2};
        obj.grid=cset_grid(varargin{1}{2});
        obj.lattice=cset_lattice(varargin{1}(3:5));
        lims=zeros(length(obj.griddims)+length(obj.lattdims),2);
        lims(obj.griddims,:)=limits(obj.grid);
        lims(obj.lattdims,:)=limits(obj.lattice);
        cs=candidateset(lims);
    end
else
    cs=candidateset(repmat([-1 1],4,1));
    obj.griddims=4;
    obj.lattdims=(1:3);
    obj.grid=cset_grid({(-1:1)});
    obj.lattice=cset_lattice({{[-1 1],[-1 1],[-1 1]}, i_createg(3,10000), 10000});
end

obj.version=1;
obj=class(obj,'cset_grdlatt',cs);
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
