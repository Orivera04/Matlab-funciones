function obj=cset_lhs(varargin)
% CSET_LHS  Lattice CandidateSet generator object
%
%  OBJ=CSET_LHS
%  OBJ=CSET_LHS(CS)
%  OBJ=CSET_LHS(STRUCT)
%  OBJ=CSET_LHS(OPTS)
%  OBJ=CSET_LHS(CS,OPTS)
%  OBJ=CSET_LHS(CS,OPTS,INDICES)
%
%   Where OPTS={{LIMITS},N,CHOICEMETHOD,OPTIMMETHOD,RECALC};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:00:41 $

needcalc=0;
if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.N= varargin{2}{2};
    obj.alg= varargin{2}{3};
    obj.indices= [];
    obj.delta= (diff(lims,1,2)')./(obj.N-1);
    obj.optimalg=varargin{2}{4};
    obj.doRecalc=varargin{2}{5};
    obj.guiflag=0;
    obj.stratify=zeros(1,length(obj.delta));
    obj.symmetry=0;
    obj.stratify_levels = cell(1, length(obj.delta));
    needcalc=1;
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        obj.N= 100;
        obj.alg= 'maximin';
        obj.indices= [];
        obj.delta= (diff(limits(cs),1,2)')./(obj.N-1);
        obj.optimalg='random';
        obj.doRecalc=0;
        obj.guiflag=0;
        obj.stratify=zeros(1,length(obj.delta));
        obj.symmetry=0;
        obj.stratify_levels = cell(1, length(obj.delta));
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        obj= rmfield(varargin{1},'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        obj.N= varargin{1}{2};
        obj.alg= varargin{1}{3};
        obj.indices= [];
        obj.delta= (diff(lims,1,2)')./(obj.N-1);
        obj.optimalg=varargin{1}{4};
        obj.doRecalc=varargin{1}{5};
        obj.guiflag=0;
        obj.stratify=zeros(1,length(obj.delta));
        obj.symmetry=0;
        obj.stratify_levels = cell(1, length(obj.delta));
        cs= candidateset(lims);
        needcalc=1;
    end
elseif nargin==3
    % additional input - for upgrading from old designs
    lims= cat(1,varargin{2}{1}{:});
    obj.N= varargin{2}{2};
    obj.alg= varargin{2}{3};
    obj.indices= varargin{3};
    obj.delta= (diff(lims,1,2)')./(obj.N-1);
    obj.optimalg=varargin{2}{4};
    obj.doRecalc=varargin{2}{5};
    obj.guiflag=0;
    obj.stratify=zeros(1,length(obj.delta));
    obj.symmetry=0;
    obj.stratify_levels = cell(1, length(obj.delta));
    cs= candidateset(lims);
else
    % No inputs - use defaults
    cs= candidateset(repmat([-1 1],4,1));
    obj.N= 100;
    obj.alg= 'maximin';
    obj.indices= [];
    obj.delta= (diff(limits(cs),1,2)')./(obj.N-1);
    obj.optimalg='random';
    obj.doRecalc=0;
    obj.guiflag=0;
    obj.stratify=zeros(1,length(obj.delta));
    obj.symmetry=0;
    obj.stratify_levels = cell(1, length(obj.delta));
end

obj.version= 3;
obj= class(obj,'cset_lhs',cs);

if needcalc && obj.doRecalc
    stratlvls = obj.stratify_levels;
    if any(obj.stratify)
        tpflg = 3;  % require doubles for accuracy
        % convert stratify levels into 1...N domain
        lims = limits(obj);
        for k = find(obj.stratify==-1)
            stratlvls{k} = ((obj.N-1) .* (stratlvls{k}-lims(k,1))./(lims(k,2) - lims(k,1))) + 1;
        end
    else
        % Recalculate the indices
        if obj.N<=255
            tpflg=0;
        elseif obj.N<=65535
            tpflg=1;
        elseif obj.N<=4294967295
            tpflg=2;
        else
            tpflg=3;
        end
    end
    obj.indices=pr_selectlhs(obj,obj.N, nfactors(obj), tpflg, obj.alg, obj.optimalg,obj.guiflag,obj.doRecalc,...
        obj.stratify,stratlvls,obj.symmetry);
end
return
