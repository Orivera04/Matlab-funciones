function obj=cset_userdef(varargin)
% CSET_USERDEF  User-defined CandidateSet generator object
%
%  OBJ=CSET_USERDEF
%  OBJ=CSET_USERDEF(CS)
%  OBJ=CSET_USERDEF(STRUCT)
%  OBJ=CSET_USERDEF(OPTS)
%  OBJ=CSET_USERDEF(CS,OPTS)
%
%     Where OPTS=Matrix

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:02:03 $

if nargin==2
    cs=varargin{1};
    obj.data=varargin{2};
elseif nargin==1
    if isa(varargin{1},'candidateset')
        cs=varargin{1};
        lims=limits(cs);
        obj.data=(sum(lims,2).*0.5)';
    elseif isa(varargin{1},'struct')
        cs=varargin{1}.candidateset;
        cs=rmfield(cs,'candidateset');
    else
        obj.data=varargin{1};
        cs=candidateset(repmat([-1 1],size(obj.data,2),1));
    end
else
    cs=candidateset(repmat([-1 1],4,1));
    obj.data=[0 0 0 0];
end

obj.version=1;
obj=class(obj,'cset_userdef',cs);
return
