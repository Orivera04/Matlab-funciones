function [ind,varargout] = find(S, var)
% SWEEPSET/FIND  overloaded find for sweepset class
%   ind = FIND(S, VAR)
%
% FIND returns the index of the SWEEPSET database variable matching VAR.
% VAR may be a single name or a cell array of names. An Empty Matrix is 
% returned if VAR is NOT found.
%
% Indices to variables that were NOT found can be returned as a second argument.
%   [ind,NotFnd] = FIND(S, VAR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:15 $



ivar = 0;
varlist={S.var.name};
if iscell(var)
   ind=zeros(size(var));
   NOT_FOUND = 0;
   temp = xregdeblank(var);
   for i=1:numel(var)
      j= find(strcmp(temp{i}, varlist));
      if ~isempty(j)
         ind(i)=j(1);
      else
         ind(i)=-1;
		 NOT_FOUND = 1;
      end
   end
   if nargout==2
      varargout{1}= ind;
   end
   if NOT_FOUND
      ind=[];
   end
else
   temp = xregdeblank(var);
   ind= find(strcmp(temp, varlist));
   if nargout==2 
      if isempty(ind)
         varargout{1}= -1;
      else
         varargout{1}= ind;
      end
   end
end   

