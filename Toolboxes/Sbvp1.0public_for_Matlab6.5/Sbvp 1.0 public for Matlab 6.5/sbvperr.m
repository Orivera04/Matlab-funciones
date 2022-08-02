function err=sbvperr(bvpfile,t,y,bvpopt,varargin)
%   SBVPERR 1.0 (Rel. 1/2003) Estimate error of BVP-solution (private function of SBVP)
%
%   ERR = SBVPERR(BVPFILE,TCOL,YCOL[,BVPOPT,PARAM1,PARAM2,...]) estimates the
%   error of the solution approximation YCOL (given at the collocation grid TCOL)
%   of the boundary value problem defined in BVPFILE. The error is estimated
%   by the modified Zadunaisky method.
%
%   BVPFILE is the function handle of an m-file that defines the boundary value problem
%   
%   TCOL is the collocation grid. 
%
%   YCOL is the solution approximation of the BVP given at TCOL. YCOL should be a
%    (dim x length(TCOL))-matrix, where dim is the dimension of the system to be solved.
%
%   [BVPOPT should be the parameter struct that has been used to generate YCOL.
%    See BVPSET and SBVP. If no options are specified, SBVPERR tries to evaluate 
%    BVPFILE('bvpopt') to obtain them and uses the default options if this fails.]
%
%   [PARAM1,PARAM2 are parameters that are passed on to BVPFILE. See SBVP]
%
%   See also SBVP  SBVPCOL  SBVPSET

%   Copyright (c) 2003 Winfried Auzinger
%                      Guenter Kneisl
%                      Othmar Koch
%                      Ewa Weinmueller
%                      Vienna University of Technology



%################################################################################
%##################################### MAIN #####################################
%################################################################################

% ********** Arguments are not checked since the user is not supposed to access 
% ********** this function directly. 

parameters = varargin;

try
   bvpoptcheck = bvpopt.Private.Argcheck;
catch
   bvpoptcheck = 1;
end


if bvpoptcheck   
   defaultopt = sbvp('defaults');
   
   if nargin <= 3
      try
         bvpopt = sbvpset(defaultopt, feval(bvpfile,'bvpopt'));
         bvpopt.ZfOpt = optimset(defaultopt.ZfOpt,bvpopt.ZfOpt);
      catch
         fprintf(' BVPOPT unspecified or incorrect - Using default options\n');
         bvpopt = defaultopt;
      end
   else
      bvpopt.ZfOpt = optimset(defaultopt.ZfOpt,bvpopt.ZfOpt);
      bvpopt = sbvpset(defaultopt, bvpopt);
   end
   
   % ***** Define the default value for TolX, the zerofinder tolerance
   if isempty(bvpopt.ZfOpt.TolX)
      bvpopt.ZfOpt.TolX = 1e-12;
   end

   
   % ***** Determine whether boundary conditions and differential equation are linear
   try
      dRdya = feval(bvpfile,'dR/dya',{},{},{},{},parameters{:});
      dRdyb = feval(bvpfile,'dR/dyb',{},{},{},{},parameters{:});
   
      if isnumeric(dRdya) & isnumeric(dRdyb)
         bvpopt.Private.BClinear = 1;
      else
         bvpopt.Private.BClinear = 0;
      end   
   catch
      bvpopt.Private.BClinear = 0;
   end         

   if bvpopt.Private.BClinear % if BC are nonlinear, the whole problem is nonlinear
      try 
         J = feval(bvpfile,'df/dy',(t(1)+t(end))/2,{},{},{},parameters{:});
         if isnumeric(J)
            bvpopt.Private.IsLinear = 1;
         else
            bvpopt.Private.IsLinear = 0;
         end
      catch
         bvpopt.Private.IsLinear = 0;
      end
   else
      bvpopt.Private.IsLinear = 0;
   end  
   
   bvpopt.Private.Preconditioner = 1;
end   
   



% ********** Generate the globals
global N_ p_ d_

p_ = bvpopt.Degree;
N_ = (length(t)-1)/(p_+1);
d_ = size(y,1);            % dimension of y

% ********** Generate modified defect
[D,f,fprime] = generate_modified_defect(bvpfile,t,y,bvpopt,parameters);


%********************************************************************************
%**************************** ESTIMATE THE ERROR ********************************
%********************************************************************************


