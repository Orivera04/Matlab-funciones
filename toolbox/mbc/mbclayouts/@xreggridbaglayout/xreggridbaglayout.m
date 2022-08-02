function obj=xreggridbaglayout(varargin)
%GRIDBAGLAYOUT  constructor for gridbaglayout Layout
%
%  obj=xreggridbaglayout(FIG,prop,val,...);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:18 $



c=xreggridlayout(varargin{:},'correctalg','on');
obj=struct([]);
obj = class(obj,'xreggridbaglayout',c);