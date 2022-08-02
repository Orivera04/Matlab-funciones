function [Ind, R] = ray_casting( X, R, S, center )
%RAY_CASTING boundary identification using the ray casting technique
%   RAY_CASTING(X) is a list of the indices of the points on the boundary of 
%   a supersert of those data points given in the rows of X. 
% 
%   RAY_CASTING(X,R) uses spheres of radius R.
%   RAY_CASTING(X,'Auto') automatically estimates the required radius for 
%   the spheres by using the seperation distance.
%   [I,R] = RAY_CASTING(X,'Auto') returns the estimated radius in R.
%
%   RAY_CASTING(X,R,S), where S is a scalar, uses S directions. 
%   RAY_CASTING(X,R,S), where S is a matrix with as many columns as X, uses 
%   the directions given by the rows of S. 
%   RAY_CASTING(X,R,'Data'), uses the data to generate the directions.
%
%   RAY_CASTING(X,R,S,C), where C is a row vector with the same number of 
%   columns as X, specifies that C be used as the center of the sphere for 
%   the rays. 
%   RAY_CASTING(X,R,S,'LeastSquares') determines the center this sphere by 
%   the point that approximates the data best in the least square sense. 
%   This is the default. 
%   RAY_CASTING(X,R,S,'MinEllipse') uses as the center of the sphere the 
%   center of the minimal volume boundaing ellipsoid.
%
%   See also: SEPERATION, FIND_CENTER.
                
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/04/12 23:34:30 $ 


error( nargchk( 1, 4, nargin ) );
if nargin < 2,
    R = 'Auto';
end
if nargin < 3,
    S = 'Data';
end
if nargin < 4,
    center = 'LeastSquares';
end

if strcmpi( R, 'auto' ),
    R = separation( X );
end

[n,d] = size( X );

% if this is a 1-d problem, return min and max indices
if d == 1,
    [null, i] = min( X );
    [null, j] = max( X );
    Ind = [ i; j ];
    return
end
    
% find a center
if ischar( center )
    try,
        center = find_center( X, center );
    catch,
        error( lasterr );
    end
else
    % check the size of center
    if any( size( center ) ~= [1, d] ),
        error( 'C must have one row and the same number of columns as X.' );
    end
end

% subtract center from data points
X = X - center(ones(n,1),:);

% get directions
if strcmpi( S, 'data' ),
    S = X;
elseif prod( size( S ) ) == 1,
    switch d,
    case 2,
        t = linspace( -pi, pi, S+1 );
        t = t(1:S)';
        S = [ sin( t ), cos( t ) ];
    %case 3,
    %    S = partsphere( S );
    otherwise,
        % for the arbitary case, use random sample-- 
        %     need a more general version of partsphere
        S = 1 - 2*rand( S, d );
    end
end
N = size( S, 1 );

% inner products and norms
XX = sum( X.^2, 2 );
VV = sum( S.^2, 2 );



% [oldInd,old_min,old_max]= old(VV,XX,X*S',N,n,R);


t_max(1:N)= -Inf;
t_min(1:N)= Inf;
i_min= zeros(1,N);
i_max= zeros(1,N);

R2= R^2;
for j = 1:N
    % rows of S
    sj= 2*S(j,:).';
    vj= 4*VV(j);
    for i=1:n
        % rows of X
        p= X(i,:)*sj;
        
        D = p*p - vj*(XX(i)-R2);
        if D >= 0
            tmpMax = ( p + sqrt(D) )./ (2*VV(j)) ;
            tmpMin = ( p - sqrt(D) )./ (2*VV(j)) ;
            if tmpMax > t_max(j)
                t_max(j)= tmpMax;
                i_max(j)= i;
            end
            if tmpMin < t_min(j)
                t_min(j) = tmpMin;
                i_min(j) = i;
            end
        end
    end
end


% do the output thing
Ind = union( i_max, i_min );
if Ind(1)==0
    % remove zero point
    Ind= Ind(2:end);
end

return




function D= separation(X);

D= 0;
N= size(X,1);
for i=1:N-1
    x= X(i,:);
    h= Inf;
    for j= i+1:N
        e= X(j,:)-x;
        h= min( h , e*e');
    end
    D= max(D,h);
end

D= sqrt(D);

% ---------------------------------------------------------
% EOF


