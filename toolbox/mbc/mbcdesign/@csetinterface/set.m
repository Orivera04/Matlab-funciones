function obj=set(obj,param,data)
% SET Set interface for csetInterface
%
%  Valid settings are:
%    
%       TypeFilter: vector of types to filter for
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:02:27 $

% Create 5/11/2000

switch lower(param)
case 'typefilter'
   obj.filtertype=data;
case 'nffilter'
   obj.filternf=data;
end