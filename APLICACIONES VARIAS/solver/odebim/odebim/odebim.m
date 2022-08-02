function varargout = odebim(ode,tspan,y0,options,varargin)
%ODEBIM Solve stiff differential equations and DAEs of index up to 3, variable order method.
%   [TOUT,YOUT] = ODEBIM(ODEFUN,TSPAN,Y0) with TSPAN = [T0 TFINAL] integrates
%   the system of differential equations y' = f(t,y) from time T0 to TFINAL
%   with initial conditions Y0. ODEFUN is a function handle. For a scalar T
%   and a vector Y, ODEFUN(T,Y) must return a column vector corresponding
%   to f(t,y). Each row in the solution array YOUT corresponds to a time
%   returned in the column vector TOUT.  To obtain solutions at specific
%   times T0,T1,...,TFINAL (all increasing), use TSPAN =
%   [T0 T1 ... TFINAL].
%
%   [TOUT,YOUT] = ODEBIM(ODEFUN,TSPAN,Y0,OPTIONS) solves as above with default
%   integration properties replaced by values in OPTIONS, an argument created
%   with the ODESET function. See ODESET for details. Commonly used options
%   are scalar relative error tolerance 'RelTol' (1e-3 by default) and vector
%   of absolute error tolerances 'AbsTol' (all components 1e-6 by default).
%   The 'NonNegative' property is ignored.
%
%   The Jacobian matrix df/dy is critical to reliability and efficiency. Use
%   ODESET to set 'Jacobian' to a function handle FJAC if FJAC(T,Y) returns
%   the Jacobian df/dy or to the matrix df/dy if the Jacobian is constant.
%   If the 'Jacobian' option is not set (the default), df/dy is approximated
%   by finite differences. Set 'Vectorized' 'on' if the ODE function is coded
%   so that ODEFUN(T,[Y1 Y2 ...]) returns [ODEFUN(T,Y1) ODEFUN(T,Y2) ...].
%   If df/dy is a sparse matrix, set 'JPattern' to the sparsity pattern of
%   df/dy, i.e., a sparse matrix S with S(i,j) = 1 if component i of f(t,y)
%   depends on component j of y, and 0 otherwise.
%
%   ODEBIM can solve problems M*y' = f(t,y) with constant mass matrix.
%   The matrix can be used as the value of the 'Mass' option.
%
%   If the mass matrix is non-singular, the solution of the problem is
%   straightforward. See examples FEM1ODE, FEM2ODE, BATONODE, or
%   BURGERSODE. If M is singular, the problem is a differential-
%   algebraic equation (DAE). ODEBIM solves DAEs of index up to 3. DAEs have
%   solutions only when y0 is consistent, i.e., there is a yp0 such that
%   M(t0,y0)*yp0 = f(t0,y0).See examples HB1DAE or AMP1DAE.
%
%   [TOUT,YOUT,TE,YE,IE] = ODEBIM(ODEFUN,TSPAN,Y0,OPTIONS) with the 'Events'
%   property in OPTIONS set to a function handle EVENTS, solves as above
%   while also finding where functions of (T,Y), called event functions,
%   are zero. For each function you specify whether the integration is
%   to terminate at a zero and whether the direction of the zero crossing
%   matters. These are the three column vectors returned by EVENTS:
%   [VALUE,ISTERMINAL,DIRECTION] = EVENTS(T,Y). For the I-th event function:
%   VALUE(I) is the value of the function, ISTERMINAL(I)=1 if the integration
%   is to terminate at a zero of this event function and 0 otherwise.
%   DIRECTION(I)=0 if all zeros are to be computed (the default), +1 if only
%   zeros where the event function is increasing, and -1 if only zeros where
%   the event function is decreasing. Output TE is a column vector of times
%   at which events occur. Rows of YE are the corresponding solutions, and
%   indices in vector IE specify which event occurred.
%
%   SOL = ODEBIM(ODEFUN,[T0 TFINAL],Y0...) returns a structure that can be
%   used with DEVAL to evaluate the solution or its first derivative at
%   any point between T0 and TFINAL. The steps chosen by ODE15S are returned
%   in a row vector SOL.x.  For each I, the column SOL.y(:,I) contains
%   the solution at SOL.x(I). If events were detected, SOL.xe is a row vector
%   of points at which events occurred. Columns of SOL.ye are the corresponding
%   solutions, and indices in vector SOL.ie specify which event occurred.
%
%   Example
%         [t,y]=odebim(@vdp1000,[0 3000],[2 0]);
%         plot(t,y(:,1));
%     solves the system y' = vdp1000(t,y), using the default relative error
%     tolerance 1e-3 and the default absolute tolerance of 1e-6 for each
%     component, and plots the first component of the solution.
%
%   See also
%     other ODE solvers:    ODE23S, ODE23T, ODE23TB, ODE45, ODE23, ODE113
%     implicit ODEs:        ODE15I
%     options handling:     ODESET, ODEGET
%     output functions:     ODEPLOT, ODEPHAS2, ODEPHAS3, ODEPRINT
%     evaluating solution:  DEVAL
%     ODE examples:         VDPODE, FEM1ODE, BRUSSODE, HB1DAE
%     function handles:     FUNCTION_HANDLE
%
%   NOTE:
%     The interpretation of the first input argument of the ODE solvers and
%     some properties available through ODESET have changed in MATLAB 6.0.
%     Although we still support the v5 syntax, any new functionality is
%     available only with the new syntax.  To see the v5 help, type in
%     the command line
%         more on, type odebim, more off

%   NOTE:
%     This portion describes the v5 syntax of ODEBIM.
%
%   [T,Y] = ODEBIM('F',TSPAN,Y0) with TSPAN = [T0 TFINAL] integrates the
%   system of differential equations y' = F(t,y) from time T0 to TFINAL with
%   initial conditions Y0.  'F' is a string containing the name of an ODE
%   file.  Function F(T,Y) must return a column vector.  Each row in
%   solution array Y corresponds to a time returned in column vector T.  To
%   obtain solutions at specific times T0, T1, ..., TFINAL (all increasing
%   or all decreasing), use TSPAN = [T0 T1 ... TFINAL].
%
%   [T,Y] = ODEBIM('F',TSPAN,Y0,OPTIONS) solves as above with default
%   integration parameters replaced by values in OPTIONS, an argument
%   created with the ODESET function.  See ODESET for details.  Commonly
%   used options are scalar relative error tolerance 'RelTol' (1e-3 by
%   default) and vector of absolute error tolerances 'AbsTol' (all
%   components 1e-6 by default).
%
%   [T,Y] = ODEBIM('F',TSPAN,Y0,OPTIONS,P1,P2,...) passes the additional
%   parameters P1,P2,... to the ODE file as F(T,Y,FLAG,P1,P2,...) (see
%   ODEFILE).  Use OPTIONS = [] as a place holder if no options are set.
%
%   It is possible to specify TSPAN, Y0 and OPTIONS in the ODE file (see
%   ODEFILE).  If TSPAN or Y0 is empty, then ODE15S calls the ODE file
%   [TSPAN,Y0,OPTIONS] = F([],[],'init') to obtain any values not supplied
%   in the ODEBIM argument list.  Empty arguments at the end of the call
%   list may be omitted, e.g. ODEBIM('F').
%
%   The Jacobian matrix dF/dy is critical to reliability and efficiency.
%   Use ODESET to set JConstant 'on' if dF/dy is constant.  Set Vectorized
%   'on' if the ODE file is coded so that F(T,[Y1 Y2 ...]) returns
%   [F(T,Y1) F(T,Y2) ...].  Set JPattern 'on' if dF/dy is a sparse matrix
%   and the ODE file is coded so that F([],[],'jpattern') returns a sparsity
%   pattern matrix of 1's and 0's showing the nonzeros of dF/dy.  Set
%   Jacobian 'on' if the ODE file is coded so that F(T,Y,'jacobian') returns
%   dF/dy.
%
%   ODEBIM can solve problems M*y' = F(t,y) with a constant mass matrix M that
%   is nonsingular.  Use ODESET to set Mass to 'M', if the ODE file is coded so
%   that F(T,Y,'mass') returns a constant,respectively.The default value
%   of Mass is 'none'.
%
%   [T,Y,TE,YE,IE] = ODEBIM('F',TSPAN,Y0,OPTIONS) with the Events property
%   in OPTIONS set to 'on', solves as above while also locating zero
%   crossings of an event function defined in the ODE file.  The ODE file
%   must be coded so that F(T,Y,'events') returns appropriate information.
%   See ODEFILE for details.  Output TE is a column vector of times at which
%   events occur, rows of YE are the corresponding solutions, and indices in
%   vector IE specify which event occurred.
%
%   See also ODEFILE.
solver_name = 'odebim';

if nargin < 4
    options = [];
    if nargin < 3
        y0 = [];
        if nargin < 2
            tspan = [];
            if nargin < 1
                error('MATLAB:odebim:NotEnoughInputs',...
                    'Not enough input arguments.  See ODEBIM.');
            end
        end
    end
end

% Stats
nsteps   = 0;
nfailed  = 0;
nfevals  = 0;
npds     = 0;
ndecomps = 0;
nsolves  = 0;

% Output
FcnHandlesUsed  = isa(ode,'function_handle');
output_sol = (FcnHandlesUsed && (nargout==1));      % sol = odeXX(...)
output_ty  = (~output_sol && (nargout > 0));  % [t,y,...] = odeXX(...)
% There might be no output requested...

sol = [];
if output_sol
    sol.solver = solver_name;
    sol.extdata.odefun = ode;
    sol.extdata.options = options;
    sol.extdata.varargin = varargin;
end

% Handle solver arguments
[neq, tspan, ntspan, next, t0, tfinal, tdir, y0, f0, odeArgs, odeFcn, ...
    options, threshold, rtol, normcontrol, normy, hmax, htry, htspan] = ...
    odearguments(FcnHandlesUsed, solver_name, ode, tspan, y0, options, varargin);
nfevals = nfevals + 1;
atol = odeget(options,'AbsTol',1e-6,'fast');
oldt0 =t0;
% Handle the output
if nargout > 0
    outputFcn = odeget(options,'OutputFcn',[],'fast');
else
    outputFcn = odeget(options,'OutputFcn',@odeplot,'fast');
end
outputArgs = {};
if isempty(outputFcn)
    haveOutputFcn = false;
else
    haveOutputFcn = true;
    outputs = odeget(options,'OutputSel',1:neq,'fast');
    if isa(outputFcn,'function_handle')
        % With MATLAB 6 syntax pass additional input arguments to outputFcn.
        outputArgs = varargin;
    end
end
refine = max(1,odeget(options,'Refine',1,'fast'));
if ntspan > 2
    outputAt = 'RequestedPoints';         % output only at tspan points
elseif refine <= 1
    outputAt = 'SolverSteps';             % computed points, no refinement
else
    outputAt = 'RefinedSteps';            % computed points, with refinement
    S = (1:refine-1) / refine;
end
printstats = strcmp(odeget(options,'Stats','off','fast'),'on');

% Handle the event function
[haveEventFcn,eventFcn,eventArgs,valt,teout,yeout,ieout] = ...
    odeevents(FcnHandlesUsed,odeFcn,t0,y0,options,varargin);

% Handle the mass matrix. Note: ODEBIM only accepts constant Mass Matrices.
[Mtype, M] =  odemass(FcnHandlesUsed,odeFcn,t0,y0,options,varargin);
% [Mtype, M, Mfun, Margs, dMoptions] = odemass(FcnHandlesUsed,odeFcn,t0,y0,...
%                                               options,varargin);
if Mtype > 1
    nl = '\n         ';
    error('MATLAB:odebim:NonConstantMassMatrix',...
        ['ODEBIM cannot solve problems with non-constant mass ' ...
        nl,'matrices.  Use one of the other solvers of the ODE Suite.']);
