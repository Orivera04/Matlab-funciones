function p = ndblock(p,block_i,block_data);
% block_len = ndblock(p,ind) calculates length of block
%
% p = ndblock(p,ind,data)
%   Builds grid using block.
%   treats factors referenced by ind as a single block, containing 'data'.  
%   Data values in other factors are reproduced for each row in 'data'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:10 $

% if nargin==2
%     % Check whether the block has been replicated in a previous grid
%     numrows = size(p.data,1);
%     blocklen = numrows;
%     for i = 1:numrows./2
%         if round(numrows/i)==(numrows/i) %multiple of grid
%             rows = p.data(1:i,block_i);
%             new_rows = p.data(i+1:2*i,block_i);
%             if all(ismember(new_rows,rows,'rows')) ... %two identical blcoks
%                 & all(ismember(p.data(:,block_i),rows,'rows'))   %which match all the data
%                 blocklen = i;
%                 break
%             end
%         end
%     end
%     p = blocklen;
%     return
% end

if nargin ==2
    % Checking for replication is too slow for large grids.
    % Now just carry the length of the block in the object
    p = p.blocklen;
    return;
end

if isempty(block_data)
    block_data = repmat(0,1,length(block_i));
end
if size(block_data,2)~=length(block_i)
    error('ndblock: factor indices must match size of data block');
end
if ~all(ismember(block_i,1:length(p.ptrlist)))
    error('ndblock: bad index into factors');
end

factor_i = setdiff(1:length(p.ptrlist),block_i);
f_data = p.data;

if isempty(f_data)
    f_data = get(p,'constant');
end

M = size(f_data,1);
L = size(block_data,1);
new_b_data = repmat(block_data,M,1);   %tile the oppoint data

if L > 1
    newdata = repmat(0,size(new_b_data,1),size(f_data,2));
    % reproduce these Values to fit the oppoint data between each row
    for i = 1:size(f_data,2)
        newdata(:,i) = reshape( repmat(f_data(:,i)' ,L,1) , L.*M , 1);
    end
else
    newdata = f_data;
end

newdata(:,block_i) = new_b_data(:,1:length(block_i));

p.data = newdata;

