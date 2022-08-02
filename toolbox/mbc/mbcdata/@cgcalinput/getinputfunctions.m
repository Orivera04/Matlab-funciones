function [fcns,names,fileflags]=getoutputfunctions(obj)
%GETINPUTFUNCTIONS  Return available input methods
%
%  [FCNS,NAMES]=GETINPUTFUNCTIONS(OBJ)
%
%  Returns a cell array of methods and names for the various input
%  methods available.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:49:18 $

fcns = methods(obj);
fcns = setxor(fcns,{'cgcalinput','createmenus','getinputfunctions','import','gui_import','get', 'set'});
if nargout>1
   names=cell(size(fcns));
   fileflags = ones(size(fcns));
   for n=1:length(fcns)
      [names{n},fileflags(n)]=feval(fcns{n},obj,'getname');
   end
end