function pos= findptrs(p,q);
%XREGPOINTER/FINDPTRS find location of pointers in another list
% 
% pos= findptrs(p,q);
%       finds index to pointers p in list q 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 06:47:08 $

pos= zeros(size(p));
if ~isempty(p) && ~isempty(q)
    p= p.ptr;
    q= q.ptr;
    n= numel(q);
    for i = 1:numel(p)
        % this code is jittable
        j=1;
        while j<=n && p(i)~=q(j)
            % find first instance of p(i) in q
            j=j+1;
        end
        if j<=n
            % p(i) is found at j
            pos(i) = j;
        end
    end
end