end

% Non-negative solution components
idxNonNegative = odeget(options,'NonNegative',[],'fast');
nonNegative = ~isempty(idxNonNegative);
if nonNegative
    nl = '\n         ';
    warning('MATLAB:odebim:NonNegativeIgnored',...
        ['ODEBIM does not constrain the solution.' ...
        nl 'Option ''NonNegative'' will be ignored.']);
end
% Handle the Jacobian
[Jconstant,Jac,Jargs,Joptions] = ...
    odejacobian(FcnHandlesUsed,odeFcn,t0,y0,options,varargin);
Janalytic = isempty(Joptions);

% if not set via 'options', initialize constant Jacobian here
if Jconstant
    if isempty(Jac) % use odenumjac
        [Jac,Joptions.fac,nF] = odenumjac(odeFcn, {t0,y0,odeArgs{:}}, f0, Joptions);
        nfevals = nfevals + nF;
        npds = npds + 1;
    elseif ~isa(Jac,'numeric')  % not been set via 'options'
        Jac = feval(Jac,t0,y0,Jargs{:}); % replace by its value
        npds = npds + 1;
    end
end

nmeth=5;
kmax=10;
step_ord = [3;4;6;8;10;];
itmax = [10;12;14;16;18];

ordmin = 4;
ordmax = 12;


DaeIndex= odeget(options,'DaeIndex',[neq 0 0],'fast');
if (length(DaeIndex)~=3)||(sum(DaeIndex)~=neq)||(DaeIndex(1) ==0)
    error('MATLAB:odebim:IndexofDAEInvalid',...
        'Index of the DAE is invalid. ');
end
index1 = DaeIndex(1);
index2 = DaeIndex(2);
if (index1 == neq)
    indexd = 1;
elseif(index1+index2 == neq)
    indexd = 2;
else
    indexd = 3;
end


facnewtv = [1d-1;1d-1;1d-1;1d-1;1d-1];
facnsmall = 1d-2;
facnrestr = 5d-2;
facl = 1.2d-1;
facr = 10d0;
sfty = 1d0/20d0;
sftyup = .5d0*sfty;
sftydn = sfty;
rhomuv(1,1) = 1d-2*abs(log10(min(rtol,1d-1)));
rhomlv(1,1) = 5d-1;
for i=2:nmeth
    rhomuv(i,1) = rhomuv(i-1,1)^((step_ord(i))/(step_ord(i-1)));
    rhomlv(i,1) = rhomlv(i-1,1)^((step_ord(i))/(step_ord(i-1)));
end

tolestrapr = min(1d-2,1d2*rtol);
if (length(atol) == neq)
    for i = 1:neq
        tolestrapa(i,1) = min(1d-2,1d2*atol(i));
    end
else
    for i = 1:neq
        tolestrapa(i,1) = min(1d-2,1d2*atol(1));
    end
end


nodj00 = false;
errorbb = false;
t = zeros(kmax,1);
dfdy = zeros(neq,neq);
delj0 = zeros(neq,1);
y = zeros(neq,kmax);
f = zeros(neq,kmax);
scal = zeros(neq,1);
dd = zeros(kmax+1,neq);
ej0 = zeros(neq,1);
delj00 = zeros(neq,1);
vmax = zeros(8,1);

gamma4 =.7387d0;
gamma6 =.8482d0;
gamma8 =.7285d0;
gamma10=.6745d0;
gamma12=.6433d0;

rhot4 =.5021d0;
rhot6 =.8975d0;
rhot8 =.9178d0;
rhot10=.9287d0;
rhot12=.9361d0;

rhoi4 =  .9201d0;
rhoi6 = 1.2475d0;
rhoi8 = 1.7294d0;
rhoi10= 2.0414d0;
rhoi12= 2.2621d0;

vmax4_1 = 1d0/15d0;
vmax4_2 = 1d0/4d0;
vmax4_2_2 = 2d0/3d0;
vmax6_1 =  4d0/45d0;
vmax6_2 =  1d0/5d0;
vmax6_2_2 =  5d0/6d0;
vmax8_1 = 81d0/28d2;
vmax8_2 = 1d0/7d0;
vmax8_2_2 = 7d0/1d1;
vmax10_1 = 73d0/4619d0;
vmax10_2 = 1d0/9d0;
vmax10_2_2 = 761d0/1260d0;
vmax12_1 = 62d0/9913d0;
vmax12_2 =  1d0/11d0;
vmax12_2_2 = 671d0/1260d0;

scalj0     =1d-3;
itmaxj0    =3;

tolrhoj4=5d-3;
tolrhoj6=4d-3;
tolrhoj8=3d-3;
tolrhoj10=2d-3;
tolrhoj12=1d-3;

fatdj04 = 2d-2;
fatdj06 = 1d-2;
fatdj08 = 1d-3;
fatdj010= 2d-4;
fatdj012= 3d-5;

fatdj04i = 5d-2;
fatdj06i = 4d-2;
fatdj08i = 3d-2;
fatdj010i= 2d-2;
fatdj012i= 1d-2;

deltah2_4   =1.10d0;
deltah2_6   =1.09d0;
deltah2_8   =1.08d0;
deltah2_10  =1.07d0;
deltah2_12  =1.06d0;
deltah1_4sf =.90d0;
deltah1_6sf =.91d0;
deltah1_8sf =.92d0;
deltah1_10sf=.93d0;
deltah1_12sf=.94d0;

cfat4_1=-1.4487d0;
cfat4_2=2.3593d0;
cfat6_1=-1.4983d0;
cfat6_2=3.1163d0;
cfat8_1=-1.4662d0;
cfat8_2=3.5197d0;
cfat10_1=-1.4290d0;
cfat10_2=3.7538d0;
cfat12_1=-1.3964d0;
cfat12_2=3.9104d0;

rath1=.95d0;
rath2=1.05d0;
ratrho1=.95d0;
ratrho2 = 1.05d0;

faterr4=7d0;
faterr6=6d0;
faterr8=5d0;
faterr10 = 4d0;

facu1=1.25d0;
facu2=.8d0;

facnocon=.5d0;

flmx=1;

flhlt=10;

rhobad =.99d0;

tolminy0=1d-2;

cscal4=16d0;
cscal6=40d0;
cscal8=16d1;
cscal10=9d2;
cscal12=7d3;

csis  = (2*neq^2);
cfact = (2*neq^3)/3d0;

da4 = [-2.521802469135803e-001  -1.173275308641975e+000   -7.537666666666667e-001
       5.485722222222222e-001   8.207777777777778e-001   -1.108050000000000e+000
      -3.283111111111111e-001   5.896111111111111e-001    2.216100000000000e+000
       3.191913580246913e-002  -2.371135802469136e-001   -3.542833333333333e-001];
   
a24 = [-7.478197530864198e-001    1.732753086419753e-001   -2.462333333333333e-001
       4.514277777777778e-001   -8.207777777777778e-001    1.108050000000000e+000
       3.283111111111111e-001    4.103888888888889e-001   -2.216100000000000e+000
      -3.191913580246913e-002    2.371135802469136e-001    1.354283333333333e+000];
  
db4 = [ 6.807407407407408e-002    4.273592592592593e-001    3.750000000000000e-001
       1.529666666666667e-001    1.133333333333333e+000    1.125000000000000e+000
      -3.083333333333334e-001   -2.053666666666667e-001    1.125000000000000e+000
       7.500000000000000e-002   -6.666666666666667e-002   -3.637000000000000e-001];
   
b4  = [ 2.735925925925926e-001   -2.735925925925926e-002                         0];

da6 = [-2.288337890625000e-001   -9.602406250000000e-001   -1.143299414062500e+000   -1.212050000000000e+000
       6.333302083333333e-001    3.534166666666667e-001   -1.325312500000000e-002    1.130933333333333e+000
      -4.671726562500000e-001    1.159037500000000e+000    9.641648437500000e-001   -2.544600000000000e+000
       6.626562500000000e-002   -6.361500000000000e-001    4.301156250000000e-001    3.392800000000000e+000
      -3.589388020833334e-003    8.393645833333334e-002   -2.377279296875000e-001   -7.670833333333333e-001];

a26 = [-7.711662109375000e-001   -3.975937500000000e-002    1.432994140625000e-001    2.120500000000000e-001
       3.666697916666667e-001   -3.534166666666667e-001    1.325312500000000e-002   -1.130933333333333e+000
       4.671726562500000e-001   -1.590375000000000e-001   -9.641648437500000e-001    2.544600000000000e+000
      -6.626562500000000e-002    6.361500000000000e-001    5.698843750000000e-001   -3.392800000000000e+000
       3.589388020833334e-003   -8.393645833333334e-002    2.377279296875000e-001    1.767083333333333e+000];
   
db6 = [5.235329861111111e-003    3.580986111111111e-001    4.818783854166667e-001    3.111111111111111e-001
      3.490222222222222e-001    1.022222222222222e+000    1.108333333333333e+000    1.422222222222222e+000
     -8.166666666666667e-001   -4.820000000000000e-002    1.150000000000000e+000    5.333333333333333e-001
      4.472222222222222e-001   -3.111111111111111e-001   -4.898666666666667e-001    1.422222222222222e+000
     -1.013888888888889e-001    7.777777777777778e-002    4.166666666666667e-003   -5.370888888888888e-001];
 
b6 =  [2.683757812500000e-001    5.301250000000000e-002   -1.027117187500000e-001                         0];

da8 = [-3.908321598508230e-001   -1.406221193415638e+000   -1.043634114583333e+000   -7.991378600823045e-001   -1.033328687628601e+000   -1.121416666666667e+000
       7.404156635802469e-001    1.226758024691358e+000    2.731875000000000e-002   -4.245086419753086e-001   -4.103433641975308e-002    8.742000000000000e-001
      -3.281341628086420e-001    2.557608024691358e-001    3.756328125000000e-001    2.878024691358025e-001    4.307200038580247e-001   -2.731875000000000e+000
      -1.130474108367627e-001    6.795336076817558e-002    1.151770833333333e+000    3.917311385459534e-001   -1.057399262688615e+000    4.856666666666667e+000
       1.394745852623457e-001   -2.203487654320988e-001   -6.317460937500000e-001    9.010679012345679e-001    1.733068335262346e+000   -5.463750000000000e+000
      -5.677353395061729e-002    8.993827160493827e-002    1.365937500000000e-001   -3.957283950617284e-001    9.330979938271605e-002    4.371000000000000e+000
       8.897018604252401e-003   -1.384050068587106e-002   -1.593593750000000e-002    3.877338820301783e-002   -1.253358517661180e-001   -7.848250000000000e-001];

a28 = [-6.091678401491769e-001    4.062211934156378e-001    4.363411458333334e-002   -2.008621399176955e-001    3.332868762860082e-002    1.214166666666667e-001
       2.595843364197531e-001   -1.226758024691358e+000   -2.731875000000000e-002    4.245086419753086e-001    4.103433641975308e-002   -8.742000000000000e-001
       3.281341628086420e-001    7.442391975308642e-001   -3.756328125000000e-001   -2.878024691358025e-001   -4.307200038580247e-001    2.731875000000000e+000
       1.130474108367627e-001   -6.795336076817558e-002   -1.517708333333333e-001   -3.917311385459534e-001    1.057399262688615e+000   -4.856666666666667e+000
      -1.394745852623457e-001    2.203487654320988e-001    6.317460937500000e-001    9.893209876543210e-002   -1.733068335262346e+000    5.463750000000000e+000
       5.677353395061729e-002   -8.993827160493827e-002   -1.365937500000000e-001    3.957283950617284e-001    9.066902006172840e-001   -4.371000000000000e+000
      -8.897018604252401e-003    1.384050068587106e-002    1.593593750000000e-002   -3.877338820301783e-002    1.253358517661180e-001    1.784825000000000e+000];