if bvpopt.Private.IsLinear
   
   % ********** evaluate the Jacobian  
   DF = eval_jac_lin(bvpfile,t,zeros(d_,N_*(p_+1)+1),bvpopt,parameters,fprime);
   
   % ********** due to linearity, the error can be directly calculated as DF\D   
   % ********** but the following is quicker
   
   lastwarn('');    % initialize warning state      
   
   [L,U] = lu(DF);
   err = reshape(U\(L\D), d_, N_*(p_+1)+1);
     
   % ********** check if everything was OK in the solution of the linear system
   if length(lastwarn)
      fprintf('\n');
      error(' System matrix is close to singular. Try a refined mesh.');
   end   
else
   % **********
   I = generate_const_part_of_Jacobian(t,y,bvpopt);
   
   if lower(bvpopt.ZfMethod(1)) == 'n'
      % ********** initialize Zerofinder Display
      if bvpopt.ZfOpt.Display(1)=='i'  % display information every iteration step
         fprintf('\n F-COUNT   NORM_F   NORM_DELTA_X   NORM_X   STEPSIZE \n');
      end
      
      % ***** evaluate residual, make use of the f-evaluation of the defect generation
      F = eval_res(bvpfile,t,y,bvpopt,parameters,[],f);
   
      % ***** solve the unmodified problem
      y = solve_nonlinear_bvp(bvpfile,t,y,bvpopt,parameters,F,[],I);
   
   
      % ***** evaluate corrected residual at solution approximation y obtained right before
      FD = eval_res(bvpfile,t,y,bvpopt,parameters,D,[]);
   
      % ***** Solve the modified BVP, start at y
      yD = solve_nonlinear_bvp(bvpfile,t,y,bvpopt,parameters,FD,D,I);    
      
   else % Method = Fsolve
      
      % ***** initialize the warning state
      lastwarn('');  
      
      % ***** Solve the unmodified problem
      [y,dummy,flag,logstruct] = ...
         fsolve(@eval_res_and_jac,y,bvpopt.ZfOpt,bvpfile,t,bvpopt,parameters,I,[]);
      
      % ***** intercept numerically singular Jacobians
      if length(findstr(lastwarn,'singular'))
         fprintf('\n');
         if bvpopt.Private.BClinear
            error(' System matrix is close to singular. Try a refined mesh.');
         else
            error(' System matrix is close to singular. Try a refined mesh or another initial approximation.');
         end              
      end    

      % ***** determine whether anything has gone wrong
      if logstruct.iterations >= bvpopt.ZfOpt.MaxIter
         fprintf('\n Maximum number of iterations exceeded.\n\n');
      elseif flag == 0
         fprintf('\n Maximum number of function evaluations exceeded.\n\n');
      else
         if lower(bvpopt.ZfOpt.Display(1)) ~= 'o' % off
            fprintf('\n Fsolve terminated successfully. \n\n');
         end         
      end         
      
      % ********** now the modified problem
      
      % ***** initialize the warning state
      lastwarn('');
      
      % ***** Solve the modified problem
      [yD,dummy,flag,logstruct] = ...
         fsolve(@eval_res_and_jac,y,bvpopt.ZfOpt,bvpfile,t,bvpopt,parameters,I,D);
      
      % ***** intercept numerically singular Jacobians
      if length(findstr(lastwarn,'singular'))
         fprintf('\n');
         if bvpopt.Private.BClinear
            error(' System matrix is close to singular. Try a refined mesh.');
         else
            error(' System matrix is close to singular. Try a refined mesh or another initial approximation.');
         end              
      end    
      
      % ***** determine whether anything has gone wrong
      if logstruct.iterations >= bvpopt.ZfOpt.MaxIter
         fprintf('\n Maximum number of iterations exceeded.\n\n');
      elseif flag == 0
         fprintf('\n Maximum number of function evaluations exceeded.\n\n');
      else
         if lower(bvpopt.ZfOpt.Display(1)) ~= 'o' % off
            fprintf('\n Fsolve terminated successfully. \n\n');
         end         
      end         
   end    
      
   % ********** estimate the error
   err = yD-y;
end






%################################################################################
%################################# SUBROUTINES ##################################
%################################################################################


%********************************************************************************
%****************************** GENERATE DEFECT *********************************
%********************************************************************************


function [D,f,fprime] = generate_modified_defect(bvpfile,t,y,bvpopt,parameters);
global N_ p_ d_ 

% ***** generate extended point distribution (rho = [0 rho_1 ... rho_p 1])
rho = [0 (t(2:p_+1)-t(1))/(t(p_+2)-t(1)) 1];

% ***** define some constants
ones_p = ones(1,p_+1);
rho_matrix = ones_p' * rho(2:end);
one_to_p1 = (1:p_+1)' * ones_p;
int_matrix = (rho_matrix .^ one_to_p1) ./ one_to_p1;

