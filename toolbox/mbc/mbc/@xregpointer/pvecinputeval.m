function varargout = pvecinputeval(p,func,varargin)
%PVECINPUTEVAL Vectorized evaluation of pointers with vector inputs
%
%  varargout = PVECINPUTEVAL(p,func,varargin) evaluates func for each
%  pointer in the pointer array p.  The outputs will be returned as a cell
%  array with same dimensions as p.  If the inputs are  cell arrays of the
%  same size as p  they are distributed to each function call, otherwise
%  they are treated as 'scalar' inputs and used for each function
%  evaluation.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $  $Date: 2004/02/09 06:48:13 $


% extract info 
inf = HeapManager(1,p.ptr);
np = numel(p.ptr);

n = max(nargout,1);
isCellArray = cellfun('isclass',varargin,'cell') & (cellfun('prodofsize',varargin) == np);

if any(isCellArray)
    % make matrix of input arguments
    InputArgs= cell(np,length(varargin));
    for i= 1:length(varargin)
        if isCellArray(i)
            InputArgs(:,i)= varargin{i}(:);
        else
            % scalar expansion of inputs
            InputArgs(:,i) = varargin(i);
        end
    end
else
    InputArgs= varargin;
end


data = cell(numel(inf),n);
for i=1:size(data,1)
    if any(isCellArray)
        % do function evaluations with ith row of input arguments
        [data{i,1:n}]= feval(func,inf{i},InputArgs{i,:});
    else
        [data{i,1:n}]= feval(func,inf{i},InputArgs{:});
    end
end

% reshape outputs argument by argument
varargout= cell(1,nargout);
for j= 1:nargout
    % make outputs the same size as pointer array
    varargout{j}= reshape(data(:,j),size(inf));
end
   
