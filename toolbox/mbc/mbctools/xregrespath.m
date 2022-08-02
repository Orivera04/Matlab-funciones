function pth=xregrespath(FILE)
% XREGRESPATH  GUI resource path 
%
%  PTH=XREGRESPATH(FILE) constructs the full path/file for the 
%  fiven cage resource file.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 08:21:17 $



CDIR=fileparts(which(mfilename));
if nargin
   pth=fullfile(CDIR, 'resource', FILE);
else
   pth=fullfile(CDIR,'resource');
end
