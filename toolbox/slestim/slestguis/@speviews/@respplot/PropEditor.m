function hEditor = PropEditor(plot,CurrentFlag)
% Returns instance of Property Editor for simulation plots
% (single instance for all plots)

%   Authors: Adam DiVergilio and P. Gahinet
%   Copyright 1986-2002 The MathWorks, Inc. 
%   $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:07 $
persistent hPropEdit
if nargin==1 && isempty(hPropEdit)
   % Create and target prop editor if it does not yet exist
   hPropEdit = cstprefs.propeditor({'Labels','Limits','Style'});
end
hEditor = hPropEdit;