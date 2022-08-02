function len = getDataLength(this)
% GETDATALENGTH Get the length of data

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:42:38 $

N = length(this.Dimensions);
if ( N < 2 )
  len = size(this.Data,1);
else
  len = size(this.Data, N+1);
end
