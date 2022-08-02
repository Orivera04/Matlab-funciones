function pth=cgrespath(FILE)
% CGRESPATH  GUI resource path 
%
%  PTH=CGRESPATH(FILE) constructs the full path/file for the 
%  fiven cage resource file.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:39:42 $



CDIR=fileparts(which(mfilename));
if nargin
   pth=fullfile(CDIR, 'resource', FILE);
else
   pth=fullfile(CDIR,'resource');
end