% ***** Assemble the system matrices
A = rho_matrix   .^   ((0:p_)' * ones_p); 
B = (ones_p' * (1./diff(rho)) )   .*  (int_matrix - [zeros(p_+1,1)  int_matrix(:,1:p_)]);

% ***** Solve the system for the quadrature coefficients
alpha = A\B;


% ***** evaluate f'
if isfield(bvpopt,'fprime')
   fprime = bvpopt.fprime;
   bvpopt.fprime = [];
else
   fprime = evaluate_fprime(bvpfile,t(2:end),y(:,2:end),bvpopt,parameters);
end   
   
% ***** for linear BVPs, f may be the inhomogenity only
if bvpopt.Private.IsLinear
   if isfield(bvpopt,'fprime')
      f = bvpopt.f;
      bvpopt.f = [];      
   else
      f = evaluate_f(bvpfile,t(2:end),zeros(d_,length(t)-1),bvpopt,parameters);
   end
      
   for l = 1:N_*(p_+1)
      f(:,l) = fprime(:,:,l) * y(:,l+1) + f(:,l);
   end
else
   f = evaluate_f(bvpfile,t(2:end),y(:,2:end),bvpopt,parameters);
end

% ***** reserve space, define indices
Alpha = zeros(d_,N_*(p_+1));

col_idx = reshape(1:(p_+1)*N_ , p_+1, N_);

% ***** Build matrix Alpha
for k=1:N_
   Alpha(:, col_idx(:,k)) = f(:, col_idx(:,k)) * alpha;
end

% ***** generate defect matrix
defect_matrix = (y(:,2:end) - y(:,1:end-1)) ./ (ones(d_,1) * diff(t)) - Alpha;

% ***** and save it in linearized form, the zeros at the beginning represent the BC
D = [zeros(d_,1) ; defect_matrix(:)];
   
   
%********************************************************************************
%********************************************************************************
%********************************************************************************

function I = generate_const_part_of_Jacobian(t,y,bvpopt)
% ********** assemble constant parts of Jacobian I

global N_ p_ d_

% ***** define some constants
dimF = N_*(p_+1)*d_ + d_;
IdId = [-speye(d_) speye(d_)];
h = diff(t);

% ***** reserve some space
I = sparse([],[],[],dimF,dimF,2*N_*(p_+1)*d_);

% ***** define indices for the loop
row_idx = reshape(d_+1:N_*(p_+1)*d_+d_ , d_, N_*(p_+1));

col_lo = 1:d_:N_*(p_+1)*d_;
col_hi = col_lo + (2*d_-1);

% ***** assemble matrix
for l=1:length(t)-1
   I(row_idx(:,l) , col_lo(l):col_hi(l)) = IdId / h(l);
end



%********************************************************************************
%***************************** SOLVE NONLINEAR BVP ******************************
%********************************************************************************

function new_y = solve_nonlinear_bvp(bvpfile,t,y,bvpopt,parameters,F,D,I);
global N_ p_ d_
                              
% ********** store some fields of bvpopt as variables for quick reference
xtol        = bvpopt.ZfOpt.TolX;
ftol        = bvpopt.ZfOpt.TolFun;
max_F_evals = bvpopt.ZfOpt.MaxFunEvals;
max_iter    = bvpopt.ZfOpt.MaxIter;
display     = bvpopt.ZfOpt.Display(1);

% ********** some initializations
fcount = 1;   % number of function evaluations
itcount= 0;   % number of iterations
lambda = 1;   % initial stepsize, classical Newton


norm_x = max(abs(y(:)));                        % Inf-norm of x
norm_F = max(abs(F));                           % F comes in as an argument
   
DF = eval_jac(bvpfile,t,y,bvpopt,parameters,I); % Jacobian 

lastwarn('');                                   % initialize warning state 
   
[L,U]=lu(DF);                                   % LU-decomposition of DF
delta_x = U\(L\(- F));                          % Newton correction for uncorrected IEul

if length(lastwarn)
   fprintf('\n');
   if bvpopt.Private.BClinear
      error(' System matrix is close to singular. Try a refined mesh.');
   else
      error(' System matrix is close to singular. Try a refined mesh or another initial approximation.');
   end              
end    


norm_delta_x = max(abs(delta_x));               % and its norm 

new_y = reshape( y(:) + delta_x , d_, N_*(p_+1) +1);     % new approximation

% ********** start damped newton iteration

% ***** iteration loop
while 1    
   
   % ***** termination conditions
   if norm_x == 0 
      terminate = (norm_F < ftol) | (norm_delta_x < xtol);
   else
      terminate = (norm_F < ftol) | (norm_delta_x / norm_x < xtol);
   end
      
   if terminate
      % ***** display statistics
      if display=='i' % 'iter', display information every iteration step
         fprintf('   %i     %.2e     %.2e     %.2e    %1.3f\n',...
                  fcount,norm_F,norm_delta_x,norm_x,lambda);
      end
      
      if display(1)~='o'  % off
         fprintf(' Newton zerofinder terminated successfully \n\n');
      end
      break;
   elseif fcount > max_F_evals    % max. number of function evaluations exceeded
      fprintf('\n Maximum number of function evaluations exceeded \n\n');
      break;
   elseif itcount > max_iter      % max. number of iterations exceeded   
      fprintf('\n Maximum number of iterations exceeded \n\n');
      break;
   end                            % else continue below with next Newton step
            
   while fcount <= max_F_evals
      
      new_F = eval_res(bvpfile,t,new_y,bvpopt,parameters,D,[]);% new residual
      fcount = fcount +1;                          % increase number of function evaluations
      
      simplified_delta_x = U\(L\(-new_F));         % simplified delta_x
               
      if max(abs(simplified_delta_x)) <= (1-lambda/2) * norm_delta_x   % test monotonicity
         break;               % monotonicity condition satisfied, accept correction
      else
         lambda = lambda/2;   % try smaller stepsize
         new_y(:) = y(:) + lambda * delta_x;       % new approximation            
      end
   end
   
   % ***** display statistics
   if display=='i' % 'iter', display information every iteration step
      fprintf('   %i     %.2e     %.2e     %.2e    %1.3f\n',...
               fcount-1,norm_F,norm_delta_x,norm_x,lambda);
   end
      
   lambda = min([2*lambda 1]);    % start next step with doubled stepsize
   itcount = itcount +1;          % increase number of iterations         
      
   y = new_y;                     % new solution approximation   
   norm_x = max(abs(y(:)));       % Inf-norm of x
   
   F = new_F;                     % new residual
   norm_F = max(abs(F));
   
   DF = eval_jac(bvpfile,t,y,bvpopt,parameters,I); % new Jacobian 
  
   lastwarn('');                                   % initialize warning state 
   
   [L,U]=lu(DF);                                   % LU-decomposition of DF
   delta_x = U\(L\(- F));                          % Newton correction

   if length(lastwarn)
      fprintf('\n');
      if bvpopt.Private.BClinear
         error(' System matrix is close to singular. Try a refined mesh.');
      else
         error(' System matrix is close to singular. Try a refined mesh or another initial approximation.');
      end              
   end    
   
   norm_delta_x = max(abs(delta_x));               % and its norm 
   
   new_y(:) = y(:) + lambda * delta_x;             % new approximation
end


%********************************************************************************
%*********************** EVALUATE DISCRETIZATION RESIDUAL ***********************
%********************************************************************************

function F = eval_res(bvpfile,t,y,bvpopt,parameters,D,f)
global N_ p_ d_ 

h = diff(t);

% ********** evaluate f(t,y) along the mesh if f is not given as argument
if ~length(f)
   f = evaluate_f(bvpfile,t(2:end),y(:,2:end),bvpopt,parameters);
end

% ********** evaluate implicit Euler residual
F_matrix = (y(:,2:end) - y(:,1:end-1)) ./ (ones(d_,1) * h) - f;

% ********** evaluate boundary conditions, bring all into final form
if bvpopt.Private.Preconditioner
   F = [ 1/h(1) * feval(bvpfile, 'R', 0, 0, y(:,1), y(:,end), parameters{:}) ; F_matrix(:)];
else
   F = [feval(bvpfile, 'R', 0, 0, y(:,1), y(:,end), parameters{:}) ; F_matrix(:)];
end

% ********** add the defect D
if length(D)
   F = F - D; 
end




%********************************************************************************
%****************************** EVALUATE JACOBIAN *******************************
%********************************************************************************

function DF = eval_jac(bvpfile,t,y,bvpopt,parameters,I)
global N_ p_ d_

h1 = t(2) - t(1);

% ********** evaluate f'(t,y) along the mesh
fprime = evaluate_fprime(bvpfile,t(2:end),y(:,2:end),bvpopt,parameters);

dimF = N_*(p_+1)*d_ + d_;
J = spalloc(dimF,dimF,(N_*(p_+1)+2)*d_^2);


% ********** evaluate boundary terms
if bvpopt.Private.Preconditioner
   J(1:d_ , 1:d_) = - 1/h1 * feval(bvpfile, 'dR/dya', [], [], y(:,1), y(:,end), parameters{:});
   J(1:d_ , dimF-d_+1:dimF) = - 1/h1 * feval(bvpfile, 'dR/dyb', [], [], y(:,1), y(:,end), parameters{:});
else
   J(1:d_ , 1:d_) = - feval(bvpfile, 'dR/dya', [], [], y(:,1), y(:,end), parameters{:});
   J(1:d_ , dimF-d_+1:dimF) = - feval(bvpfile, 'dR/dyb', [], [], y(:,1), y(:,end), parameters{:});
end

% ********** generate indices
Jidx = reshape(d_+1:N_*(p_+1)*d_+d_ , d_, N_*(p_+1));

% ********** assemble nonconstant part of the Jacobian
for l=1:N_*(p_+1)
   J(Jidx(:,l) , Jidx(:,l)) = fprime(:,:,l);
end

% ********** build Jacobian from constant and nonconstant part
DF = I - J ;


%********************************************************************************
%************************ EVALUATE JACOBIAN AND RESIDUAL ************************
%********************************************************************************


function [F,DF] = eval_res_and_jac(y,bvpfile,t,bvpopt,parameters,I,D)

% ***** evaluate residual
F = eval_res(bvpfile,t,y,bvpopt,parameters,D,[]);

% ***** evaluate Jacobian only if necessary
if nargout > 1
   DF = eval_jac(bvpfile,t,y,bvpopt,parameters,I);
end



%********************************************************************************
%*************** EVALUATE JACOBIAN AND RES FOR LINEAR PROLEMS *******************
%********************************************************************************


function DF = eval_jac_lin(bvpfile,t,y,bvpopt,parameters,fprime)
global N_ p_ d_

% ***** define some constants
dimF = N_*(p_+1)*d_ + d_;
IdId = [-eye(d_) eye(d_)];
h = diff(t);
zerosd = zeros(d_);

% ***** reserve some space
DF = sparse([],[],[],dimF,dimF,N_*(p_+1)*d_ + N_*(p_+1)*d_^2 + 2*d_^2);

% ********** evaluate boundary terms
if bvpopt.Private.Preconditioner
   DF(1:d_ , 1:d_) = 1/h(1) * feval(bvpfile, 'dR/dya', [], [], [], [], parameters{:});
   DF(1:d_ , dimF-d_+1:dimF) = 1/h(1) * feval(bvpfile, 'dR/dyb', [], [], [], [], parameters{:});
else
   DF(1:d_ , 1:d_) = feval(bvpfile, 'dR/dya', [], [], [], [], parameters{:});
   DF(1:d_ , dimF-d_+1:dimF) = feval(bvpfile, 'dR/dyb', [], [], [], [], parameters{:});
end

% ***** define indices for the loop
row_idx = reshape(d_+1:N_*(p_+1)*d_+d_ , d_, N_*(p_+1));
col_idx_lo = 1:d_:N_*(p_+1)*d_;
col_idx_hi = col_idx_lo + (2*d_-1);

% ***** assemble matrix
for l=1:N_*(p_+1)
   DF(row_idx(:,l) , col_idx_lo(l):col_idx_hi(l)) = (IdId / h(l)) + [zerosd -fprime(:,:,l)];
end

%********************************************************************************
%******************************** LITTLE HELPERS ********************************
%********************************************************************************


function f = evaluate_f(bvpfile,t,y,bvpopt,parameters)
global N_ p_ d_

% ***** evaluate f(t,y) along the mesh
if bvpopt.fVectorized
   f = feval(bvpfile,'f',t,y,[],[],parameters{:});
else
   f = zeros(d_,length(t));   
   
   for l=1:length(t)
      f(:,l) = feval(bvpfile,'f',t(l),y(:,l),[],[],parameters{:});
   end
end



function fprime = evaluate_fprime(bvpfile,t,y,bvpopt,parameters)
global d_
% ********** evaluate f'(t,y) along the mesh
if bvpopt.JacVectorized
   fprime = reshape( feval(bvpfile,'df/dy',t,y,[],[],parameters{:}) , d_ ,d_ , length(t) );
else
   fprime = zeros(d_,d_, length(t));
      
   for l=1:length(t)
      fprime(:,:,l) = feval(bvpfile,'df/dy',t(l),y(:,l),[],[],parameters{:});
   end
end
