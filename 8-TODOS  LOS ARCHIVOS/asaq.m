function [fnew,xnew]=asaq(func,x,maxstep,qf,lb,ub,tinit)
% Determines optimum of a function using simulated annealing.
%
% Example call: [fnew,xnew]=asaq(func,x,maxstep,qf,lb,ub,tinit)
% func is the function to be minimized, x the initial approx.
% given as a column vector, maxstep the maximum number of main
% iterations, qf the quenching factor in range 0 to 1,
% Note: small value gives slow convergence, value close to 1 gives
% fast convergence, but may not supply global optimum,
% lb and ub are lower and upper bounds for the variables,
% tinit is the intial temperature value
% Suggested values for maxstep = 200, tinit = 100, qf = 0.9
%
% Initialisation
xold=x;
fold=feval(func,x);
n=length(x);lk=n*10;
% Quenching factor q
q=qf*n;
% c values estimated
nv=log(maxstep*ones(n,1));
mv=2*ones(n,1);
c=mv.*exp(-nv/n);
% Set values for tk
t0=tinit*ones(n,1);tk=t0;
% upper and lower bounds on x variables
% variables assumed to lie between -100 and 100
a=lb*ones(n,1);b=ub*ones(n,1);
k=1;
% Main loop
for mloop = 1:maxstep
  for tempkloop=1:lk
    % Choose xnew as random neighbour
    fold=feval(func,xold);
    u=rand(n,1);
    y=sign(u-0.5).*tk.*((1+ones(n,1)./tk).^(abs((2*u-1))-1));
    xnew=xold+y.*(b-a);
    fnew=feval(func,xnew);
    % Test for improvement
    if fnew <= fold
      xold=xnew;
    elseif exp((fold-fnew)/norm(tk))>rand
      xold=xnew;
    end
  end
  % Update tk values
  tk=t0.*exp(-c.*k^(q/n));
  k=k+1;
end
tf=tk;
