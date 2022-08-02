function newdata = mergedata(this, newdata)
% MERGEDATA Merges two arrays of objects with respect to property Block name.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/04 02:38:55 $

% this may be an array
olddata = this;

h = slcontrol.Utilities;
newdata = mergeObjects(h, olddata, newdata, 'Block');
