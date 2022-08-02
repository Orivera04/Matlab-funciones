function h = iotable(varargin)
%IOTABLE
%
%   Authors: James G. Owen
%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2003/12/22 00:56:02 $

persistent thistable;
    
if nargin>=1
    % Create if table object if necessary
    if isempty(thistable)
        thistable = speimporttable.iotable;
    end

    % (re)target table model to the right table 
    thistable.initialize(varargin{:})
end % Get the persistent var for debugging reasons   
h = thistable;
