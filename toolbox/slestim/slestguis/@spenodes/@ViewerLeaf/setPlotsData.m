function setPlotsData(this, value, row, col)
% SETPLOTSDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:50 $

this.Fields.Plots{row, col} = value;

% Set the dirty flag
this.setDirty
