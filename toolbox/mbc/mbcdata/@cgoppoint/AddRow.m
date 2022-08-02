function p = AddRow(p,data,ind,no)
% p = AddRow(p) add blank row to operating point p.
% p = AddRow(p,data) add row of data as last operating point.
% p = AddRow(p,data,ind,no) add row of data after (ind)th existing row.
%      ind = 0 adds data as first operating point. data = [] adds blank row.
%      no gives number of rows to add

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/12 23:34:28 $

if nargin<4
    no = 1;
end
cols = get(p,'numfactors');
pts = get(p,'numpoints');
if (nargin==1) || isempty(data)
    data = zeros(no,cols);
elseif nargin>1
    if size(data,2)~=cols
        if size(data,1)==cols
            data = data';
        else
            error('Data size must match number of factors');
        end
    end
end
if nargin<3
    ind = pts;
else
    if (ind<0) || (ind>pts)
        error('Bad index into points');
    end
end

d = p.data;
p.data = [d(1:ind,:) ; data ; d(ind+1:end,:)];

% Convert any gridded variables into a block of data
p = convertGridToBlock(p);

