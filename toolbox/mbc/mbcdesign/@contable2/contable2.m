function [c,msg]=contable2(sz,varargin)
%CONTABLE2  2-D lookup table constraint object
%
%  OBJ=CONTABLE2(size)  - size = number of factors.
%  OBJ=CONTABLE2(size,paramlist)  - see setparams for the paramlist
%    specifications.
%
%  CONTABLE2 objects constrain points according to a 2-D lookup table
%  in the following format:
%
%                               |   Factor
%  Breakpoints: X  [vector]     |     I
%  Breakpoints: Y  [vector]     |     J
%  Table values:  [matrix]      |     K
%  
%  Use "<=" constraint:  0/1
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:02 $

if ~nargin
   sz=4;
end

if isstruct(sz)
   c=sz;
else
   c.size=max(sz,2);
   c.breakcols=(-1:0.5:1);
   c.breakrows=(-1:0.5:1);
   c.table=ones(5,5);
   c.factors=[1 2 3];
   c.le=1;
   c.version=1;
end

c=class(c,'contable2');

if length(varargin)
   [c,msg]=setparams(c,varargin{:});
else
   msg={};
end