function obj = cset_boxb(varargin)
%CSET_BOXB  Box-Behnken Design generator object
%
%  OBJ=CSET_BOXB
%  OBJ=CSET_BOXB(CS)
%  OBJ=CSET_BOXB(STRUCT)
%  OBJ=CSET_BOXB(OPTS)
%  OBJ=CSET_BOXB(CS,OPTS)
%
%  Where OPTS={{LIMITS}, N_CENTER};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 06:59:52 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.Nc= varargin{2}{2};
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        if nfactors(cs)<5
            obj.Nc= 3;
        else
            obj.Nc=6;
        end
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        cs= rmfield(cs,'candidateset');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs=candidateset(lims);
        obj.Nc= varargin{1}{2};
    end
else
    % No inputs - use defaults
    cs= candidateset(repmat([-1 1],4,1));
    obj.Nc= 3;
end

obj.version= 1;
obj= class(obj,'cset_boxb',cs);
