function h = rfdata(varargin)
%RFDATA RFDATA virtual class.
%   RFDATA is a virtual class---it is never intended to be instantiated.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:46 $

msg = sprintf(['RFDATA is not an RFDATA type.\n',...
               'Type ''help rfdata'' for more info.']);
error('rf:rfdata:rfdata:invalidinstantiation',msg);