db8 = [ 1.413114068930041e-001    4.775332157554380e-001    2.996406250000000e-001    2.106258083480306e-001    3.403636555702528e-001    2.928571428571429e-001
       1.992777777777778e-001    1.370158730158730e+000    1.620000000000000e+000    1.503492063492063e+000    1.380158730158730e+000    1.542857142857143e+000
      -3.961805555555555e-001   -4.150079365079365e-001    8.437500000000001e-002    3.301587301587302e-001    6.728670634920635e-001    1.928571428571429e-001
       1.240740740740741e-001   -5.502645502645503e-002    8.215000000000000e-001    1.693121693121693e+000    1.128306878306878e+000    1.942857142857143e+000
       3.784722222222222e-002    9.126984126984127e-002   -7.593750000000000e-001   -6.205634920634920e-001    1.106894841269841e+000    1.928571428571429e-001
      -4.444444444444445e-002   -5.206349206349206e-002    2.700000000000000e-001    8.126984126984127e-002   -3.205634920634921e-001    1.542857142857143e+000
       1.053240740740741e-002    1.052910052910053e-002   -4.187500000000000e-002   -1.354497354497355e-002   -1.301256613756614e-002   -4.356428571428572e-001];

b8 =   [1.990821116255144e-001   -1.558930041152263e-001   -2.276562500000000e-002    8.694032921810700e-002   -2.351511059670782e-002                         0];

da10 = [ -8.316231078334153e-001   -1.343097172737122e+000   -6.860686349657674e-001   -9.666043457031250e-001   -1.200819994825870e+000   -9.260000515619914e-001   -9.665559780783951e-001   -1.084312500000000e+000
    1.826938991144725e+000    1.167165884835379e+000   -9.604163169520242e-001   -7.969538690476191e-002    5.741141156128474e-001   -1.910934343610491e-001   -1.754056405226390e-001    7.708571428571429e-001
   -1.927724484503269e+000   -6.451529846191406e-002    1.933666054666042e+000    4.953359375000000e-002   -9.344392856558164e-001    2.332385101318359e-001    5.823807042479515e-001   -3.147666666666667e+000
    1.783382646004359e+000    9.247203979492188e-001   -8.250297395547231e-001    2.936885416666667e-001    1.058557936429977e+000   -8.615134684244792e-002   -1.327349272330602e+000    7.554400000000000e+000
   -1.426009772295753e+000   -1.288487873077393e+000    1.152395068332553e+000    1.230541992187500e+000   -4.654449404031038e-001   -3.407956123352051e-001    2.105080046976606e+000   -1.180375000000000e+001
    8.339545876026153e-001    9.145655721028646e-001   -9.398828437328338e-001   -6.871468750000001e-001    1.533959761857987e+000    1.027509191894531e+000   -2.448934563398361e+000    1.259066666666667e+001
   -3.278081615010897e-001   -3.998050994873047e-001    4.197220182220141e-001    1.963778645833333e-001   -6.862019841074943e-001    4.931795033772787e-001    2.397493568082651e+000   -9.443000000000000e+000
    7.706764499346415e-002    1.006645141601563e-001   -1.062303922176361e-001   -4.075104166666667e-002    1.336362001895905e-001   -2.255194702148438e-001   -8.338056769371033e-002    5.396000000000000e+000
   -8.178343611636331e-003   -1.121092528388614e-002    1.184478620237538e-002    4.055657087053572e-003   -1.336180909811741e-002    1.563270991189139e-002   -8.332829728350043e-002   -8.331946428571428e-001];

a210 = [-1.683768921665847e-001    3.430971727371216e-001   -3.139313650342325e-001   -3.339565429687500e-002    2.008199948258698e-001   -7.399994843800863e-002   -3.344402192160487e-002    8.431250000000000e-002
   -8.269389911447252e-001   -1.167165884835379e+000    9.604163169520242e-001    7.969538690476191e-002   -5.741141156128474e-001    1.910934343610491e-001    1.754056405226390e-001   -7.708571428571429e-001
    1.927724484503269e+000    1.064515298461914e+000   -1.933666054666042e+000   -4.953359375000000e-002    9.344392856558164e-001   -2.332385101318359e-001   -5.823807042479515e-001    3.147666666666667e+000
   -1.783382646004359e+000   -9.247203979492188e-001    1.825029739554723e+000   -2.936885416666667e-001   -1.058557936429977e+000    8.615134684244792e-002    1.327349272330602e+000   -7.554400000000000e+000
    1.426009772295753e+000    1.288487873077393e+000   -1.152395068332553e+000   -2.305419921875000e-001    4.654449404031038e-001    3.407956123352051e-001   -2.105080046976606e+000    1.180375000000000e+001
   -8.339545876026153e-001   -9.145655721028646e-001    9.398828437328338e-001    6.871468750000001e-001   -5.339597618579864e-001   -1.027509191894531e+000    2.448934563398361e+000   -1.259066666666667e+001
    3.278081615010897e-001    3.998050994873047e-001   -4.197220182220141e-001   -1.963778645833333e-001    6.862019841074943e-001    5.068204966227213e-001   -2.397493568082651e+000    9.443000000000000e+000
   -7.706764499346415e-002   -1.006645141601563e-001    1.062303922176361e-001    4.075104166666667e-002   -1.336362001895905e-001    2.255194702148438e-001    1.083380567693710e+000   -5.396000000000000e+000
    8.178343611636331e-003    1.121092528388614e-002   -1.184478620237538e-002   -4.055657087053572e-003    1.336180909811741e-002   -1.563270991189139e-002    8.332829728350043e-002    1.833194642857143e+000];

db10 = [    2.797418832186416e-001    3.977655613254386e-001    1.666573006439087e-001    2.842827188553565e-001    3.624000511461724e-001    2.526116870210923e-001    2.824378357148776e-001    2.790828924162258e-001
    4.300771396813063e-001    1.686507002697479e+000    1.637316349325278e+000    1.506061909871434e+000    1.583138243480506e+000    1.635184498041641e+000    1.560320840425007e+000    1.661516754850088e+000
   -8.263829187787521e-001   -1.316692498859166e+000   -1.146474012099012e-001    3.203177069843737e-001    6.055797982881316e-002   -1.302886002886003e-001    1.463712714754381e-001   -2.618694885361552e-001
    6.568911682453349e-001    1.593908807242141e+000    1.492518016705517e+000    1.704338131004798e+000    2.176131064151897e+000    2.589148629148629e+000    1.989954216308383e+000    2.961834215167548e+000
   -2.806935734019068e-001   -1.692650559317226e+000   -1.732042610167610e+000   -5.573036161369495e-001   -6.198469740136407e-003   -6.150072150072150e-001    2.369061879478546e-001   -1.281128747795415e+000
   -1.799309101392435e-002    1.193908807242141e+000    1.151393016705517e+000    4.507887174553842e-002    4.860060641518975e-001    2.189148629148629e+000    1.315069957049124e+000    2.961834215167548e+000
    8.669578492495159e-002   -5.421924988591655e-001   -5.052724012099013e-001    2.402141068807736e-002   -3.300670201711868e-001   -7.047886002886002e-001    1.059449975179142e+000   -2.618694885361552e-001
   -4.021452698536032e-002    1.436498598403360e-001    1.306199207538493e-001   -1.774761393809013e-002    7.644181490907681e-002    9.232735518449804e-002   -2.589708262416596e-001    1.661516754850088e+000
    6.447740145656813e-003   -1.689803142184095e-002   -1.507190973708831e-002    3.276652800462324e-003   -8.134302591147830e-003   -1.154091939806226e-002   -1.391307959016292e-002   -3.954171075837742e-001];
b10 = [  3.093039396405220e-002   -1.218064498901367e-001    1.140297181904316e-001    1.317382812500000e-002   -7.477542516589165e-002    2.870453643798828e-002    7.873621731996537e-003                         0];

da12 = [-1.238504702421455e+000   -9.602642645507413e-001   -7.312038597616039e-001   -1.270464308215125e+000   -1.025250063476562e+000   -8.067753268263254e-001   -1.087894266876837e+000   -1.041771022507008e+000   -9.417290146092545e-001   -1.064330000000000e+000
    3.210504894499178e+000   -1.711280013084444e-002   -9.384193589180667e-001    9.310079634375111e-001    8.156922743055556e-002   -6.553186339669334e-001    2.937660670063778e-001    1.569347228558222e-001   -2.549558995186000e-001    7.147777777777777e-001
   -5.221191637623150e+000    2.143601300294400e+000    2.292371682565650e+000   -2.140717917734400e+000   -1.595984700520833e-001    1.453789426425600e+000   -6.328292757643500e-001   -4.143697930922667e-001    8.062726489168500e-001   -3.618562500000000e+000
    7.995518466885600e+000   -2.355740089412267e+000   -2.157859102338934e+000    4.050787409305600e+000    1.986380208333334e-001   -2.523247869201067e+000    1.049978156914400e+000    8.891433358677333e-001   -1.984773598074400e+000    1.102800000000000e+001
   -9.931230487787349e+000    2.341392200686933e+000    3.660204759319850e+000   -3.598306808046933e+000    7.433968098958334e-002    3.150937828326400e+000   -1.213920810116817e+000   -1.467207294993067e+000    3.618212847472650e+000   -2.251550000000000e+001
    9.263795268275857e+000   -2.007571179326123e+000   -3.919075568947056e+000    3.868856135725056e+000    1.443273906250000e+000   -2.561724315193344e+000    8.501469777121440e-001    1.888849669860011e+000   -4.932488733573744e+000    3.242232000000000e+001
   -6.320613658524900e+000    1.310755911569067e+000    2.815394839546567e+000   -2.901138983142400e+000   -8.439124348958333e-001    3.079181885550933e+000    6.632223769990001e-002   -1.978827085550933e+000    5.114001898315100e+000   -3.377325000000000e+001
    3.059050771522400e+000   -6.174962287957333e-001   -1.401943901002400e+000    1.455975556369067e+000    3.039401041666667e-001   -1.501506229657600e+000    1.030313972010933e+000    1.949488096324267e+000   -4.159017256317600e+000    2.573200000000000e+001
   -9.951354094057875e-001    1.972551167402667e-001    4.645360456414125e-001   -4.834857294336000e-001   -8.776420084635417e-002    4.409879816064000e-001   -4.115066939410875e-001    1.397642183936000e-001    2.993030662229212e+000   -1.447425000000000e+001
    1.952935685246000e-001   -3.820759507626666e-002   -9.235585469460000e-002    9.618409470293333e-002    1.615429687500000e-002   -8.370503340373334e-002    6.043758769206667e-002   -1.277874999296000e-001   -1.959689888354000e-001    6.433000000000000e+000
   -1.748707394499178e-002    3.387628001308444e-003    8.350318589180667e-003   -8.697412967708445e-003   -1.390067274305556e-003    7.380286339669333e-003   -4.813952336730445e-003    5.782652771441778e-003   -6.258456600481401e-002   -8.842052777777778e-001];
  
