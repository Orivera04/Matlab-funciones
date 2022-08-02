function [c,msg]=conlinear(sz,varargin)
%CONLINEAR  Linear constraint object
%
%  OBJ=CONLINEAR(size)  - size = number of factors.
%  OBJ=CONLINEAR(size,paramlist)  - see setparams for the paramlist
%    specifications.
%
%  CONLINEAR objects constrain points according to the equation A*x <= b
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:17 $

if ~nargin
   sz=4;
end

if isstruct(sz)
   c=sz;
else
   c.A=repmat(1,1,sz);
   c.b=0;
   c.version=1;
end

c=class(c,'conlinear');

if length(varargin)
   [c,msg]=setparams(c,varargin{:});
else
   msg={};   
end