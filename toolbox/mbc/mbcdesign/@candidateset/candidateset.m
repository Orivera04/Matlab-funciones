function obj=candidateset(varargin)
% CANDIDATESET  Constructor for the base CandidateSet class
%
%  CS=CANDIDATESET
%  CS=CANDIDATESET(LIMS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:55:57 $

% Created 1/11/00

if nargin
   if isstruct(varargin{1});
      obj=varargin{1};
   else
      obj.lims=varargin{1};
   end
   
else
   % Default is a 4-factor space
   obj.lims=repmat([-1 1],4,1);
end

obj.version=1;
obj=class(obj,'candidateset');
return
