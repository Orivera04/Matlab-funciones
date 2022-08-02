function [Q,x_o,f_o,sing] = quads(fun,x1,x2,tol,trace,p1,p2,p3,p4,p5)
% QUADS Numerical evaluation of an integral with possible singularities.
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
%	recursion level). TRACE can also have the second component in
%	the form [TRACE VERBOSE] where VERBOSE is an option for
%	displaying messages about singularity detection (default is 1 -
%	display).
%
%	Q = QUADS(F,X1,X2,TOL,TRACE,P1,P2,...) allows parameters P1, P2
%	to be passed directly to a function F in the form F(X,P1,P2,...).
%	When F stands for expression, its parameter dependence must
%	contain 'p1' ... explicitly, such as '(x-p1)/(x+p2)^p3'.
%	[Q,X,Y] = QUADS(F,...) also returns vector of points X of
%	function evaluation and corresponding function values Y.
%
%	[Q,X,Y,S] = QUADS(F,...) also returns a "singularity matrix" S
%	whose each colums contain a description of detected singularity:
%	[XS Nl Nr Bl Br T], so that the function F is approximated
%	as   F(X) = Bl/(XS-X)^Nl  in the left vicinity of XS
%	and  F(X) = Br/(X-XS)^Nr  in the right vicinity.
%	T is inferred type of singularity at XS: 1 - integrable, 2 -
%	integrable in the principle value sense, 3 - non-integrable,
%	4 - undetermined type.
%
%	WARNING:  Integral in the principal value sense for poles
%	of more than first order (such as B/(X-X0)^N where N>1)
%	can be very inaccurate.

%  Kirill K. Pankratov,  kirill@plume.mit.edu
%  01/30/95


 % Defaults and parameters ..................................
tol_dflt = 1e-4;    % Default tolerance for integral estimation
tol_sing = 1e-4;    % Tolerance for singularity
                    %  position location
tol_pv = [.01 .01]; % Tolerance for principal value
                    %  integrability
tol_mis = .1;       % Tolerance for relative misfit for
                    % singularity detection
n_max = 9;          % Max. nmb. of pts. inserted at one
                    %  iterations between 2 old points
max_lev = 6;        % Maximum number of iterations
                    %  (recursion level)
n_asym = 16;        % Number of intervals around singularity
                    % to be integrated in the asymptotic sense

trace_dflt = [0 1]; % No plotting, verbose  by default
h_edge = 1e-7;      % Minimum distance to the edges X1 and X2
pow = 1/4;          % Power index for estimation of nmb. of
                    %  inserted points


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


 % Messages for singularities .....................
msg_sing = ' Singularity at x = %f, '; % Beginning of a message
msg_i  = 'integrable \n';
msg_ni = 'non-integrable\n';
msg_pv = 'integrable in a principal value sense\n';
msg_un = 'undetermined type\n';
msg_warn = ' Undetermined singularity likely';

 % Trial points layout for locating singularity ...
cl = 11/23;        % Relative step between trial points
lay = (1:24)*cl;   % Trial points
[lay,last] = meshgrid(lay,-3:0);
lay = diff(log(lay-last));
olay = ones(1,size(lay,2));
 % For second iteration:
cl1 = cl/12;
cl10 = -12;
lay1 = ((1:24)+cl10)*cl1;
[lay1,last] = meshgrid(lay1,-3:0);
lay1 = lay1-last;
olay1 = ones(1,size(lay1,2));


 % Handle input ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
if nargin<5, trace = trace_dflt; end
if nargin<4, tol = tol_dflt; end
trace_dflt(1:length(trace)) = trace;
trace = trace_dflt;
verbose = trace(2); trace = trace(1);
if tol==[] | all([tol(:); -1])<=0, tol = tol_dflt; end

 % Set up function call .......................................
is_fun = exist(fun); % Check if a function or expression
if is_fun            % .. Function

  call = [fun '(x'];
  for n = 1:nargin-5
     call = [call,',p',int2str(n)];
  end
  call = ['f = ' call,');'];

else                 % .. Expression

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
g = sqrt(3)/3;  % Section ratio (just some number close
                % but not equal to 1/2)
