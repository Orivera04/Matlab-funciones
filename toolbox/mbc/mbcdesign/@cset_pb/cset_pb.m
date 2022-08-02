function obj=cset_pb(varargin)
% CSET_PB  Plackett-Burman design generator object
%
%  OBJ=CSET_PB
%  OBJ=CSET_PB(CS)
%  OBJ=CSET_PB(STRUCT)
%  OBJ=CSET_PB(OPTS)
%  OBJ=CSET_PB(CS,OPTS)
%
%   Where OPTS={{LIMITS}, N_RUNS};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:00:53 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.Nr= varargin{2}{2};
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        Nrvect=pr_getrunopts(nfactors(cs));
        obj.Nr=max(Nrvect(1),8);
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        cs= rmfield(cs,'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs=candidateset(lims);
        obj.Nr= varargin{1}{2};
    end
else
    % No inputs - use defaults
    cs= candidateset(repmat([-1 1],4,1));
    obj.Nr= 8;
end

obj.version= 1;
obj= class(obj,'cset_pb',cs);
return
