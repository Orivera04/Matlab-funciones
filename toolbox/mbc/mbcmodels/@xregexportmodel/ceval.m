function [y,varargout]=ceval(M,x,varargin);
%ceval
% evaluates the constraint model an ExportModel M at the data specifed by the CELL x. 
% c<0 means inside the constraint

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:13 $


m=M.mvModel;
if iscell(x)
    bigLength= max(cellfun('prodofsize',x));

else
    bigLength= size(x,1);
end

% make a 'feasible' value Y<0
Y= -ones(bigLength,1);