function obj=cset_ccd(varargin)
%CSET_CCD  Central Composite Design generator object
%
%  OBJ=CSET_CCD
%  OBJ=CSET_CCD(CS)
%  OBJ=CSET_CCD(STRUCT)
%  OBJ=CSET_CCD(OPTS)
%  OBJ=CSET_CCD(CS,OPTS)
%
%   Where OPTS={{LIMITS}, N_CENTER, ALPHA};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:00:09 $

if nargin==2
    cs= varargin{1};
    lims= cat(1,varargin{2}{1}{:});
    cs= limits(cs,lims);
    obj.Nc= varargin{2}{2};
    obj.Alpha=varargin{2}{3};
    obj.inscribe=0;
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs= varargin{1};
        nf=size(limits(cs),1);
        obj.Nc= 5;
        obj.Alpha=repmat(2^(nf/4),1,nf);
        obj.inscribe=0;
    elseif isa(varargin{1},'struct')
        cs= varargin{1}.candidateset;
        obj= rmfield(varargin{1},'candidateset');
        obj= rmfield(obj,'version');
    else
        lims= cat(1,varargin{1}{1}{:});
        cs=candidateset(lims);
        obj.Nc= varargin{1}{2};
        obj.Alpha=varargin{1}{3};
        obj.inscribe=0;
    end
else
    % No inputs - use defaults
    cs= candidateset(repmat([-1 1],4,1));
    obj.Nc= 5;
    obj.Alpha=repmat(2,1,4);
    obj.inscribe=0;
end

obj.version= 2;
obj= class(obj,'cset_ccd',cs);
return
