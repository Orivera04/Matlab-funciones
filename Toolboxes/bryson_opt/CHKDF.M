function chkdf(name,s,u,dt,ord,ep)
%CHKDF - Checks data file used in DOPC
% chkdf(name,s,u,dt,ord,ep)
% Compares derivatives computed by the data file with
% numerical differencing.
% INPUT:
%   name = data file name
%   f=feval(name,u,s,dt,1);
%   [Phi,Phis,Phiss]=feval(name,u,s,dt,2)
%   [fs,fu,fsu,fuu]=feval(name,u,s,dt,3),;
%   s    = state vector 
%   u    = scalar control value
%   dt   = time step
%
% OUTPUT:
% There are no output parameters.  The differences between the
% analytical and numerical derivatives are given by the variable
% "err" in the display output.
%----------------------------------------------------------------------------
% NOTE: If the error is large, there are two possible explanations.
%       1) The nominal values may be too small or too large in magnitude.
%          This usually happens if the "normal" values for the
%          problem formulated is not of order one.  So try
%          again with nominal values much larger or smaller.
%       2) There is an error in the analytical derivatives.
%----------------------------------------------------------------------------
% Written by Sun H. Hur 12/27/92; modified AEB 5/1/97

% Find nominal values for the derivatives
  [Phi,Phis,Phiss]=feval(name,u,s,dt,2);
  [fs,fu,fsu,fuu]=feval(name,u,s,dt,3);
end

[q,n]=size(Phis);
m=length(u);
t1=t+et;
u1=u+et;

% Check derivatives wrt to x
    disp('Phis'); 
    err=zeros(size(phis));
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      f1=feval(name,x1,u,t,2,1);
      der=(f1-phi)/et;
      err(:,i)=der-phix(:,i);
    end
    err,  pause(1), clear err der
  elseif flg==3
    disp(' '),disp('Phixx'); % flg=3
    err=zeros(size(phixx));
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      [d,f1]=feval(name,x1,u,t,2,1);
      dertmp=(f1-phix)/et;
      for j=1:q
        der(n*(j-1)+1:n*j)=dertmp(j,1:n)';
      end
      der=der(:);
      err(:,i)=der-phixx(:,i);
    end
    err,  pause(1), clear err der
  elseif flg==5
    disp(' '),disp('Phitx'); % flg=5
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      [d,d2,f1]=feval(name,x1,u,t,2,1);
      der=(f1-phit)/et;
      err(:,i)=der-phitx(:,i);
    end
    err,  pause(1), clear err der
  elseif flg==6
    disp(' '),disp('fx'); % flg=6
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      [f1]=feval(name,x1,u,t,1,1);
      der=(f1-f)/et;
      err(:,i)=der-fx(:,i);
    end
    err,  pause(1), clear err der
  elseif flg==9
    disp(' '),disp('fxx'); % flg=9
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      [f1]=feval(name,x1,u,t,3,1);
      dertmp=(f1-fx)/et;
      for j=1:n
        der(n*(j-1)+1:n*j)=dertmp(j,1:n)';
      end
      der=der(:);
      err(:,i)=der-fxx(:,i);
    end
    err, pause(1), clear err der
  elseif flg==11
    disp(' '),disp('fux'); % flg=11
    for i=1:n
      x1=x;
      x1(i)=x1(i)+et;
      [d,f1]=feval(name,x1,u,t,3,1);
      dertmp=(f1-fu)/et;
      for j=1:n
        der(m*(j-1)+1:m*j)=dertmp(j,1:m)';
      end
      der=der(:);
      err(:,i)=der-fux(:,i);
    end
    err, pause(1), clear err der

% Check derivatives wrt to t
  elseif flg==2
    disp(' '),disp('Phit'); % flg=2
    [f1]=feval(name,x,u,t1,2,1);
    der=(f1-phi)/et;
    err=der-phit
    pause(1), clear err der
  elseif flg==4
    disp(' '),disp('Phitt') % flg=4
    [d,d2,f1]=feval(name,x,u,t1,2,1);
    der=(f1-phit)/et;
    err=der-phitt
    pause(1), clear err der
  elseif flg==8
    disp(' '),disp('ft') % flg=8
    [f1]=feval(name,x,u,t1,1,1);
    der=(f1-f)/et;
    err=der-ft
    pause(1), clear err der

% Check derivatives wrt to u
  elseif flg==7
    disp(' '),disp('fu'); % flg=7
    for i=1:m
      u1=u;
      u1(i)=u1(i)+et;
      [f1]=feval(name,x,u1,t,1,1);
      der=(f1-f)/et;
      err(:,i)=der-fu(:,i);
    end
    err,  pause(1), clear err der
  elseif flg==10
    disp(' '),disp('fuu'); % flg=10
    for i=1:m
      u1=u;
      u1(i)=u1(i)+et;
      [d,f1]=feval(name,x,u1,t,3,1);
      dertmp=(f1-fu)/et;
      for j=1:n
        der(m*(j-1)+1:m*j)=dertmp(j,1:m)';
      end
      der=der(:);
      err(:,i)=der-fuu(:,i);
    end
    err, pause(1), clear err der

  elseif flg==20
    % Check Minimum Principle
    disp(' '),disp('Optimality Condition')
    umin=feval(name,x,u,t,4,1);
    [d,fu]=feval(name,x(1:n),umin,t,3,1);
    Hu=x(n+1:2*n)'*fu
  end
end

