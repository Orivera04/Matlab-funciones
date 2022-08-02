function obj=csetinterface(varargin)
% CSETINTERFACE  Interface for dealing with Candidate sets
%
%  CS=CSETINTERFACE
%  CS=CSETINTERFACE(struct)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:02:23 $

% Created 5/11/2000


if nargin & isstruct(varargin{1})
   % no alterations necessary
else
   obj.filtertype=[];
   obj.filternf=NaN;
end

obj.version=1;
obj=class(obj,'csetinterface');

return