span = x2-x1;
x_o = [x1+h_edge x1+[1-g 1+g/117 1+g]*span/2 x2-h_edge];

 % Auxillary ...................................
ci5 = ci(5); ci = ci(1:4);
cq5 = cq(5); cq = cq(1:4)';
tol_f = tol/sqrt(span);
o4 = ones(4,1);
if trace, col=get(gca,'colororder'); end % Colors for plot


 % Initialize output and control parameters ....
f_o = []; sing = [];
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
  x = x_o(mask);  % Extract new points
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

  % Calculate how many points need to be inserted for
  % the next recursion ........................
  scale = mean(abs(f_o(finite(f_o))));
  scale = mean(abs(f_o(abs(f_o)<scale)));
  if isnan(scale), scale = 1; end
  n_ins = (misfit./(tol_f*scale)).^pow-1;
  n_inf = find(~finite(n_ins));
  n_ins(n_inf) = n_max(ones(size(n_inf)));
  s = mean(abs(F));
  s(n_inf) = s(n_inf)+eps;
  x_inf = (misfit./s > tol_mis);

  % Smooth (moving average) ...................
  if iter>2
    misfit = cumsum(n_ins);
    n_ins(3:n_i-2) = (misfit(5:n_i)-misfit(1:n_i-4))/4;
    n_ins([1 2 n_i-1 n_i]) = n_ins([3 3 n_i-2 n_i-2]);
  end

  % Make it integer and upper limited .........
  n_ins = min(ceil(n_ins),n_max);

  % If previous iteration was accurate
  % enough, do not insert new points ..........
  misfit = n_ins>1;
  n_ins = max(n_ins,last(5:4:l_o));
  last = misfit;

  is_more = any(n_ins);  % If needs more points inserted

  if trace    % Plot new points ...............
    % Determine current color and marker size
    c_col = col(rem(iter-1,size(col,1))+1,:);
    c_mksz = ceil(14-1*iter);

    l(iter) = plot(x,f,'.');
    set(l(iter),'color',c_col,'markersize',c_mksz)
    hold on, drawnow
  end

  % If still not enough accuracy .................
  if iter>max_lev
    is_more = 0;
  end

end  % End while (recursion) ''''''''''''''''''''''''''''''''0



 % Estimate possible singularities ^^^^^^^^^^^^^^^^^^^^^^^^^^^
i_sing = zeros(size(n_ins));
misfit = find(~finite(f_o)); % Infinities
n_ins = x_inf;
q_s = 0; l_s = []; r_s = [];

 % Find if there are many close singularities ....
s2 = diff(find(diff(n_ins)>0));
if any(s2<=5), disp(msg_warn), end