a212 = [2.385047024214545e-001   -3.973573544925867e-002   -2.687961402383962e-001    2.704643082151254e-001    2.525006347656250e-002   -1.932246731736747e-001    8.789426687683717e-002    4.177102250700800e-002   -5.827098539074550e-002    6.433000000000000e-002
   -2.210504894499178e+000    1.711280013084444e-002    9.384193589180667e-001   -9.310079634375111e-001   -8.156922743055556e-002    6.553186339669334e-001   -2.937660670063778e-001   -1.569347228558222e-001    2.549558995186000e-001   -7.147777777777777e-001
    5.221191637623150e+000   -1.143601300294400e+000   -2.292371682565650e+000    2.140717917734400e+000    1.595984700520833e-001   -1.453789426425600e+000    6.328292757643500e-001    4.143697930922667e-001   -8.062726489168500e-001    3.618562500000000e+000
   -7.995518466885600e+000    2.355740089412267e+000    3.157859102338934e+000   -4.050787409305600e+000   -1.986380208333334e-001    2.523247869201067e+000   -1.049978156914400e+000   -8.891433358677333e-001    1.984773598074400e+000   -1.102800000000000e+001
    9.931230487787349e+000   -2.341392200686933e+000   -3.660204759319850e+000    4.598306808046933e+000   -7.433968098958334e-002   -3.150937828326400e+000    1.213920810116817e+000    1.467207294993067e+000   -3.618212847472650e+000    2.251550000000000e+001
   -9.263795268275857e+000    2.007571179326123e+000    3.919075568947056e+000   -3.868856135725056e+000   -4.432739062500000e-001    2.561724315193344e+000   -8.501469777121440e-001   -1.888849669860011e+000    4.932488733573744e+000   -3.242232000000000e+001
    6.320613658524900e+000   -1.310755911569067e+000   -2.815394839546567e+000    2.901138983142400e+000    8.439124348958333e-001   -2.079181885550933e+000   -6.632223769990001e-002    1.978827085550933e+000   -5.114001898315100e+000    3.377325000000000e+001
   -3.059050771522400e+000    6.174962287957333e-001    1.401943901002400e+000   -1.455975556369067e+000   -3.039401041666667e-001    1.501506229657600e+000   -3.031397201093333e-002   -1.949488096324267e+000    4.159017256317600e+000   -2.573200000000000e+001
    9.951354094057875e-001   -1.972551167402667e-001   -4.645360456414125e-001    4.834857294336000e-001    8.776420084635417e-002   -4.409879816064000e-001    4.115066939410875e-001    8.602357816064000e-001   -2.993030662229212e+000    1.447425000000000e+001
   -1.952935685246000e-001    3.820759507626666e-002    9.235585469460000e-002   -9.618409470293333e-002   -1.615429687500000e-002    8.370503340373334e-002   -6.043758769206667e-002    1.277874999296000e-001    1.195968988835400e+000   -6.433000000000000e+000
    1.748707394499178e-002   -3.387628001308444e-003   -8.350318589180667e-003    8.697412967708445e-003    1.390067274305556e-003   -7.380286339669333e-003    4.813952336730445e-003   -5.782652771441778e-003    6.258456600481401e-002    1.884205277777778e+000];
db12 = [3.886511017048409e-001    2.511424955730658e-001    1.870572550202376e-001    3.687673161686370e-001    2.788328416416698e-001    2.083041071140353e-001    3.069694839813847e-001    2.863690656134195e-001    2.578610954240839e-001    2.683414836192614e-001
    6.759174036853367e-001    1.787280939023858e+000    1.668693953974796e+000    1.685469369652376e+000    1.751421559470647e+000    1.707656485368904e+000    1.684804753427098e+000    1.725167523511750e+000    1.697727342669132e+000    1.775359414248303e+000
   -1.630313399807119e+000   -1.786465460175264e+000   -2.791395339580082e-001   -3.705733627302255e-001   -6.628864218286706e-001   -4.683827555886380e-001   -3.633136165021888e-001   -5.482979475136338e-001   -4.162183545110935e-001   -8.104357062690396e-001
    2.410981970326333e+000    3.031004425252792e+000    2.006250661983260e+000    3.265068061930807e+000    4.015915084899970e+000    3.509020681569701e+000    3.219458738656043e+000    3.725643439107492e+000    3.342237040601011e+000    4.549462882796216e+000
   -2.742089094014645e+000   -4.340033758301733e+000   -2.621378837042134e+000   -2.815017432893904e+000   -3.070792591255724e+000   -2.232929049889834e+000   -1.696566295734494e+000   -2.617794889690315e+000   -1.868222856766055e+000   -4.351551226551226e+000
    2.294269423840502e+000    4.476234513489415e+000    2.234203711593418e+000    2.321560037638469e+000    4.010394220177063e+000    4.111800574153516e+000    3.383927780190035e+000    4.565833585441428e+000    3.518702249547838e+000    7.137646304312971e+000
   -1.379432844014646e+000   -3.320774499042473e+000   -1.388722587042134e+000   -1.531717432893903e+000   -3.088877081996465e+000   -2.236229049889834e+000   -4.639100457344942e-001   -1.598535630431055e+000   -5.055666067660553e-001   -4.351551226551226e+000
    5.764283988977617e-001    1.730686964935331e+000    6.064256619832600e-001    7.050680619308071e-001    1.566758338868225e+000    9.490206815697012e-001    5.330337386560425e-001    2.425325978790031e+000    1.507683469172440e+000    4.549462882796216e+000
   -1.576683105214049e-001   -6.022130792228831e-001   -1.757801589580082e-001   -2.162876484445112e-001   -5.350032373048611e-001   -3.140970413029237e-001   -2.599542415021888e-001   -6.506455665612528e-001    1.056426734774621e+000   -8.104357062690396e-001
    2.506561797105098e-002    1.257641841737702e-001    3.025645397479548e-002    3.975508393809048e-002    1.100387331919876e-001    6.194219965461795e-002    4.636725342709820e-002    6.365076866166190e-002   -2.397244430451538e-001    1.775359414248303e+000
   -1.717306395870530e-003   -1.193356127451988e-002   -2.328100754622405e-003   -3.312369064003051e-003   -1.030632867634161e-002   -5.551362822604653e-003   -3.847469941475252e-003   -6.365076866166191e-003   -1.166001105262748e-002   -3.749585163807386e-001];
b12 = [-1.033929616721400e-001    1.600683556864000e-002    9.116151922514000e-002   -9.207968523264000e-002   -8.795117187500000e-003    6.614453006336001e-002   -3.027007892286000e-002   -1.365125006336000e-002    1.745433995186000e-002                         0];


smallm   = (neq<=5);
%     vector to be used for the estimate of jacobian variation
nerr     = 0.3141592654d0;
nerrup   = 0d0;
for i = 1:neq
    nerr   = 4d0*nerr*(1d0-nerr);
    ej0(i) = nerr;
    if (nerr<5d-1)
        ej0(i)=ej0(i)+5d-1;
    end
    nerrup = max(nerrup,ej0(i));
end

for i = 1:neq
    ej0(i)=ej0(i)/nerrup;
end

nfailconv  = 0;
nferrcons  = 0;
nfailcons  = 0;
niter = zeros(nmeth,1);
nstep     = zeros(nmeth,1);
naccept   = zeros(nmeth,1);
nfailerr  = zeros(nmeth,1);
nfailnewt = zeros(nmeth,1);


uround = eps;
maxstep = 10000000;
ord     = ordmin;
ord_ind = (ord/2) - 1;
k       = step_ord(ord_ind);
kold    = 0;
% -------------------------------------------------------
%     initial stepsize too small !!!!!
hmin = 16*eps(t0);
pow = 1/5;
if isempty(htry)
    % Compute an initial step size h using y'(t).
    h = min(hmax, htspan);
    if normcontrol
        rh = (norm(f0) / max(normy,threshold)) / (0.8 * rtol^pow);
    else
        rh = norm(f0 ./ max(abs(y0),threshold),inf) / (0.8 * rtol^pow);
    end
    if h * rh > 1
        h = 1 / rh;
    end
    h = 100*max(h, hmin);
else
    h = min(hmax, max(100*hmin, htry));
end
if (h<=1d1*uround*t0)
    h = 2d1*uround*t0;
end
% -------------------------------------------------------

% rtolatol =  rtol/atol;

rho      =  0d0;
% maxdelta =  0d0;

last     = false;
extrap   = false;
extrap0  = false;
restrict = false;
success  = false;
caljac   = true;
caljac0  = true;
calfact0 = true;
% linear   = false;
qinf = false;

nj0     = 0D0;
nerrloc = 0D0;
h0  = 0D0;
nodj0  = false;
err = zeros(neq,kmax) ;


scalextrap=1.0./(1.0+abs(y0));



hfatt=1.0;

miny0 = tolminy0 + 1.0;

% Allocate memory if we're generating output.
nout = 0;
tout = []; yout = [];
if nargout > 0
    if output_sol
        chunk = min(max(100,50*refine), refine+floor((2^11)/neq));
        tout = zeros(1,chunk);
        yout = zeros(neq,chunk);
    else
        if ntspan > 2                         % output only at tspan points
            tout = zeros(1,ntspan);
            yout = zeros(neq,ntspan);
        else                                  % alloc in chunks
            chunk = min(max(100,50*refine), refine+floor((2^13)/neq));
            tout = zeros(1,chunk);
            yout = zeros(neq,chunk);
        end
    end
    nout = 1;
    tout(nout) = t0;
    yout(:,nout) = y0;
end

% Initialize the output function.
if haveOutputFcn
    feval(outputFcn,[t0 tfinal],y0(outputs),'init',outputArgs{:});
