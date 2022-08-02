function [c,msg]=contable1(sz,varargin)
%CONTABLE1  1-D lookup table constraint object
%
%  OBJ=CONTABLE1(size)  - size = number of factors.
%  OBJ=CONTABLE1(size,paramlist)  - see setparams for the paramlist
%    specifications.
%
%  CONTABLE1 objects constrain points according to a 1-D lookup table
%  in the following format:
%
%                               |   Factor
%  Breakpoints:   [vector]      |     N
%  Table values:  [vector]      |     M
%  
%  Use "<=" constraint:  0/1
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:35 $

if ~nargin
   sz=4;
end

if isstruct(sz)
   c=sz;
else
   c.size=max(sz,2);
   c.breakcols=(-1:0.5:1);
   c.table=ones(1,5);
   c.factors=[1 2];
   c.le=1;
   c.version=1;
end

c=class(c,'contable1');

if length(varargin)
   [c,msg]=setparams(c,varargin{:});
else
   msg={};
end