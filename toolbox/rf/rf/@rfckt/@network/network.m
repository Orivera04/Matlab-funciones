function h = network(varargin)
%NETWORK NETWORK virtual class.
%   NETWORK is a virtual class---it is never intended to be instantiated.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:37:18 $

msg = sprintf(['NETWORK is not an RFCKT component.\n',...
               'Type ''help rfckt'' for more info.']);
error('rf:rfckt:network:invalidinstantiation',msg);
