function [XtBeta, EXITFLAG, OUTPUT] = cgnbisubproblem(FUN, Xt, payoffmx,Beta,  normal, SHADOWFVAL, A,B,Aeq,Beq,LB,UB,NONLCON, opts, varargin); 
%CGNBISUBPROBLEM NBI subproblem
%
%  solves max  t
%        x,t
%       
%  subject to:  payoffmatrix*Beta + t*normal = FUN(X)
%              A*X  <= B, Aeq*X  = Beq (linear constraints)
%              C(X) <= 0, Ceq(X) = 0   (nonlinear constraints)
%              LB <= X <= UB            

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:56:29 $

% Globals needed for the call to numjac in mbcOSnbi
global CGNBIG_OBJ CGNBIFAC_OBJ CGNBIG_CON CGNBIFAC_CON 

% A new variable has been added, need to augment the constraints
nvars = size(Xt,1)-1;
if ~isempty(A)
    At = [A zeros(size(A,1),1)];
    Bt = B;
else
    At = [];
    Bt = [];
end
if ~isempty(Aeq)
    Aeq_t = [Aeq zeros(size(A,1),1)];
    Beq_t = Beq;
else
    Aeq_t = [];
    Beq_t = [];
end

LB_t = [LB; -Inf];
UB_t = [UB; Inf];

% Clear the numjac working vectors before calling fmincon
CGNBIFAC_OBJ = [];
CGNBIFAC_CON=[];

[XtBeta, FtBeta, EXITFLAG, OUTPUT] = fmincon(@i_max_tFUN,Xt,At,Bt, Aeq_t, Beq_t, LB_t, UB_t, @i_cons_tFUN, opts, payoffmx, Beta, normal, SHADOWFVAL,FUN, NONLCON,  ...
    varargin{:});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [g, ge,cg,ce] = i_cons_tFUN(x_t,payoffmx,Beta,normal,SHADOWFVAL,FUN, NONLCON, varargin)
% CONS_TFUN non-linear constraint function for NBI subproblem
% g - inequality constraints
% ge - equality constraints
% cg - constraint gradient inequality
% ce - constraint gradient equality 

nvars = length(x_t)-1;

t = x_t(nvars+1);
x = x_t(1:nvars);

if nargout<=2;
   if ~isempty(NONLCON)
      [gi, ge] = feval(NONLCON, x, [], varargin{:}); 
   else
      gi=[];   
      ge = [];
   end
   % NBI Constraint without gradient
   % evaluate each of the objectives
   funcs = feval(FUN, x, 1:length(SHADOWFVAL), varargin{:}); 
else
   if ~isempty(NONLCON)
      [gi,ge,gpci,gpce] = feval(NONLCON, x, [],varargin{:}); 
   else
      gi=[];ge=[];
      gpci=[];gpce=[];
   end

   % NBI Constraints and Gradient
   [funcs,ce]=  feval(FUN, x, 1:length(SHADOWFVAL),varargin{:}); 
   % The first equality constraint, C, keeps subproblem points on the normal 
   % Example for 3 objective functions, 2 free variables
   %     (C1)=(C1(x1, x2, n1*t))
   % C = (C2)=(C2(x1, x2, n2*t))
   %     (C3)=(C3(x1, x2, n2*t))
   ce= [ce  -normal(:)];
   if ~isempty(gpce)
       gpce = [gpce, zeros(size(gpce, 1), 1)];
       ce = [ce; gpce];
   end
   ce = ce';
    % Inequality Constraint Gradients
   cg= [ gpci; zeros(1,size(gpci,2))];
end

% Equality Constraints
% use the user-supplies equality constraints, supplemented by the NBI vector constraint
ge = [funcs-SHADOWFVAL-(payoffmx*Beta'+t*normal) ; ge];
% Inequality Constraints
g= gi;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f, g] = i_max_tFUN(x_t,payoffmx,Beta,normal,SHADOWFVAL,varargin)

% objective for NBI subproblem
% max(t) over x and t

f = -x_t(end);

if nargout>1
   % obj gradient
   g= zeros(1,length(x_t));
   g(end)= -1;
end
