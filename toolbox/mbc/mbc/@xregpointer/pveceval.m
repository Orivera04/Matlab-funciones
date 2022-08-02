function varargout = pveceval(p,func,varargin)
%PVECEVAL Vectorized function evaluation for pointers
%
%  varargout = PVECEVAL(p, func, varargin) evaluates func for each pointer
%  in the pointer array p.  The outputs will be returned as a cell array
%  with same dimensions as p.
%
%  PVECEVAL(p,func,varargin) puts the first output argument from func back
%  on the heap.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 06:48:12 $

% extract info 
ptr = p.ptr;
inf = HeapManager(1,ptr);
np = numel(ptr);

n = max(nargout,1);
data = cell(n,np);
out = cell(n,1);
for i=1:np
    % do function evaluations
    [out{:}]= feval(func,inf{i},varargin{:});
    data(:,i)= out;
end

switch nargout
    case 0
        % put modified data back on heap
        for i=1:np
            HeapManager(2,ptr(i),data{i});
        end
    case 1
        varargout{1}= reshape(data,size(ptr));
    otherwise
        % reshape outputs argument by argument
        varargout= cell(1,nargout);
        s= size(ptr);
        for j= 1:nargout
            % make outputs the same size as pointer array
            varargout{j}= reshape(data(j,:),s);
        end
end
