function table = getPlotsData(this)
% GETPLOTSDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:40:45 $

data = this.Fields.Plots;
table = matlab2java(data);