end
%     main loop
%100   continue
addbool2 = true;
while(addbool2)
    %      if (k == kold)  goto 140
    if (k ~= kold)
        %     the order of the method has been changed
        esp1 = 1/(k+1);
        if (ord < ordmax)
            espup=1/(step_ord(ord_ind+1)+1);
        end
        if (ord > ordmin)
            espdn=1d0/(step_ord(ord_ind-1)+1);
        end
        maxit    = itmax(ord_ind);
        rhoml    = rhomlv(ord_ind);
        rhomu    = rhomuv(ord_ind);
        rhoold   = 0d0;
        nord     = 0;
        nerror   = 0;
        errorbb = false;
        minit = indexd;
        %     define the parameters depending on the order of the method
        switch ord_ind
            case 1
                gamma  = gamma4;
                rhot   = rhot4;
                rhotup = rhot6;
                rhoi   = rhoi4;
                rhoiup = rhoi6;
                siserr = 2;
                siserrup  = 3;
                faterr = faterr4;
                vmax(1)  = vmax4_1;
                vmax(2)  = gamma4*vmax4_2;
                vmax(3)  = gamma4*gamma4*vmax4_2_2;
                vmax(7)  = gamma4*vmax6_2;
                vmax(8)  = gamma4*gamma4*vmax6_2_2;
                fatdj0 = fatdj04;
                fatdj0i = fatdj04i;
                tolrhoj0 = tolrhoj4;
                deltah2= deltah2_4;
                deltah1sf = deltah1_4sf;
                cfat1  = cfat4_1;
                cfat2  = cfat4_2;
                cscal = cscal4;
            case 2
                gamma  = gamma6;
                rhot   = rhot6;
                rhotup = rhot8;
                rhoi   = rhoi6;
                rhoiup = rhoi8;
                siserr = 3;
                siserrup  = 3;
                faterr = faterr6;
                vmax(1)  = vmax6_1;
                vmax(2)  = gamma6*vmax6_2;
                vmax(3)  = gamma6*gamma6*vmax6_2_2;
                vmax(4)  = vmax4_1;
                vmax(5)  = gamma6*vmax4_2;
                vmax(6)  = gamma6*gamma6*vmax4_2_2;
                vmax(7)  = gamma6*vmax8_2;
                vmax(8)  = gamma6*gamma6*vmax8_2_2;
                fatdj0 = fatdj06;
                fatdj0i = fatdj06i;
                tolrhoj0 = tolrhoj6;
                deltah2= deltah2_6;
                deltah1sf = deltah1_6sf;
                cfat1  = cfat6_1;
                cfat2  = cfat6_2;
                cscal = cscal6;
            case  3
                gamma  = gamma8;
                rhot   = rhot8;
                rhotup = rhot10;
                rhoi   = rhoi8;
                rhoiup = rhoi10;
                siserr = 3;
                siserrup  = 3;
                faterr = faterr8;
                vmax(1)  = vmax8_1;
                vmax(2)  = gamma8*vmax8_2;
                vmax(3)  = gamma8*gamma8*vmax8_2_2;
                vmax(4)  = vmax6_1;
                vmax(5)  = gamma8*vmax6_2;
                vmax(6)  = gamma8*gamma8*vmax6_2_2;
                vmax(7)  = gamma8*vmax10_2;
                vmax(8)  = gamma8*gamma8*vmax10_2_2;
                fatdj0 = fatdj08;
                fatdj0i = fatdj08i;
                tolrhoj0 = tolrhoj8;
                deltah2= deltah2_8;
                deltah1sf = deltah1_8sf;
                cfat1  = cfat8_1;
                cfat2  = cfat8_2;
                cscal = cscal8;
            case 4
                gamma  = gamma10;
                rhot   = rhot10;
                rhotup = rhot12;
                rhoi   = rhoi10;
                rhoiup = rhoi12;
                siserr = 3;
                siserrup  = 3;
                faterr = faterr10;
                vmax(1)  = vmax10_1;
                vmax(2)  = gamma10*vmax10_2;
                vmax(3)  = gamma10*gamma10*vmax10_2_2;
                vmax(4)  = vmax8_1;
                vmax(5)  = gamma10*vmax8_2;
                vmax(6)  = gamma10*gamma10*vmax8_2_2;
                vmax(7)  = gamma10*vmax12_2;
                vmax(8)  = gamma10*gamma10*vmax12_2_2;
                fatdj0 = fatdj010;
                fatdj0i = fatdj010i;
                tolrhoj0 = tolrhoj10;
                deltah2= deltah2_10;
                deltah1sf = deltah1_10sf;
                cfat1  = cfat10_1;
                cfat2  = cfat10_2;
                cscal = cscal10;
            case 5
                gamma  = gamma12;
                rhot   = rhot12;
                rhoi   = rhoi12;
                siserr = 3;
                vmax(1)  = vmax12_1;
                vmax(2)  = gamma12*vmax12_2;
                vmax(3)  = gamma12*gamma12*vmax12_2_2;
                vmax(4)  = vmax10_1;
                vmax(5)  = gamma12*vmax10_2;
                vmax(6)  = gamma12*gamma12*vmax10_2_2;
                fatdj0 = fatdj012;
                fatdj0i = fatdj012i;
                tolrhoj0 = tolrhoj12;
                deltah2= deltah2_12;
                deltah1sf = deltah1_12sf;
                cfat1  = cfat12_1;
                cfat2  = cfat12_2;
                cscal = cscal12;
        end
    end
    %-------------------------------------------------------------------------------------------------------------------
    %     jacobian evaluation
    linear = false;
    estim =(~smallm)&&(success||(~success && caljac))&&(Mtype == 0);
    if (estim)
        scalj0_1 = max(abs(y0));
        scalj0_1  = scalj0*(1+scalj0_1);
        delj0 = y0 + scalj0_1*ej0;
        fj0 = feval(odeFcn,t0,delj0,odeArgs{:});
        nfevals = nfevals + 1;
        nj00 = nj0;
        scalj0_1 = 1/scalj0_1;
        delj0 = scalj0_1*(fj0-f0);
        nj0 = max(abs(delj0));
    end

    if (success)
        caljac=caljac0||(Mtype ~= 0);
        if (~caljac)
            estim1 = estim && (~nodj00) && (~nodj0);
            if (estim1)
                dj0   = max(abs(delj0-delj00));
                caljac=(dj0>(1e2*uround*nj00));
                linear =~caljac;
            end
            if (estim1&&(~linear))
                caljac=(k~=kold)||(~extrap);
                if (~caljac)
                    caljac=(rho>=tolrhoj0)&&(it>=itmaxj0);
                    if (~(~caljac||~estim1))
                        nqinf  = ~(qinf||qinfj);
                        caljac=~( ((rho<5e-2) || (it < 4)) ...
                            &&( (qinf&&(dj0 <= fatdj0i*nj00))...
                            ||((~qinf)&&nqinf&&(rhoj0<1)...
                            &&(hj0*dj0 <= fatdj0*rhoj0/rhot)) ));
                    end
                end
            elseif(~estim1)
                caljac=(k~=kold)||(~extrap);
                if (~caljac)
                    caljac=(rho>=tolrhoj0)&&(it>=itmaxj0);
                    if (~(~caljac||~estim1))
                        nqinf  = ~(qinf||qinfj);
                        caljac=~( ((rho<5d-2) || (it < 4)) ...
                            &&( (qinf&&(dj0 <= fatdj0i*nj00))...
                            ||((~qinf)&&nqinf&&(rhoj0<1d0)...
                            &&(hj0*dj0 <= fatdj0*rhoj0/rhot)) ));
                    end
                end
            end
        end
    end

    truejac = caljac ||(~success);
    if (caljac)
        if Jconstant
            dfdy = Jac;
        elseif (~Janalytic)
            %     numerical jacobian
            f0 = feval(odeFcn,t0,y0,odeArgs{:});
            [dfdy,Joptions.fac,nF] = odenumjac(odeFcn, {t0,y0,odeArgs{:}}, f0, Joptions);
            nfevals = nfevals + nF + 1;
        else
            %     analytical jacobian
            dfdy= feval(Jac,t0,y0,Jargs{:});
        end
        npds = npds + 1;
        if (estim)
            delj00 = delj0;
        end
        nj00   = nj0;
        nodj00 = nodj0;
        if ((smallm)&&(Mtype==0))
            nj0 = 0;
            for i=1:neq
                delt = 0d0;
                for j=1:neq
                    delt = delt +abs(dfdy(i,j));
                end
                nj0 = max(nj0,delt);
            end
            nj0 = nj0/neq;
        end
    end
    %-------------------------------------------------------------------------------------------------------------------
    %     compute and factorize the iteration matrix theta
    rathh = h/hfatt;
    calfact=((kold~=k)||(~success)||caljac ||...
        (neq<2*k)||(Mtype~=0)||...
        (qinf&&(abs(rathh-1)>fatdj0i))...
        || ((~qinf)&&...
        ((rathh>deltah2)||(rathh<deltah1sf)))...
        || calfact0...
        ||((rho>5e-2)&&(it>=4)) );
    if (~(calfact||qinf))
        calfact = qinff||(rhofatt>=1);
        if (~(calfact||(rathh>=1)||(it==1)))
            rhonew = rho * h/h0;
            itnew = it*log(rho)/log(rhonew);
            alfafatt = neq/(6*k*itnew) + 1;
            cfat3 = rhot/(gamma*rhofatt)*(deltah1sf*rhofatt)^(1/alfafatt);
            cfat3 = cfat2-cfat3*cfat3;
            discr = cfat1*cfat1 - cfat3;
            if (discr >= 0)
                deltah1 = -(cfat1 + sqrt(discr));
            else
                deltah1 = 1;
            end
            calfact=(rathh<deltah1);
        end
    end

    if (calfact)
        nsing = 0;
        info = 1;
        while (((info~=0)&&(nsing<=5)))
            hgamma = h*gamma;
            if (Mtype~=0)
                theta = M-hgamma*dfdy;
            else
                if issparse(dfdy)
                    theta = speye(neq)-hgamma*dfdy;
                else
                    theta = eye(neq)-hgamma*dfdy;
                end
            end
            if issparse(theta)
                [L,U,P,Q] = lu(theta);
            else
                [L,U,P] = lu(theta);
                Q = [];
            end
            info = 0;
            if(min(abs(diag(U))) == 0)
                info = 1;
            end
            ndecomps = ndecomps + 1;
            if (info~=0)
                nsing = nsing + 1;
                if (nsing>5)
                    warning('MATLAB:odebim:MatrixRepeatedlySingular',...
                        'Matrix is repeatedly singular ');
                    nfailed = sum(nstep)-sum(naccept);
                    nsteps  = sum(naccept);
                    solver_output = odefinalize(solver_name, sol,...
                        outputFcn, outputArgs,...
                        printstats, [nsteps, nfailed, nfevals,...
                        npds, ndecomps, nsolves],...
                        nout, tout, yout,...
                        haveEventFcn, teout, yeout, ieout,...
                        {idxNonNegative});
                    if nargout > 0
                        varargout = solver_output;
                    end
                    return;
                else
                    h = h*0.5;
                    if (.1d0*abs(h) <= abs(t0)*uround)
                        warning('MATLAB:odebim:IntegrationTolNotMet',['Failure at t=%e.  ' ...
                            'Unable to meet integration tolerances without reducing ' ...
                            'the step size to h=%e' ...
                            'at time t.'],t0,h);
                        nfailed = sum(nstep)-sum(naccept);
                        nsteps  = sum(naccept);
                        solver_output = odefinalize(solver_name, sol,...
                            outputFcn, outputArgs,...
                            printstats, [nsteps, nfailed, nfevals,...
                            npds, ndecomps, nsolves],...
                            nout, tout, yout,...
                            haveEventFcn, teout, yeout, ieout,...
                            {idxNonNegative});
                        if nargout > 0
                            varargout = solver_output;
                        end
                        return;
                    end
                    continue;
                end
            else
                break;
            end
        end
    end

    caljac0 = false;
    calfact0 = false;
    %-------------------------------------------------------------------------------------------------------------------
    %     scaling
    if (length(atol) == 1)
        for i =1:index1
            scal(i) = 1/(atol+rtol*abs(y0(i)));
        end
        cscal0 = min(1,rtol/(uround*1e2*cscal));
        for i =index1+1:index1+index2
            scal(i) = min(1,cscal0*h)/(atol+rtol*abs(y0(i)));
        end
        cscal0 = min(1,rtol/(uround*1e2*cscal*cscal));
        for i =index1+index2+1:neq
            scal(i) = min(1,cscal0*h*h)/(atol+rtol*abs(y0(i)));
        end
    else
        for i =1:index1
            scal(i) = 1/(atol(i)+rtol*abs(y0(i)));
        end
        cscal0 = min(1,rtol/(uround*1e2*cscal));
        for i =index1+1:index1+index2
            scal(i) = min(1,cscal0*h)/(atol(i)+rtol*abs(y0(i)));
        end
        cscal0 = min(1,rtol/(uround*1e2*cscal*cscal));
        for i =index1+index2+1:neq
            scal(i) = min(1,cscal0*h*h)/(atol(i)+rtol*abs(y0(i)));
        end
    end

    for i=1:k
        t(i)=t0+i*h;
    end
    %-------------------------------------------------------------------------------------------------------------------
    %     stopping criterion when the solution has small entries
    if (success)
        if (length(atol) == 1)
            if (Mtype == 0)
                miny0  = abs(y0(1));
                fminy0 = abs(f0(1))*scal(1)*atol(1);
                maxf0  = fminy0;
                for i = 2:neq
                    if (abs(y0(i)) < miny0)
                        miny0 = abs(y0(i));
                        fminy0 = abs(f0(i))*scal(i)*atol(1);
                    end
                    maxf0 = max(maxf0,abs(f0(i))*scal(i)*atol(1));
                end
            else
                miny0  = abs(y0(1));
                fminy0 = abs(y0(1)-y(1,k0-1))/h0*scal(1)*atol(1);
                maxf0  = fminy0;
                for i = 2:index1
                    facnewt = abs(y0(i)-y(i,k0-1))/h0*scal(i)*atol(1);
                    if (abs(y0(i)) < miny0)
                        miny0 = abs(y0(i));
                        fminy0 = facnewt;
                    end
                    maxf0 = max(maxf0,facnewt);
                end
            end
        else
            if (Mtype == 0)
                miny0  = abs(y0(1));
                fminy0 = abs(f0(1))*scal(1)*atol(1);
                maxf0  = fminy0;
                for i = 2:neq
                    if (abs(y0(i)) < miny0)
                        miny0 = abs(y0(i));
                        fminy0 = abs(f0(i))*scal(i)*atol(i);
                    end
                    maxf0 = max(maxf0,abs(f0(i))*scal(i)*atol(i));
                end
            else
                miny0  = abs(y0(1));
                fminy0 = abs(y0(1)-y(1,k0-1))/h0*scal(1)*atol(1);
                maxf0  = fminy0;
                for i = 2:index1
                    facnewt = abs(y0(i)-y(i,k0-1))/h0*scal(i)*atol(i);
                    if (abs(y0(i)) < miny0)
                        miny0 = abs(y0(i));
                        fminy0 = facnewt;
                    end
                    maxf0 = max(maxf0,facnewt);
                end
            end
        end
    end


    facnewt = facnewtv(ord_ind);
    if (((miny0 < tolminy0)&&(fminy0<1e-1)))
        facnewt = min(1e-1,facnewt);
        if ((fminy0<1e-5)&&(maxf0<1e-2))
            facnewt=min(facnewt,facnsmall);
        end
    end
    if(restrict)
        facnewt=min(facnewt,facnrestr);
    end
    %-------------------------------------------------------------------------------------------------------------------
    %     solution initialization
    if ( (~extrap)||(nfailconv>flmx) )
        %     the solution is initialized with the constant profile
        if (nfailconv>flhlt)
            warning('MATLAB:odebim:ConsecutiveNewtonFailures',['Failure at t=%e.  ' ...
                'Too many consecutive newton failures'],t0);
            nfailed = sum(nstep)-sum(naccept);
            nsteps  = sum(naccept);
            solver_output = odefinalize(solver_name, sol,...
                outputFcn, outputArgs,...
                printstats, [nsteps, nfailed, nfevals,...
                npds, ndecomps, nsolves],...
                nout, tout, yout,...
                haveEventFcn, teout, yeout, ieout,...
                {idxNonNegative});
            if nargout > 0
                varargout = solver_output;
            end
            return;
        end
        for j = 1:k
            for i=1:neq
                y(i,j)=y0(i);
            end
        end
    else
        y(1:neq,1:k) = extrapola(neq,k0,k,h0,h,dd);
    end
    %-------------------------------------------------------------------------------------------------------------------
    %     newton iteration
    it       = 0;
    rho      = 0d0;
    nerr0    = 1d0;
    nerrstop  = max(facnewt,uround/rtol);

    jvai = true;
    while(jvai)
        for i=1:k
            f(:,i) = feval(odeFcn,t(i),y(:,i),odeArgs{:});
        end
        nfevals = nfevals + k;

        if (ord_ind==1)
