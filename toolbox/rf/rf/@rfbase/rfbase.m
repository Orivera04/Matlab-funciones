function varargout=rfbase(varargin)
%RFBASE  RFBASE object.
%    RFBASE only has a virtual class for all RF objects.
%
%  See also RFCKT, RFDATA.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:58 $

error('rf:rfbase:rfbase:VirtualClass', ...
    'RFBASE is a virtual class, not intended to be instantiated.');
