function obj=cset_grid(varargin)
% CSET_GRID  Grid CandidateSet generator object
%
%  OBJ=CSET_GRID
%  OBJ=CSET_GRID(CS)
%  OBJ=CSET_GRID(STRUCT)
%  OBJ=CSET_GRID(OPTS)
%  OBJ=CSET_GRID(CS,OPTS)
%
%     Where OPTS=Lvls

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:00:01 $

if nargin==2
    cs=varargin{1};
    obj.levels=varargin{2};
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs=varargin{1};
        nf=nfactors(cs);
        lims=limits(cs);
        if nf<=4
            lvls = 0:.05:1;
        else
            lvls=linspace(0,1,max(2,round(1e6^(1./nf))));
        end
        for n=1:nf
            obj.levels(n,1)={lims(n,1)+lvls.*diff(lims(n,:),1,2)};
        end

    elseif isa(varargin{1},'struct')
        cs=varargin{1}.candidateset;
        cs=rmfield(cs,'candidateset');
    else
        obj.levels=varargin{1};
        mm=zeros(length(obj.levels),2);
        for n=1:length(obj.levels)
            mm(n,:)=[min(obj.levels{n}) max(obj.levels{n})];
        end
        cs=candidateset(mm);
    end
else
    cs=candidateset(repmat([-1 1],4,1));
    obj.levels=repmat({-1:.1:1},4,1);
end

obj.version=1;
obj=class(obj,'cset_grid',cs);
return

