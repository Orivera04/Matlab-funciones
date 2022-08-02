function obj=cset_simplex(varargin)
% CSET_SIMPLEX  Regular Simplex design generator object
%
%  OBJ=CSET_SIMPLEX
%  OBJ=CSET_SIMPLEX(CS)
%  OBJ=CSET_SIMPLEX(STRUCT)
%  OBJ=CSET_SIMPLEX(OPTS)
%  OBJ=CSET_SIMPLEX(CS,OPTS)
%
%   Where OPTS={N_CENTER};

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:01:25 $

if nargin==2
   cs= varargin{1};
   lims= cat(1,varargin{2}{1}{:});
   cs= limits(cs,lims);
   obj.Nc= varargin{2}{2};
elseif nargin==1
   if isa(varargin{1},'candidateset')
      cs= varargin{1};
      obj.Nc= 5;
   elseif isa(varargin{1},'struct')
      cs= varargin{1}.candidateset;
      obj= rmfield(varargin{1},'candidateset');
      obj= rmfield(obj,'version');
   else
      lims= cat(1,varargin{1}{1}{:});
      cs=candidateset(lims);
      obj.Nc= varargin{1}{2};
   end
else
   % No inputs - use defaults
   cs= candidateset(repmat([-1 1],4,1));
   obj.Nc= 5;
end

obj.version= 1;
obj= class(obj,'cset_simplex',cs);
return
