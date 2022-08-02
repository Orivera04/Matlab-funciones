function is= allLinearRF(L);
% LOCALMOD/ALLLINEARRF true if all the response features are linear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:38:48 $

if ~isfield(L.Type,'IsLinear')
	is = isa(L,'xreglinear') | isa(L,'localpspline');
else
	is= all([L.Type.IsLinear]) | isa(L,'localpspline'); 
end


