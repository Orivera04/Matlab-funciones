function h = rfckt(varargin)
%RFCKT RFCKT virtual class.
%   RFCKT is a virtual class---it is never intended to be instantiated.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:38 $

msg = sprintf(['RFCKT is not an RFCKT component.\n',...
               'Type ''help rfckt'' for more info.']);
error('rf:rfckt:rfckt:invalidinstantiation',msg);