%             [y(1:neq,1:3),err(1:neq,1:3)] = blendstep4(neq,y0,f0,y(1:neq,1:3),f(1:neq,1:3),h,gamma,Mtype,M,L,U,P,Q);
            if((Mtype+1)==1)
                err(:,1:k) = [y0 y(:,1:k)]*da4;
                err(:,1:k) = err(:,1:k)-h*([f0 f(:,1:k)]*db4);
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
                err(:,1:k) = err(:,1:k)+[y0 y(:,1:k)]*a24;
                err(:,1:k) = err(:,1:k)-h*(f0*b4+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            else
                err(:,1:k)=[y0 y(:,1:k)]*da4;
                mz = M*err(:,1:k);
                mz=mz-h*([f0 f(:,1:k)]*db4);
                mz(:,1:k) = sollu(L,U,P,Q,mz(:,1:k));
                mz=mz+([y0 y(:,1:k)]*a24);
                err(:,1:k) = M*mz;
                err(:,1:k)=err(:,1:k)-h*(f0*b4+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            end
            y(:,1:k) = y(:,1:k)-err(:,1:k);
        elseif(ord_ind==2)
%             [y(1:neq,1:4),err(1:neq,1:4)] = blendstep6(neq,y0,f0,y(1:neq,1:4),f(1:neq,1:4),h,gamma,Mtype,M,L,U,P,Q);
            if((Mtype+1)==1)
                err(:,1:k) = [y0 y(:,1:k)]*da6;
                err(:,1:k)=err(:,1:k)-h*([f0 f(:,1:k)]*db6);
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
                err(:,1:k)=err(:,1:k)+[y0 y(:,1:k)]*a26;
                err(:,1:k)=err(:,1:k)-h*(f0*b6+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            else
                err(:,1:k)=[y0 y(:,1:k)]*da6;
                mz = M*err(:,1:k);
                mz=mz-h*([f0 f(:,1:k)]*db6);
                mz(:,1:k) = sollu(L,U,P,Q,mz(:,1:k));
                mz=mz+([y0 y(:,1:k)]*a26);
                err(:,1:k) = M*mz;
                err(:,1:k)=err(:,1:k)-h*(f0*b6+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            end
            y(:,1:k) = y(:,1:k)-err(:,1:k);
        elseif(ord_ind==3)
%             [y(1:neq,1:6),err(1:neq,1:6)] = blendstep8(neq,y0,f0,y(1:neq,1:6),f(1:neq,1:6),h,gamma,Mtype,M,L,U,P,Q);
            if((Mtype+1)==1)
                err(:,1:k) = [y0 y(:,1:k)]*da8;
                err(:,1:k)=err(:,1:k)-h*([f0 f(:,1:k)]*db8);
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
                err(:,1:k)=err(:,1:k)+[y0 y(:,1:k)]*a28;
                err(:,1:k)=err(:,1:k)-h*(f0*b8+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            else
                err(:,1:k)=[y0 y(:,1:k)]*da8;
                mz = M*err(:,1:k);
                mz=mz-h*([f0 f(:,1:k)]*db8);
                mz(:,1:k) = sollu(L,U,P,Q,mz(:,1:k));
                mz=mz+([y0 y(:,1:k)]*a28);
                err(:,1:k) = M*mz;
                err(:,1:k)=err(:,1:k)-h*(f0*b8+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            end
            y(:,1:k) = y(:,1:k)-err(:,1:k);
        elseif(ord_ind==4)
%             [y(1:neq,1:8),err(1:neq,1:8)] = blendstep10(neq,y0,f0,y(1:neq,1:8),f(1:neq,1:8),h,gamma,Mtype,M,L,U,P,Q);
            if((Mtype+1)==1)
                err(:,1:k) = [y0 y(:,1:k)]*da10;
                err(:,1:k)=err(:,1:k)-h*([f0 f(:,1:k)]*db10);
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
                err(:,1:k)=err(:,1:k)+[y0 y(:,1:k)]*a210;
                err(:,1:k)=err(:,1:k)-h*(f0*b10+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            else
                err(:,1:k)=[y0 y(:,1:k)]*da10;
                mz = M*err(:,1:k);
                mz=mz-h*([f0 f(:,1:k)]*db10);
                mz(:,1:k) = sollu(L,U,P,Q,mz(:,1:k));
                mz=mz+([y0 y(:,1:k)]*a210);
                err(:,1:k) = M*mz;
                err(:,1:k)=err(:,1:k)-h*(f0*b10+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            end
            y(:,1:k) = y(:,1:k)-err(:,1:k);
        elseif(ord_ind==5)
%             [y(1:neq,1:10),err(1:neq,1:10)] = blendstep12(neq,y0,f0,y(1:neq,1:10),f(1:neq,1:10),h,gamma,Mtype,M,L,U,P,Q);
            if((Mtype+1)==1)
                err(:,1:k) = [y0 y(:,1:k)]*da12;
                err(:,1:k)=err(:,1:k)-h*([f0 f(:,1:k)]*db12);
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
                err(:,1:k)=err(:,1:k)+[y0 y(:,1:k)]*a212;
                err(:,1:k)=err(:,1:k)-h*(f0*b12+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            else
                err(:,1:k)=[y0 y(:,1:k)]*da12;
                mz = M*err(:,1:k);
                mz=mz-h*([f0 f(:,1:k)]*db12);
                mz(:,1:k) = sollu(L,U,P,Q,mz(:,1:k));
                mz=mz+([y0 y(:,1:k)]*a212);
                err(:,1:k) = M*mz;
                err(:,1:k)=err(:,1:k)-h*(f0*b12+gamma*f(:,1:k));
                err(:,1:k) = sollu(L,U,P,Q,err(:,1:k));
            end
            y(:,1:k) = y(:,1:k)-err(:,1:k);
        end
        it = it + 1;
        [nerr,nerrup] = norm1(neq,k,scal,err(1:neq,1:k));

        if (isnan(nerr)|| isnan(nerrup))
            nerr = 2d0*nerrstop + 1d0;
            extrap0 = false;
            extraps = false;
            break;
        end
        %  spectral radius estimate
        nerrold = nerr0;
        nerr0   = nerr;
        rho0    = rho;
        rho     = nerr0/nerrold;
        if (it > 2)
            rho = sqrt(rho0*rho);
        end

        jvai = (nerr > nerrstop) && (it <= maxit) && (it <= indexd+1 || rho <= rhobad);
        jvai = jvai ||(Mtype~= 0 && it < minit);
    end
    % end of newton's iteration
    %-------------------------------------------------------------------------------------------------------------------
    nsolves  = nsolves  + 2*it*k;
    niter(ord_ind) = niter(ord_ind) + it;
    nstep(ord_ind) = nstep(ord_ind) + 1;

    if (~(nerr>nerrstop))
        for i=1:k
            f(:,i) = feval(odeFcn,t(i),y(:,i),odeArgs{:});
        end
        nfevals = nfevals + k;
    end

    addbool1 =true;
    while (addbool1)
        addbool3 = (nerr > nerrstop) ;
        if (nerr > nerrstop)
            %     newton has failed
            nfailnewt(ord_ind) = nfailnewt(ord_ind) + 1;
            nfailconv  = nfailconv  + 1;
            nfailcons  = max(nfailcons + 1,2);
            nferrcons  = 0;
            h       = facnocon * h;
            kold    = k;
            if (ord > ordmin)
                ord     = ord - 2;
                ord_ind = ord/2 - 1;
                k       = step_ord(ord_ind);
            end

            success  = false;
            last     = false;

            caljac   = ~truejac;
            truejac  = true;

            if (nfailconv == 1)
                extraps = extrap0 && (it > maxit) && (rho < rhobad);
            end
            extrap   = extraps;
            restrict = false;

            minit = 1;
            break;
        end

        minit = indexd;
        %-------------------------------------------------------------------------------------------------------------------
        %     local error estimation
        nerrloc0 = nerrloc;
        if (ord_ind==1)
            [err(1:neq,1:3),nerr,nerrup,nsolves] = ...
                localerr4(neq,f0,f,h,scal,nsolves,vmax(1:3),Mtype,M,k,ord_ind,index1,index2,L,U,P,Q);
        elseif(ord_ind~=1)
            [err(1:neq,1:4),nerr,nerrup,nsolves] = ...
                localerr(neq,f0,f,h,scal,nsolves,vmax(1:3),Mtype,M,k,ord_ind,index1,index2,L,U,P,Q);
        end
        addbool1 = (isnan(nerr)||isnan(nerrup)) ;
        if (isnan(nerr)||isnan(nerrup))
            nerr = 2d0*nerrstop + 1d0;
            extrap0 = false;
            extraps = false;
            continue;
        end
    end
    if (addbool3)
        addbool3 = false;
        nsteps=nsteps+1;
        addbool2=(.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround);
        if (.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround)
            if (.1d0*abs(h) <= abs(t0)*uround)
                warning('MATLAB:odebim:IntegrationTolNotMet',['Failure at t=%e.  ' ...
                    'Unable to meet integration tolerances without reducing ' ...
                    'the step size to h=%e' ...
                    'at time t.'],t0,h);
                nfailed = sum(nstep)-sum(naccept);
                nsteps  = sum(naccept);
                solver_output = odefinalize(solver_name, sol,...
                    outputFcn, outputArgs,...
                    printstats, [nsteps, nfailed, nfevals,...
                    npds, ndecomps, nsolves],...
                    nout, tout, yout,...
                    haveEventFcn, teout, yeout, ieout,...
                    {idxNonNegative});
                if nargout > 0
                    varargout = solver_output;
                end
                return;
            end
            if (nsteps >= maxstep)
                warning('MATLAB:odebim:MaxstepOver',['Failure at t=%e.  ' ...
                    'More than %maxstep steps are needed'],t0,maxstep);
                nfailed = sum(nstep)-sum(naccept);
                nsteps  = sum(naccept);
                solver_output = odefinalize(solver_name, sol,...
                    outputFcn, outputArgs,...
                    printstats, [nsteps, nfailed, nfevals,...
                    npds, ndecomps, nsolves],...
                    nout, tout, yout,...
                    haveEventFcn, teout, yeout, ieout,...
                    {idxNonNegative});
                if nargout > 0
                    varargout = solver_output;
                end
                return;
            end
            tnext = t0 + (k)*h;
            if ( (Mtype~=0) && (tnext<tfinal) &&((tfinal-tnext)<((k)*h)) )
                h = (tfinal-t0)/(2d0*(k));
            end
            if (tnext >= tfinal)
                h = (tfinal-t0)/(k);
                last = true;
            end
            continue;
        end
        return;
    end

    nfailconv = 0;
    nerrloc = nerr;

    if ((Mtype~=0)&&(nferrcons>3)&&(abs(nerrloc - nerrloc0)<1e-4)&& (nerr>=1))
        nerr = .9d0;
    end

    if (nerr > 0d0)
        hnew = h*(sfty/nerr)^esp1;
    else
        hnew = facr*h;
    end

    if (nerr >= 1.0)
        %     failure due to local error test
        hnew = h*(1d-1/nerr)^esp1;
        nfailerr(ord_ind) = nfailerr(ord_ind) + 1;
        nfailcons = max(nfailcons + 1,2);
        nferrcons = nferrcons + 1;
        caljac   = ~ truejac;
        truejac  = true;
        success  = false;
        last     = false;
        kold     = k;
        if (errorbb &&(ord>ordmin))
            ord = ord - 2;
            ord_ind = (ord/2) -1;
            k = step_ord(ord_ind);
            h = max(hnew/2d0,facl*h);
        else
            h = max(hnew,facl*h);
        end
        errorbb = true;
        nsteps=nsteps+1;
        addbool2=(.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround);
        if (.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround)
            if (.1d0*abs(h) <= abs(t0)*uround)
                warning('MATLAB:odebim:IntegrationTolNotMet',['Failure at t=%e.  ' ...
                    'Unable to meet integration tolerances without reducing ' ...
                    'the step size to h=%e' ...
                    'at time t.'],t0,h);
                nfailed = sum(nstep)-sum(naccept);
                nsteps  = sum(naccept);
                solver_output = odefinalize(solver_name, sol,...
                    outputFcn, outputArgs,...
                    printstats, [nsteps, nfailed, nfevals,...
                    npds, ndecomps, nsolves],...
                    nout, tout, yout,...
                    haveEventFcn, teout, yeout, ieout,...
                    {idxNonNegative});
                if nargout > 0
                    varargout = solver_output;
                end
                return;
            end
            if (nsteps >= maxstep)
                warning('MATLAB:odebim:MaxstepOver',['Failure at t=%e.  ' ...
                    'More than %maxstep steps are needed'],t0,maxstep);
                nfailed = sum(nstep)-sum(naccept);
                nsteps  = sum(naccept);
                solver_output = odefinalize(solver_name, sol,...
                    outputFcn, outputArgs,...
                    printstats, [nsteps, nfailed, nfevals,...
                    npds, ndecomps, nsolves],...
                    nout, tout, yout,...
                    haveEventFcn, teout, yeout, ieout,...
                    {idxNonNegative});
                if nargout > 0
                    varargout = solver_output;
                end
                return;
            end

            tnext = t0 + k*h;
            if ( (Mtype~=0) && (tnext<tfinal) &&((tfinal-tnext)<((k)*h)) )
                h = (tfinal-t0)/(2*k);
            end

            if(tnext >= tfinal)
                h = (tfinal-t0)/k;
                last = true;
            end
            continue;
        end
        return;
    end
    %     step accepted
    naccept(ord_ind) = naccept(ord_ind) + 1;
    nferrcons = 0;

    success   = true;
    nord      =  nord + 1;
    nfailcons = max(nfailcons-1,0);

    extrap0 = false;
    for i=1:index1
        maxdelta = abs(y(i,k)-y0(i))*scalextrap(i);
        extrap0 = extrap0 ||((abs(y0(i))<=1d-1)&&(maxdelta>=tolestrapa(i)))...
            ||((abs(y0(i))>1d-1)&&(maxdelta>=tolestrapr));
    end
    restrict = ~extrap0;
    for i=index1+1:neq
        maxdelta = abs(y(i,k)-y0(i))*scalextrap(i);
        extrap0 = extrap0 ||((abs(y0(i))<=1d-1)&&(maxdelta>=tolestrapa(i)))...
            ||((abs(y0(i))>1d-1)&&(maxdelta>=tolestrapr));
    end
    extrap   =  extrap0;

    if (extrap||output_sol||output_ty || haveOutputFcn||haveEventFcn)
        dd(1:k+1,1:neq) = diffdiv(neq,k,y0,y);
    end
    tstepend = t(k);
    if haveEventFcn
        kEvent = k;
        [te,ye,ie,valt,stop] = odezero(@ntrpbim,eventFcn,eventArgs,valt,...
            t0,y0,t(kEvent),y(:,kEvent),oldt0,h,dd,k,idxNonNegative);
        if ~isempty(te)
            if output_sol || (nargout > 2)
                teout = [teout, te];
                yeout = [yeout, ye];
                ieout = [ieout, ie];
            end
            if stop               % Stop on a terminal event.
                % Adjust the interpolation data to [t te(end)].
                taux = te(end) - (0:k)*(te(end) - t(k));
                yaux = ntrpbim(taux,t0,y0,t(k),y(:,1:k),h,dd,k,idxNonNegative);
                for j=2:k+1
                    yaux(:,j:k+1) = yaux(:,j-1:k) - yaux(:,j:k+1);
                end

                t(1:k) = (t0 + (te(end)-t0)*(1:k)./k)';
                y(:,1:k) = ntrpbim(t(1:k),t0,y0,tstepend,y,h,dd,k,idxNonNegative);
                last =true;
            end
        end
    end

    if output_sol
        nout = nout + 1;
        if nout > length(tout)
            tout = [tout, zeros(1,chunk)];  % requires chunk >= refine
            yout = [yout, zeros(neq,chunk)];
            kvec = [kvec, zeros(1,chunk)];
        end
        tout(nout) = t(k);
        yout(:,nout) = y(:,k);
        kvec(nout) = k;
    end

    if output_ty || haveOutputFcn
        switch outputAt
            case 'SolverSteps'        % computed points, no refinement
                nout_new = 1;
                tout_new = t(k);
                yout_new = y(:,k);
            case 'RefinedSteps'       % computed points, with refinement
                tref = t0 + (t(k)-t0)*S;
                nout_new = refine;
                tout_new = [tref, t(k)];
                yout_new = [ntrpbim(tref,t0,y0,tstepend,y,h,dd,k,idxNonNegative), y(:,k)];
            case 'RequestedPoints'    % output only at tspan points
                nout_new =  0;
                tout_new = [];
                yout_new = [];
                while next <= ntspan
                    if tdir * (t(k) - tspan(next)) < 0
                        if haveEventFcn && stop     % output tstop,ystop
                            nout_new = nout_new + 1;
                            tout_new = [tout_new, t(k)];
                            yout_new = [yout_new, y(:,k)];
                        end
                        break;
                    end
                    nout_new = nout_new + 1;
                    tout_new = [tout_new, tspan(next)];
                    if tspan(next) == t(k)
                        yout_new = [yout_new, y(:,k)];
                    else
                        yout_new = [yout_new, ntrpbim(tspan(next),t0,y0,t(k),y,h,dd,k,...
                            idxNonNegative)];
                    end
                    next = next + 1;
                end
        end

        if nout_new > 0
            if output_ty
                oldnout = nout;
                nout = nout + nout_new;
                if nout > length(tout)
                    tout = [tout, zeros(1,chunk)];  % requires chunk >= refine
                    yout = [yout, zeros(neq,chunk)];
                end
                idx = oldnout+1:nout;
                tout(idx) = tout_new;
                yout(:,idx) = yout_new;
            end
            if haveOutputFcn
                stop = feval(outputFcn,tout_new,yout_new(outputs,:),'',outputArgs{:});
                if stop
                    last = true;
                end
            end
        end
    end

    if (last)
        break;
    end

    %     order variation
    rath   = hnew/h;
    if (it < 2)
        rho=1d-3;
    end
    ratrho = rhoold/rho;
    knew   = k;
    ordnew = ord;
    qinf   = (nerrup>=nerr)&&(nerr~=0d0);
    if (truejac)
        hj0=h;
        rhoj0 = rho;
        if (it<=1)
            rhoj0=1d0;
        end
        qinfj = qinf;
    end
    if (calfact)
        hfatt=h;
        rhofatt = rho;
        if (it<=1)
            rhofatt=1d0;
        end
        qinff   = qinf;
    end

    if ((errorbb)&&(ord>ordmin))
        nerror = min(nerror+1,2);
        if (nerror>1)
            ordnew = ord -2;
            ord_ind = ord_ind - 1;
            knew = step_ord(ord_ind);
            hnew = min(h,hnew)/2d0;
            caljac = true;
            truejac = true;
            for i=1:neq
                y0(i)  =y(i,k);
                absy0  =abs(y0(i));
                f0(i)  =f(i,k);
                scalextrap(i)=1d0/(1d0+absy0);
                if (ord<ordmax)
                    err(i,k+2)=err(i,k+1);
                    err(i,k+1)=err(i,1);
                end
            end

            t0  = t(k);
            k0  = k;
            kold = k;
            it0 = it;
            k    = knew;
            ord  = ordnew;
            h00 = h0;
            h0  = h;
            if (nfailcons>0)
                hnew = min(h,hnew);
            end
            hnew = max(hnew,facl*h);
            h    = min(min(hnew,facr*h),hmax);
            rhoold    = rho;

            nsteps=nsteps+1;
            addbool2=(.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround);
            if (.1d0*abs(t0-tfinal)/(k)>abs(t0)*uround)
                if (.1d0*abs(h) <= abs(t0)*uround)
                    warning('MATLAB:odebim:IntegrationTolNotMet',['Failure at t=%e.  ' ...
                        'Unable to meet integration tolerances without reducing ' ...
                        'the step size to h=%e' ...
                        'at time t.'],t0,h);
                    nfailed = sum(nstep)-sum(naccept);
                    nsteps  = sum(naccept);
                    solver_output = odefinalize(solver_name, sol,...
                        outputFcn, outputArgs,...
                        printstats, [nsteps, nfailed, nfevals,...
                        npds, ndecomps, nsolves],...
                        nout, tout, yout,...
                        haveEventFcn, teout, yeout, ieout,...
                        {idxNonNegative});
                    if nargout > 0
                        varargout = solver_output;
                    end
                    return;
                end
                if (nsteps >= maxstep)
                    warning('MATLAB:odebim:MaxstepOver',['Failure at t=%e.  ' ...
                        'More than %maxstep steps are needed'],t0,maxstep);
                    nfailed = sum(nstep)-sum(naccept);
                    nsteps  = sum(naccept);
                    solver_output = odefinalize(solver_name, sol,...
                        outputFcn, outputArgs,...
                        printstats, [nsteps, nfailed, nfevals,...
                        npds, ndecomps, nsolves],...
                        nout, tout, yout,...
                        haveEventFcn, teout, yeout, ieout,...
                        {idxNonNegative});
                    if nargout > 0
                        varargout = solver_output;
                    end
                    return;
                end
                tnext = t0 + (k)*h;
                if ( (Mtype~=0) && (tnext<tfinal) &&((tfinal-tnext)<((k)*h)) )
                    h = (tfinal-t0)/(2d0*(k));
                end
                if (tnext >= tfinal)
                    h = (tfinal-t0)/(k);
                    last = true;
                end
                continue;
            end
            return;
        end
    else
        nerror = 0;
    end


    errorbb = false;
    addbool4 = true;
    while(addbool4)
        if (~( rho<=rhoml))
            %     spectral radius too large
            if ((ord==ordmin)||(it<=indexd+2))
                break;
            end
            [err(1:neq,2),nerrdown,nsolves] =...
                errdown(neq,f0,f,h,scal,nsolves,vmax(4:6),qinf,k,ord_ind,index1,index2,L,U,P,Q);

            if(nerrdown > 0d0)
                hndn = h*(sftydn/nerrdown)^espdn;
            else
                hndn = hnew;
            end

            if (qinf&&(indexd <= 1)&&(hndn<hnew))
                break;
            end
            if (~ qinf)
                hndn=min(hndn,hnew);
            end
            ordnew  = ord - 2;
            ord_ind = ord_ind - 1;
            knew    = step_ord(ord_ind);
            hnew=hndn;
            break
        end

        if ((nfailcons>0)||(ord>=ordmax)||(nord<3)||(rath>=facu1)||(rath<=facu2)||(t(k)+(k)*hnew>=tfinal))
            break;
        end
        if ((nerrup<1d1*uround)&&(~qinf)&&(it<3)&&(rho<1d1*uround)&&(Mtype==0))
            %     the problem is a quadrature
            [err(1:neq,1:k+2),nerrup] = errup...
                (neq,k,ord_ind,err(1:neq,1:k+2),h,h0,h00,vmax(7:8),scal,index1,index2,L,U,P,Q);
            nsolves = nsolves + 1;
            if (nerrup > 0d0)
                hnup = h*(sftyup/nerrup)^espup;
            else
                hnup = facr*h;
            end
            if (t(k)+(step_ord(ord_ind+1))*hnup>=tfinal)
                break;
            end
            nu   = (it);
            nuup = (it);
            kup=step_ord(ord_ind+1);
            fi    = (hnew/hnup)*((k)/(kup))*(csis*(2*kup*nuup+siserrup)+cfact)/(csis*(2*k*nu+siserr)+cfact);
            if (fi<1)
                ordnew  = ord + 2;
                ord_ind = ord_ind + 1;
                knew    = step_ord(ord_ind);
                hnew    = hnup;
            end
            break;
        end

        if(~(qinf))
            if (~(rho>=rhomu)&&(it> indexd))
                if (nerrup > 0d0)
                    hnup = h*(sftyup/nerrup)^espup;
                else
                    hnup = facr*h;
                end
                if (t(k)+(step_ord(ord_ind+1))*hnup>=tfinal)
                    %     &goto 500
                    %500   continue
                    break;
                end
                nu    = max(indexd,(it *log(rho))/log(rho*rath));
                nuup  = max(indexd,(it *log(rho))/log(rho*(rhotup/rhot)*(hnup/h)));
                kup=step_ord(ord_ind+1);
                fi    = (hnew/hnup)*((k)/(kup))*(csis*(2d0*kup*nuup+siserrup)+cfact)/(csis*(2d0*k*nu+siserr)+cfact);
                if (fi<1d0)
                    ordnew  = ord + 2;
                    ord_ind = ord_ind + 1;
                    knew    = step_ord(ord_ind);
                    hnew    = hnup;
                    %         goto 500
                    %500   continue
                    break;
                end
            elseif((rho>=rhomu)&&(it> indexd))
                if (~(Mtype~=0))
                    stagna=(abs(rath-1d0)<1d-1)&&(abs(ratrho-1d0)<1d-1);
                    if (~(~stagna||(t(k)==0d0)))
                        fj0 = feval(odeFcn,t(k)*(1+1e-5),y(:,k),odeArgs{:});
                        nfevals = nfevals + 1;
                        nf0= 0d0;
                        nf = 0d0;
                        for i=1:neq
                            nf0 = max(nf0,abs(fj0(i)-f(i,k)));
                            nf  = max(nf,abs(f(i,k)));
                        end
                        nf0 = nf0/(1d-5*t(k));
                        if (~(nj0*nf>=2d0*nf0))
                            if (nerrup > 0d0)
                                hnup = h*(sftyup/nerrup)^espup;
                            else
                                hnup = facr*h;
                            end
                            if (t(k)+(step_ord(ord_ind+1))*hnup>=tfinal)
                                %     &goto 500
                                %500   continue
                                break;
                            end
                            nu    = max(indexd,(it *log(rho))/log(rho*rath));
                            nuup  = max(indexd,(it *log(rho))/log(rho*(rhotup/rhot)*(hnup/h)));
                            kup   = step_ord(ord_ind+1);
                            fi    = (hnew/hnup)*(k/kup)*(csis*(2*kup*nuup+siserrup)+cfact)/(csis*(2*k*nu+siserr)+cfact);
                            if (fi<1d0)
                                ordnew  = ord + 2;
                                ord_ind = ord_ind + 1;
                                knew    = step_ord(ord_ind);
                                hnew    = hnup;
                                %         goto 500
                                %500   continue
                                break;
                            end
                        end
                    end
                end
            end
        end
        %450   continue
        % ---------------------------------------------------------------
        % order reduction recovery
        % ---------------------------------------------------------------
        stagna=(rath > rath1)&& (rath < rath2) ;
        if ((indexd<=1)||(it>indexd+1)||(it0>indexd+1))
            stagna = stagna &&(ratrho > ratrho1)&&(ratrho<ratrho2);
        end

        if ( qinf ||(stagna&& (faterr*nerrup >= nerr)))
            if ((h/h0>=facu1)||(h/h0<=facu2))
                % goto 500
                break;
            end
            if ( (ord_ind>1)&&((h0/h00>=facu1)||(h0/h00<=facu2)) )
                % goto 500
                break;
            end
            if ((~calfact||(~truejac&&~linear))&&qinf)
                % in this case, the spectral radius doesn't behaves like rho=rhoti/q.
                caljac0 = ~linear;
                calfact0 = true;
                % goto 500
                break;
            end

            if (~qinf)
                if (Mtype==0)
                    hnew = hnew *(vmax(1)/vmax(2))^esp1;
                else
                    for i=1:index1
                        err(i,2)=err(i,2)*vmax(2)/vmax(1);
                    end
                    [nerr,nerrold] = norm1(neq,1,scal,err(1:neq,2));
                    if (nerr>0)
                        hnew = h*(sfty/nerr)^esp1;
                    else
                        hnew = facr*h;
                    end
                end
                rath = hnew/h;
            end

            [err(1:neq,1:k+2),nerrup1] = ...
                errup(neq,k,ord_ind,err(1:neq,1:k+2),h,h0,h00,vmax(7:8),scal,index1,index2,L,U,P,Q);

            nsolves = nsolves + 1;
            if (nerrup1 > 0d0)
                hnup1 = h*(sftyup/nerrup1)^espup;
            else
                hnup1 = facr*h;
            end
            if (t(k)+(step_ord(ord_ind+1))*hnup1>=tfinal)
                break;
            end

            nu1    = max(((it)*log(rho))/log(rho/rath),indexd);
            nuup1  = max(((it)*log(rho))/log(rho*(h/hnup1)*(rhoiup/rhoi)),indexd);
            kup=step_ord(ord_ind+1);
            fi1    = (hnew/hnup1)*((k)/(kup))*(csis*(2d0*kup*nuup1+siserrup)+cfact)/(csis*(2d0*k*nu1+siserr)+cfact);

            if   (fi1 < 1d0)
                ordnew  = ord + 2;
                ord_ind = ord_ind + 1;
                knew    = step_ord(ord_ind);
                hnew    = hnup1;
            end
        end
        addbool4 = false;
    end
    for i=1:neq
        y0(i)  =y(i,k);
        absy0  =abs(y0(i));
        f0(i)  =f(i,k);
        scalextrap(i)=1d0/(1d0+absy0);
        if (ord<ordmax)
            err(i,k+2)=err(i,k+1);
            err(i,k+1)=err(i,1);
        end
    end

    t0  = t(k);
    k0  = k;
    kold = k;
    it0 = it;
    k    = knew;
    ord  = ordnew;

    h00 = h0;
    h0  = h;
    if (nfailcons>0)
        hnew = min(h,hnew);
    end
    hnew = max(hnew,facl*h);
    h    = min(min(hnew,facr*h),hmax);
    rhoold    = rho;
    
    nsteps=nsteps+1;
    addbool2=(0.1*abs(t0-tfinal)/k>abs(t0)*uround);
    if (0.1*abs(t0-tfinal)/k>abs(t0)*uround)
        if (0.1*abs(h) <= abs(t0)*uround)
            warning('MATLAB:odebim:IntegrationTolNotMet',['Failure at t=%e.  ' ...
                'Unable to meet integration tolerances without reducing ' ...
                'the step size to h=%e' ...
                'at time t.'],t0,h);
            nfailed = sum(nstep)-sum(naccept);
            nsteps  = sum(naccept);
            solver_output = odefinalize(solver_name, sol,...
                outputFcn, outputArgs,...
                printstats, [nsteps, nfailed, nfevals,...
                npds, ndecomps, nsolves],...
                nout, tout, yout,...
                haveEventFcn, teout, yeout, ieout,...
                {idxNonNegative});
            if nargout > 0
                varargout = solver_output;
            end
            return;
        end
        if (nsteps >= maxstep)
            warning('MATLAB:odebim:MaxstepOver',['Failure at t=%e.  ' ...
                'More than %maxstep steps are needed'],t0,maxstep);
            nfailed = sum(nstep)-sum(naccept);
            nsteps  = sum(naccept);
            solver_output = odefinalize(solver_name, sol,...
                outputFcn, outputArgs,...
                printstats, [nsteps, nfailed, nfevals,...
                npds, ndecomps, nsolves],...
                nout, tout, yout,...
                haveEventFcn, teout, yeout, ieout,...
                {idxNonNegative});
            if nargout > 0
                varargout = solver_output;
            end
            return;
        end

        tnext = t0 + k*h;
        if ( (Mtype~=0) && (tnext<tfinal) &&((tfinal-tnext)<((k)*h)) )
            h = (tfinal-t0)/(2*k);
        end

        if (tnext >= tfinal)
            h = (tfinal-t0)/k;
            last = true;
        end
    end
end
%     integration end

nfailed = sum(nstep)-sum(naccept);
nsteps  = sum(naccept);
solver_output = odefinalize(solver_name, sol,...
    outputFcn, outputArgs,...
    printstats, [nsteps, nfailed, nfevals,...
    npds, ndecomps, nsolves],...
    nout, tout, yout,...
    haveEventFcn, teout, yeout, ieout,...
    {idxNonNegative});
if nargout > 0
    varargout = solver_output;
end