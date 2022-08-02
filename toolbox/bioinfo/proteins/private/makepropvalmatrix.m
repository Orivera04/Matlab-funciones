function valmat = makepropvalmatrix(fcnh)
%MAKEPROPVALMATRIX helper function to proteinplot

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.4 $  $Date: 2004/01/24 09:20:20 $

if ~nargin,
    [namelist,fcnh] = getproteinpropfcns; %#ok
end
 valmat = [];
 a_z = double('a'):double('z');
 for n = 1:numel(fcnh)
         valmat = [valmat,fcnh{n}(a_z)];
 end
