function obj = plotPropertiesDlg(obj, index, data, hParent)
% PLOTPROPERTIESLDG 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:19:18 $

% Open the sweepset plot properties dialog
[OK, props] = plotPropertiesDlg(data, hParent, obj.plots(index).properties);
% If the user clicked OK then update
if OK
    obj.plots(index).properties = props;
end
