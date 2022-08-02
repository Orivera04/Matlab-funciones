function newdata = mergedata(this, newdata)
% MERGEDATA Merges two arrays of objects with respect to property name.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/01/03 12:25:42 $

% this may be an array
olddata = this;

h = slcontrol.Utilities;
newdata = mergeObjects(h, olddata, newdata, 'Name');
