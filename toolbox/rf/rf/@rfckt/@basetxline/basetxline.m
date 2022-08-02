function h = basetxline(varargin)
%BASETXLINE BASETXLINE virtual class.
%   BASETXLINE is a virtual class---it is never intended to be instantiated.
  
%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/20 23:19:31 $

msg = sprintf(['BASETXLINE is not an RFCKT component.\n',...
               'Type ''help rfckt'' for more info.']);
error('rf:rfckt:basetxline:invalidinstantiation',msg);
