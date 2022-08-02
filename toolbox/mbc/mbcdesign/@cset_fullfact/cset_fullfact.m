function obj=cset_fullfact(varargin)
% CSET_FULLFACT  Full Factorial Design generator object
%
%  OBJ=CSET_FULLFACT
%  OBJ=CSET_FULLFACT(CS)
%  OBJ=CSET_FULLFACT(STRUCT)
%  OBJ=CSET_FULLFACT(OPTS)
%  OBJ=CSET_FULLFACT(CS,OPTS)
%
%   Where OPTS={{LIMITS}, [N_LEVELS], N_CENTER};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:00:20 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.Nc= varargin{2}{3};
    obj.grid=cset_grid(cs,i_createlvlvect(lims, varargin{2}{2}));
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        lims=limits(cs);
        nf=size(lims,1);
        obj.Nc= 0;
        lvls=repmat(2,1,nf);
        obj.grid=cset_grid(cs,i_createlvlvect(lims,lvls));
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        cs= rmfield(cs,'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs= candidateset(lims);
        obj.Nc= varargin{1}{3};
        obj.grid=cset_grid(cs,i_createlvlvect(lims,varargin{1}{2}));
    end
else
    % No inputs - use defaults
    cs= candidateset(repmat([-1 1],4,1));
    obj.Nc= 0;
    obj.grid=cset_grid(cs,repmat({[-1 1]},1,4));
end

obj.version= 1;
obj= class(obj,'cset_fullfact',cs);
return



function lvls= i_createlvlvect(lims,nlvl)
nf=length(nlvl);
lvls=cell(1,nf);
for n=1:nf
    lvls(n)={linspace(lims(n,1), lims(n,2), nlvl(n))};
end
return
