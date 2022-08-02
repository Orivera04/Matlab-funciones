function xregcallback(cb,src,evt)
%XREGCALLBACK  Invoke a callback
%
%  XREGCALLBACK(STR)  evaluates a string in the base workspace
%  XREGCALLBACK(FNHNDL,SRC,EVT) evaluates the function handle
%  XREGCALLBACK({FNHNDL,ARGS},SRC,EVT) includes the additional arguments

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:18 $


% This function is used to evaluate a "callback" property which might be a
% string, function handle or cell with a function handle.  A lot of 
% components need to do this.

if ~isempty(cb)
   if ischar(cb)
      evalin('base',cb);   
   elseif iscell(cb)
      if nargin<3
         evt=[];
      end
      if nargin<2
         src=[];
      end
      if length(cb)>1
         feval(cb{1},src,evt,cb{2:end}); 
      else
         feval(cb{1},src,evt); 
      end
   elseif isa(cb,'function_handle')
      if nargin<3
         evt=[];
      end
      if nargin<2
         src=[];
      end
      feval(cb,src,evt);   
   end
end