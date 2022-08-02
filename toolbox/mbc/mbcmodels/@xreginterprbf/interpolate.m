function [om, OK] = interpolate( m )
%XREGINTERPRBF/INTERPOLATE   Find rbf coefficients by interpolation
%  [OM,OK] = INTERPOLATE(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:48:49 $ 

om = contextimplementation( xregoptmgr, m, @i_interpolate, [], ...
    'Interpolation', @interpolate );

% fit parameters
om = AddOption( om, 'PolyFromKernel', ...
    1, 'boolean', ...
    'Polynomial from kernel', logical(0) );

om = AddOption( om, 'ConincidentStrategy', ...
    'Mean', 'Maximum|Minimum|Mean', ...
    'Conincident Node Strategy', logical(1) );

om = AddOption( om, 'Algorithm', ...
    'Direct', 'Direct|GMRES|BICG|CGS|QMR', ...
    'Algorithm', logical(1) );

om = AddOption( om, 'Tolerance', ...
    1e-6, {'numeric',[0, Inf]}, ...
    'Tolerance', logical(1) );

om = AddOption( om, 'MaxIt', ...
    20, {'int', [1, Inf]}, ...
    'Maximum number of iterations', logical(1) );

om = AddOption( om, 'cost', ...
    0, {'numeric', [-Inf, Inf]}, ...
    [], logical(0) );

OK = 1;

return

% -------------------------------------------------------------------------|
function [m, cost,OK ] = i_interpolate( m, om, x0, x, y, varargin )
%  Inputs:		m   xreinterprbf object
%               om  xregoptmgr
%               x0  starting values (not used)
%				x   matrix of data points 
%				y   target values
%
% Outputs:     m    new rbf object
%              cost log10GCV

% should the polynomial degree be set by the kernel
if get( om, 'PolyFromKernel' ),
    m = check_degree( m, 'Hard' );
end

% if using a thin-plate, linear or cubic kernel, set the width to 1.0
if any( strcmpi( get( m, 'kernel' ), {'thinplate', 'linearrbf', 'cubicrbf'} ) ),
    m = setrbfpart( m, 'width', 1.0 );
end

% set the centers of the rbf to the input nodes
[centers, I, J] = unique( x, 'rows' ); % remove identical nodes
ncenters = size( centers, 1 );         % number of rbf centers
if ncenters == size( x, 1 ),
    % all nodes are centers,
    Y = y;
    centers = x;
else
    switch lower( get( om, 'ConincidentStrategy' ) ),
    case 'maximum'
        alg = @max;
    case 'minimum'
        alg = @min;
    case 'mean'
        alg = @mean;
    otherwise
        stack = dbstack;
        error( sprintf( '"Fool was coding error" at line %d in %s', ...
            stack(1).line, stack(1).name ) )
    end
    Y = zeros( ncenters, 1 );
    for i = 1:ncenters,
        Y(i) = feval( alg, y(find(J==i)) );
    end
end

poly = get( m, 'linearmodpart' );
poly_dim = size( poly, 1 );

% make sure the status of the rbf centers is ok.
current_status = get( m, 'status' );
m = setrbfpart( m, 'centers', centers );
m = setstatus( m, poly_dim+(1:ncenters), 1 ); % 1 == always
if poly_dim+ncenters < size( current_status, 1 ),
    % the new center list is shorter than the old.
    ind = (poly_dim+ncenters+1):size(current_status,1);
    m = setstatus( m, ind, 2 ); % 2 == never
end

% make sure the status of the linearmodpart is correct
nt=size(get( m, 'linearmodpart' ),1)+ncenters;
Tin= logical(ones(nt,1));
Tin(1:poly_dim)= Terms(poly);

% setup the interpolation system
FX = CalcJacob( m, centers );
n = size(FX,2) - ncenters; % dimension of polynomial space
if n > 0,
    P = FX(:,1:n);
    A = [ FX; zeros( n ),  P' ];
    b = [Y; zeros(n,1)];
else
    A = FX;
    b = Y;
end

% solve the interpolation system
maxit = get( om, 'MaxIt' );
tol = get( om, 'Tolerance' );
switch get( om, 'Algorithm' ),
case 'Direct',
    coeffs = A\b;
    flag = 0;
    relres = 0;
    iter = 0;
case 'GMRES',
    [coeffs, flag, relres, iter] = gmres(A,b,[],tol,maxit);
case 'BICG',
    [coeffs, flag, relres, iter] = bicg(A,b,tol,maxit);
case 'CGS',
    [coeffs, flag, relres, iter] = cgs(A,b,tol,maxit);
case 'QMR',
    [coeffs, flag, relres, iter] = qmr(A,b,tol,maxit);
otherwise
    error( sprintf( 'Unknown algorithm ''%s''.', get( om, 'Algorithm' )  ) );
end
if flag,
    warning( 'mbc:xreginterprbf:AlgorithmDidNotConverge', ...
        i_flagMessage( flag, get( om, 'Algorithm' ) ) );
end

beta= zeros(nt,1);
beta(Tin)= coeffs;

% set model coefficients
m = update( m, beta );

% setup the cost statistic
cost = 0;
setFitOpt( m, 'cost', cost ); 
OK = 1;

return

%------------------------------------------------------------------------------|
function msg = i_flagMessage( flag, alg ),
msg = [];
switch flag,
    case 0,
        msg = '';
    case 1,
        msg = sprintf( '%s iterated MAXIT times but did not converge', alg );
    case 2,
        msg = sprintf( 'The preconditioner for %s was ill-conditioned', alg );
    case 3,
        msg = sprintf( '%s stagnated (two consecutive iterates were the same)', alg );
    case 4,
        msg = sprintf( 'One of the scalar quantities calculated during %s became too small or too large to continue computing', alg );
    otherwise
        msg = sprintf( '%s failed to converge', alg );
end
return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
 
