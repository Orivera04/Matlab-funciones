function  [Q,x_o,f_o] = quadr(fun,x1,x2,tol,trace,p1,p2,p3,p4,p5)

% QUADR Numerical evaluation of an integral.
%	Q = QUADS(F,X1,X2) approximates the integral of F(X)
%	from X1 to X2 with relative error  1e-4.  'F' is a string
%	containing the name of the function such as 'sin' or expression
%	depending on x (such as '1/(x+1)^2'). Function or expression F
%	must return a vector of output values of the same size as a
%	vector of input values.
%
%	Q = QUADS(F,X1,X2,TOL) integrates to a relative error of TOL.
%	Q = QUADS(F,X1,X2,TOL,TRACE) also traces the function
%	evaluations with a point plot (with different colors for each
%	recursion level).
%	Q = QUADS(F,X1,X2,TOL,TRACE,P1,P2,...) allows parameters P1, P2
%	to be passed directly to a function F in the form F(X,P1,P2,...).
%	When F stands for expression, its parameter dependence must
%	contain 'p1' ... explicitly, such as '(x-p1)/(x+p2)^p3'.
%	[Q,X,Y] = QUADS(F,...) also returns vector of points X of
%	function evaluation and corresponding function values Y.

%  Kirill K. Pankratov,  kirill@plume.mit.edu
%  01/30/95

 % Defaults and parameters ..................................
tol_dflt = 1e-4; % Default tolerance for integral estimation
trace_dflt = 0;  % No plotting by default
n_max = 7;       % Max. number of points inserted at one
                 % iteration between 2 old points
max_lev = 8;     % Max. number of iterations (recursion level)
pow = 1/4;       % Power index for estimation of number of
                 % inserted points

 % Coefficients ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 % Function interpolation coefficients ..........
 % (Lagrange polynomials interp. from 4 basis pts to 3 pts.
ci =  [-1/6   2/3    0    2/3  -1/6];   % [1 2 4 5] to 3

 % Integral approximation coefficients ..........
cq = [0.31111111111111;
      1.42222222222222;
      0.53333333333334;
      1.42222222222222;
      0.31111111111111];


 % Handle input .............................................
if nargin<5, trace = trace_dflt; end
if nargin<4, tol = tol_dflt; end
if trace==[],trace = trace_dflt; end
if tol==[] | all([tol(:); -1])<=0, tol = tol_dflt; end

 % Set up function call .....................................
is_fun = exist(fun); % Check if a function or expression
is_fun = is_fun & any(isletter(fun));
if is_fun          % .. Function
  call = [fun '(x'];
  for n = 1:nargin-5
     call = [call,',p',int2str(n)];
  end
  call = ['f = ' call,');'];

else               % .. Expression

  % Change to array operations (.* , .^, ./) :
  n_ins = fun=='*' | fun=='/' | fun=='^';
  nn = find(n_ins);
  n_ins = cumsum(n_ins+1);
  call = zeros(size(max(n_ins)));
  call(n_ins) = fun;
  call(~call) = '.'*ones(size(nn));
  % Add output and semicolon
  call = setstr(['f=' call ';']);
end

 % Initial layout ..............................
g = sqrt(3)/3;  % Initial layout section ratio (just some
                % number close but not equal to 1/2)
span = x2-x1;
x_o = [x1 x1+[1-g 1+g/117 1+g]*span/2 x2];

 % Auxillary ...................................
ci5 = ci(5);  ci = ci(1:4);
cq5 = cq(5); cq = cq(1:4)';
tol_f = tol/sqrt(span)*16;
o4 = ones(4,1);
if trace, col=get(gca,'colororder'); end % Colors for plot

 % Initialize output and control parameters ....
f_o = [];
n_ins = 3;
n_i = 1;
last = 1;
iter = 0;
is_more = 1;

 % Begin recursively refine approximations ..................
while is_more  % While not enough accuracy ``````````````````0

  iter = iter+1;

  % Insert new points ..........................
  F = n_ins(o4,:);
  [x_o,mask] = lininsrt(x_o,F);
  if iter==1, mask = ones(size(mask)); end

  % Expand "last" vector
  last = last(o4,1:n_i);
  last = [last(:)' last(n_i)];

  % Evaluate function at new points ............
  x = x_o(mask);
  eval(call);

  % Insert new points in the output and control vectors
  n_ins = find(~mask);
  misfit = find(mask);
  if iter>1,
    f_o(n_ins) = f_o;
    last(n_ins) = last;
  end
  f_o (misfit) = f;
  last(misfit) = ones(size(misfit));

  % Reshape function values vector ............
  l_o = length(x_o);
  n_i = (l_o-1)/4;
  F = reshape(f_o(1:l_o-1),4,n_i);

  % Calculate difference between actual
  % and interpolated values ...................
  misfit = ci*F+ci5*f_o(5:4:l_o);  % Interpolation
  misfit = abs(misfit-F(3,:));     % Difference

  % Calculate how many points need to be inserted
  scale = mean(abs(f_o));
  n_ins = (misfit/(tol_f*scale)).^pow-1;

  % Smooth (moving average)
  if iter>2
    misfit = cumsum(n_ins);
    n_ins(3:n_i-2) = (misfit(5:n_i)-misfit(1:n_i-4))/4;
    n_ins([1 2 n_i-1 n_i]) = n_ins([3 3 n_i-2 n_i-2]);
  end

  % Make it integer and upper bounded
  n_ins = min(ceil(n_ins),n_max);

  % If previous iteration was accurate
  % enough, do not insert new points .........
  misfit = n_ins>1;
  n_ins = max(n_ins,last(5:4:l_o));
  last = misfit;

  is_more = any(n_ins);  % If needs more points inserted

  if trace    % Plot new points ..............
    % Current color and marker size
    c_col = col(rem(iter-1,size(col,1))+1,:);
    c_mksz = ceil(15*.8^iter);
    l(iter) = plot(x,f,'.');
    set(l(iter),'color',c_col,'markersize',c_mksz)
    hold on, drawnow
  end

  % If still not enough accuracy .............
  if iter>max_lev
    disp(' Recursion level limit reached. Singularity likely.')
    is_more = 0;
  end

end  % End while (recursion) ''''''''''''''''''''''''''''''''0


if trace, hold off, end

 % Now calculate the integral itself .........
last = 5:4:l_o;
misfit = cq*F+cq5*f_o(last);
Q = (x_o(last)-x_o(last-1))*misfit';

