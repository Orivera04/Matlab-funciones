function varargout = imaqgate(varargin)
%IMAQGATE Gateway routine to call Image Acquisition Toolbox private functions.
%
%    [OUT1, OUT2,...] = IMAQGATE(FCN, VAR1, VAR2,...) calls FCN in 
%    the Image Acquisition Toolbox private directory with input arguments
%    VAR1, VAR2,... and returns the output, OUT1, OUT2,....
%

%    CP 2-01-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:57 $

if nargin == 0
    errID = 'imaq:imaqgate:invalidSyntax';
    error(errID, imaqgate('privateMsgLookup',errID));
end

nout = nargout;
if nout==0,
   feval(varargin{:});
else
   [varargout{1:nout}] = feval(varargin{:});
end

