function [ps,ix] = dpsimplify(p,tol)

% Recursive Douglas-Peucker Polyline Simplification, Simplify
%
% [ps,ix] = dpsimplify(p,tol)
%
% dpsimplify uses the recursive Douglas-Peucker line simplification 
% algorithm to reduce the number of vertices in a polyline 
% according to specific tolerance. Works also for polylines in 
% higher dimensions.
%
% In case of nans (missing vertex coordinates) dpsimplify treats each 
% line separately.
%
% For additional information on the algorithm follow this link
% http://en.wikipedia.org/wiki/Ramer-Douglas-Peucker_algorithm
%
% Input arguments
%
%     p     polyline n*d matrix with n vertices in d 
%           dimensions.
%     tol   tolerance (maximal euclidean distance allowed 
%           between the new line and a vertex)
%
% Output arguments
%
%     ps    simplified line
%     ix    linear index of the vertices retained in p
%
% Examples
%
% 1. Simplify line 
%
%     tol    = 1;
%     x      = 1:0.1:8*pi;
%     y      = sin(x) + randn(size(x));
%     p      = [x' y'];
%     ps     = dpsimplify(p,tol);
%
%     plot(p(:,1),p(:,2),'k')
%     hold on
%     plot(ps(:,1),ps(:,2),'r','LineWidth',2);
%     legend('original polyline','simplified')
%
% 2. Reduce polyline so that only knickpoints remain by 
%    choosing a very low tolerance
%
%     p = [(1:10)' [1 2 3 2 4 6 7 8 5 2]'];
%     p2 = dpsimplify(p,eps);
%     plot(p(:,1),p(:,2),'k+--')
%     hold on
%     plot(p2(:,1),p2(:,2),'ro','MarkerSize',10);
%     legend('original line','knickpoints')
%
% 3. Simplify a circle
% 
%     x = cos(0:0.01:2*pi);
%     y = sin(0:0.01:2*pi);
%     x(end+1) = x(1);
%     y(end+1) = y(1);
%     plot(x,y)
%     p2 = dpsimplify([x' y'],.1);
%     plot(x,y)
%     hold on
%     plot(p2(:,1),p2(:,2),'k','LineWidth',2);
%
%
%
%
% Author: Wolfgang Schwanghart, 10. Januar, 2009.
% w.schwanghart[at]unibas.ch


if nargin == 0
    help dpsimplify
    return
end

if nargin ~= 2
    error('wrong number of input arguments')
end

% error checking
if ~isscalar(tol)
    error('tol must be a scalar')
end



% nr of dimensions
dims    = size(p,2);

% __________________________________
% what happens, when there are NaNs?
% NaNs divide polylines.
Inan      = any(isnan(p),2);

% if there is only one vertex
if size(p,1) == 1 || isempty(p);
    ps = p;
    ix = 1;

elseif any(Inan);
    if ~Inan(end)        
        Inan = [Inan;true];
        p    = [p;nan(1,dims)];
    end
    
    if nargout == 2;
        % starting indices of respective polylines
        sIX = [true; diff(Inan)~=0];
        sIX(Inan) = false;
        sIX = find(sIX);
    end
    
    
    IX = [0;find(Inan)];
    IX = diff(IX);
    IX(IX == 1) = [];
    
    m   = IX-1;
    
    % if lines are diveded by nans single lines are stored in a cell array
    % cellfun is then used to call dpsimplify for each line
    c   = mat2cell(p(~Inan,:),m,dims);
    if nargout == 2;
        [ps,ix]   = cellfun(@(x) dpsimplify(x,tol),c,'uniformoutput',false);
        ix        = cellfun(@(x,six) x+six-1,ix,num2cell(sIX),'uniformoutput',false);
    else
        ps   = cellfun(@(x) dpsimplify(x,tol),c,'uniformoutput',false);
    end
    ps = cellfun(@(x) [x;nan(1,dims)],ps,'uniformoutput',false);
    
    ps   = cell2mat(ps);
    ps(end,:) = [];
    
    if nargout == 2;
        ix = cell2mat(ix);
        ixempty = ps(:,1);
        ixempty(~isnan(ixempty)) = ix;
        ix = ixempty;
    end
    
       
else
    
% ___________________________________
% if there are no nans than start the recursive algorithm

ixe     = size(p,1);
ixs     = 1;

% logical vector for the vertices to be retained
I   = true(ixe,1);

% anonymous function for starting point and end point comparision
compare = @(a,b) (a+eps >= b && a <= b) || ...
                 (a-eps <= b && a >= b);

% call recursive function
p   = simplifyrec(p,tol,ixs,ixe);
ps  = p(I,:);

% if desired return the index of retained vertices
if nargout == 2;
    ix  = find(I);
end

end

% _________________________________________________________
function p  = simplifyrec(p,tol,ixs,ixe)
    
    % check if startpoint and endpoint are the same 

    c1 = num2cell(p(ixs,:));
    c2 = num2cell(p(ixe,:));   
    
    % same start and endpoint with tolerance (see anonymous function
    % compare)
    sameSE = all(cell2mat(cellfun(compare,c1(:),c2(:),'UniformOutput',false)));
    
    if sameSE; 
        % calculate the shortest distance of all vertices between ixs and
        % ixe to ixs only
        if dims == 2;
            d    = hypot(p(ixs,1)-p(ixs+1:ixe-1,1),p(ixs,2)-p(ixs+1:ixe-1,2));
        else
            d    = sqrt(sum(bsxfun(@minus,p(ixs,:),p(ixs+1:ixe-1,:)).^2,2));
        end
    else    
        % calculate shortest distance of all points to the line from ixs to ixe
        % subtract starting point from other locations
        pt = bsxfun(@minus,p(ixs+1:ixe,:),p(ixs,:));

        % end point
        a = pt(end,:)';

        beta = (a' * pt')./(a'*a);
        b    = pt-bsxfun(@times,beta,a)';
        if dims == 2;
            % if line in 2D use the numerical more robust hypot function
            d    = hypot(b(:,1),b(:,2));
        else
            d    = sqrt(sum(b.^2,2));
        end
    end
    
    % identify maximum distance and get the linear index of its location
    [dmax,ixc] = max(d);
    ixc  = ixs + ixc; 
    
    % if the maximum distance is smaller than the tolerance remove vertices
    % between ixs and ixe
    if dmax <= tol;
        if ixs ~= ixe-1;
            I(ixs+1:ixe-1) = false;
        end
    % if not, call simplifyrec for the segments between ixs and ixc (ixc
    % and ixe)
    else 
        % call recursive function
        p   = simplifyrec(p,tol,ixs,ixc);
        p   = simplifyrec(p,tol,ixc,ixe);

    end

end
end


