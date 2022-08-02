function tgt_delete(filename)
% TGT_DELETE deletes the specified file if it exists

% Copyright 2002 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1 $
%   $Date: 2002/09/13 11:58:03 $  
  
  if exist(filename)==2
    delete(filename)
  end
