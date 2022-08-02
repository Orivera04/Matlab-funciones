function varargout = mv_BoxCox(action,p)
% MV_BOXCOX box-cox transformation gui
%
%Function to create Box-Cox figure window enableing user to select a value of 
%for lambda. Input arguments are the action to underake and p a pointer to a
%modeldev object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:02:07 $

switch lower(action)
case 'create'
   % p is a pointer to a mdev object
   % Create new xregGui.boxcox object and return HG handle to the figure
   bc = xregMdlGui.boxcox(p);
   varargout{1}= double(bc.figure);
case 'update'
   % Contents of the model have been changed elsewhere so update plots
   % accordingly
   
   % p is the handle to the boxcox GUI.
   % From the handle, get the boxcox object (in Userdata)
   bc = get(p,'Userdata');
   % Call updatePlot method on the boxcox object.
   fullUpdate(bc);
end