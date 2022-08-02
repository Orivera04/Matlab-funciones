function h = rlcckt(varargin)
%RLCCKT RLCCKT virtual class.
%   RLCCKT is a virtual class---it is never intended to be instantiated.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:37:42 $

msg = sprintf(['RLCCKT is not an RFCKT component.\n',...
               'Type ''help rfckt'' for more info.']);
error('rf:rfckt:rlcckt:invalidinstantiation',msg);