if any(n_ins)   % If possible singularities detected ````````0

  % Find infinities (where singularity position is determined)
  n_inf = zeros(size(n_ins));
  x_inf = n_inf;
  n_inf(ceil(misfit/4)) = ones(size(misfit));
  x_inf(ceil(misfit/4)) = x_o(misfit);
  n_inf(ceil((misfit-1)/4)) = ones(size(misfit));
  x_inf(ceil((misfit-1)/4)) = x_o(misfit);

  % Find intervals in the vicinities of singularities
  [i_sing,num,nb,lr] = vicinity(n_ins,n_asym);
  l_sing = size(nb,2);

  % Find edges of singularities
  edge = (nb(1,:)-1)*4+1;
  v4 = (1:4)';
  edge = edge(o4,:)+v4(:,ones(1,l_sing));

  n_inf = n_inf(nb(1,:));
  x_inf = x_inf(nb(1,:));

  % Flip edges to the right of singularities
  edge(:,lr>0) = flipud(edge(:,lr>0))-1;
  if n_ins(1), edge(:,1) = edge(:,1)-3; end
  if n_ins(length(n_ins))==1,
    edge(:,size(edge,2)) = edge(:,size(edge,2))+3;
  end

  x_e = reshape(x_o(edge),4,l_sing); % Beginning of interval
  dx = x_e(2,:)-x_e(1,:);   % Step

  % Function values at the edges
  f_e = reshape(f_o(edge),4,l_sing); % Function values
  misfit = any(~f_e);
  f_e = log(abs(f_e+(f_e==0)));      % Logarithm

  n_fin = find(~n_inf); % Indicies of singularities

  for jj = n_fin   % Begin intervals count ``````````````1

    df = diff(f_e(:,jj));  % Difference in log. values

    % Calculate variance of ratio  d log(f) / d log(x)
    s = df(:,olay)./lay;
    s2 = sum(s)/3;
    s2 = sum((s-s2(ones(3,1),:)).^2);
    [mm,nn] = min(s2);      % Find minimum variance
    nn = max(2,nn);

    % Second iteration - around the estimated minimum

    s = df(:,olay1)./diff(log(lay1+cl*nn));
    s2 = sum(s)/3;
    s2 = sum((s-s2(ones(3,1),:)).^2);
    [mm,nn1] = min(s2);      % Find minimum variance

    % Choose three points around the minimum
    nn1 = nn1+(-1:1)+(nn1==1)-(nn1==length(s2));

    % Quadratic interpolation of the minimum position
    s3 = s2(nn1);         % Values at 3 min. points
    b = (s3(3)-s3(1))/2;
    a =  s3(1)-s3(2)+b;
    a = -b/2/a+nn1(2);

    x_sing(jj) = nn*cl+(a+cl10)*cl1;

  end % End intervals count '''''''''''''''''''''''''''''1

  % Rescale x_sing to actual values
  x_sing = x_e(4,:)+dx.*max(.01,x_sing);

  % Insert also explicit singularity points (where f_o=inf)
  nn = find(n_inf);
  x_sing(nn) = x_inf(nn);

  % Estimate n_sing (power index of asymptotics near
  % singularities)
  x_c = log(abs(x_e-x_sing(o4,:)));
  n_sing = zeros(l_sing,2);
  for jj = 1:length(x_sing)
    n_sing(jj,:) = -polyfit(x_c(:,jj),f_e(:,jj),1);
  end
  n_sing = n_sing(:,1)';

  % Estimate b (multiplier in f = b/(x-x0)^n ) .......
  b_sing  = f_o(edge(4,:));
  b_sing = b_sing.*abs(x_e(4,:)-x_sing).^n_sing;


  % Calculate integral in the asymptotic vicinities
  % of singularities .........................................

  % Arrange points and function values in the asymptotic
  % ranges into 3 by n matrices
  last = find(i_sing>1);  % Asymptotics intervals
  ll = length(last);
  num = num(last);      % Singularity indices
  % Make at first 6 by ll index matrix
  last = (last-1)*4;
  last = last(o4,:)+v4(:,ones(ll,1));

  last = last([1 2 3 3 4 4],:);
  last(6,:) = last(6,:)+1; % Close interval
  % Now reshape into 3 by ll*2
  ll = ll*2;
  last = reshape(last,3,ll);
  num = num([1 1],:); % Two 3-p intervals for each 5-p.
  num = num(:)';

  x_v = reshape(x_o(last),3,ll); % Points layout
  f_v = reshape(f_o(last),3,ll); % Function values

  % Calculate "slowly varying" multiplier to asymptotices ...

  % If close to 1/(x-x0), logarithmic integral
  n1 = n_sing-1;
  nn = abs(n1)<tol_pv(1);
  nn = nn(num);
  n1 = n1(num);

  o3 = ones(3,1);
  x_v0 = abs(x_v-x_sing(o3,num)); % |x-x0|
  f_v0 = x_v0.^(-n_sing(o3,num));
  f_v0 = f_v0.*b_sing(o3,num);    % b*|x-x0|^n
  f_v = f_v./(f_v0+eps*(f_v0==0));

  % Map x_v into an integrand for slowly-var. function
  n_fin = find(nn);
  x_v(:,n_fin) = log(x_v0(:,n_fin));
  n_fin = find(~nn);
  x_v(:,n_fin) = x_v0(:,n_fin).^(-n1(o3,n_fin));
  % Calculate integral of a slowly-varying function
  q_v = b_sing(num).*abs(quad3p(x_v,f_v));
  q_v(n_fin) = q_v(n_fin)./abs(n1(n_fin));


  % Add edges to sigularity vectors if necessary
  l_s = ones(n_ins(1));    % Left edge
  r_s = ones(n_ins(n_i));  % Right edge
  x_e  = x_e(4,:);
  x_e  =   [l_s*x1 x_e     r_s*x2];
  x_sing = [l_s*x1 x_sing  r_s*x2];
  n_sing = [l_s*0  n_sing  r_s*0];
  b_sing = [l_s*0  b_sing  r_s*0];
  misfit = [l_s*0  misfit  r_s*0];

  % Arrange in pairs (left-right) ...............
  l_sing = length(x_sing)/2;
  x_sing = reshape(x_sing,2,l_sing);
  misfit = any(reshape(misfit,2,l_sing));
  misfit = find( misfit | diff(x_sing>tol_sing) );
  x_sing = sum(x_sing)/2;
  x_e = reshape(x_e,2,l_sing);
  n_sing = reshape(n_sing,2,l_sing);
  b_sing = reshape(b_sing,2,l_sing);

  % Determine the type of singularity ...........
  % 0 - spurious, 1 - integrable, 2 - p.v.-integrable,
  % 3 - non-integrable, 4 - undetermined
  type_sing = 2-all(n_sing<=0)-all(n_sing<1-tol_pv(1));

  % Check left and right vicinity for p.v. integrability
  dx = abs(sum(b_sing))<tol_pv(1)*abs(b_sing(1,:));
  dx = dx & abs(diff(n_sing))<tol_pv(2); % If 1 conditions
         % for p.v. integr. are satisified
  type_sing = type_sing+(~dx).*(type_sing==2);
  % Undetermined type:
  type_sing(misfit) = 4*ones(size(misfit));

  % Form singularity matrix ......................
  dx = find(type_sing);
  sing = [x_sing(:,dx); n_sing(:,dx)];
  sing = [sing; b_sing(:,dx); type_sing(:,dx)];

  % Add integral in the nearest vicinity .........
  n_sing = 1-n_sing;
  o2 = [1 1];
  x_e = abs(x_e-x_sing(o2,:));
  nn = type_sing==2;
  dx = max(min(x_e).*nn,eps);
  if dx==[], dx = eps*ones(size(x_e)); end
  q_sing = zeros(size(x_e));
  nn = find(nn);
  q_sing(:,nn) = b_sing(:,nn).*log(x_e(:,nn)./dx(o2,nn));
  nn = find( ~all(abs(n_sing)<tol_pv(1)) );
  q_sing(:,nn) = dx(o2,nn).^n_sing(:,nn)-x_e(:,nn).^n_sing(:,nn);
  q_sing(:,nn) = -q_sing(:,nn).*b_sing(:,nn)./n_sing(:,nn);


  % Total integral around singularities ..........
  q_s = sum(sum(q_sing))+sum(q_v);

  % Display singularity detection messages ...................
  if verbose  % If to be displayed
    for jj = 1:size(sing,2) % For each singularity
      type_c = sing(6,jj);
      a = sing(1,jj);
      fprintf(msg_sing,sing(1,jj));

      % Now depending on type ....................
      if type_c==1, fprintf(msg_i);
      elseif type_c==2, fprintf(msg_pv);
      elseif type_c==3, fprintf(msg_ni);
      else, fprintf(msg_un);
      end
    end   % End for
  end   % End if verbose

end  % End if  any singularities ''''''''''''''''''''''''''''0

 % Calculate regular integral
last = 5:4:l_o;
last = last(~i_sing);
F = F(:,~i_sing);
misfit = cq*F+cq5*f_o(last);
Q = (x_o(last)-x_o(last-1))*misfit';

 % For regular edges, add integral at the edge
q_edge = 0;
if l_s==[], q_edge = h_edge*f_o(1); end
if r_s==[], q_edge = q_edge+h_edge*f_o(l_o); end

 % Add integral around singularity and at the edges
Q = Q+q_s+q_edge;
if sing~=[]
  is_inf = any(sing(6,:)==3);
  if is_inf, Q = inf; end
end

if trace, hold off, end

