function setOptionsData(this, value, row, col)
% SETOPTIONSDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:22 $

this.Fields.Options{row, col} = value;

% Set the dirty flag
this.setDirty
