function h = statetable(varargin)
%IOTABLE
%
%   Authors: James G. Owen
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/11 00:38:31 $

% State table is a singleton
persistent thistable;

% Create if table object if necessary
if isempty(thistable)
    thistable = speimporttable.statetable;
end
    
if nargin>=1
    % (re)target table model to the right table 
    thistable.initialize(varargin{:})
end % Get the persistent var for debugging reasons   
h = thistable;
