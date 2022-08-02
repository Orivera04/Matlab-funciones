function chkpop(name,y,order,fv,et)                             
% Checks the data file used in the parameter gradient algorithms
% POP and POPN. Compares the derivatives computed by the data file 
% with numerical differencing;                           1/93, 8/15/02
% INPUT:
%   name = data file name where
%            [L,f,Ly,fy,Lyy,fyy]=feval(name,y);
%   y    = parameter vector
% Optional inputs
%   order = order of the algorithm for which the data file is intended
%           1 = pop, 2 = popn (default = 1)
%   fv   = vector of flgs, where
%          flg = 1 : Ly   2: fy  3: Lyy   4: fyy
%           (default = [1 2]  if order=1
%                      [1:4]     if order=2)
%   et   = difference step (default=1e-4)
%
% OUTPUT:
% There are no output parameters.  The differences between the
% analytical and numerical derivatives are given by the variable
% "err" in the display output.
%------------------------------------------------------------------------
% NOTE: If the error is large, there are two possible explanations.
%       1) The nominal values may be too small or too large in magnitude.
%          This usually happens if the "normal" values for the
%          problem formulated is not of order one. So try
%          again with nominal values much larger or smaller.
%       2) There is an error in the analytical derivatives.
%----------------------------------------------------------------------------
% Based on 'chkf' written by Sun H. Hur 12/92

if nargin<5, et=1e-4;      end
if nargin<3, order=1;      end
if nargin<2, error('Missing input parameters'), end
if nargin<4,
  if order==1;
    fv=[1 2]; 
  else
    fv=[1:4];
  end
end
format compact

% Find nominal values for the derivatives
if order==1
  [L,f,Ly,fy]=feval(name,y);
else  
  [L,f,Ly,fy,Lyy,fyy]=feval(name,y);  
end

N=length(fv); p=length(y); q=length(f);

for k=1:N
  flg=fv(k);

  % Check derivatives 
  if flg==1
    disp('err Ly'); 
    for i=1:p
      y1=y;
      y1(i)=y1(i)+et;
      f1=feval(name,y1);
      der=(f1-L)/et;
      err(i)=der-Ly(i);
    end
    disp(err);  pause(1), clear err
  elseif flg==2
    disp('err fy');
    for i=1:p
      y1=y;
      y1(i)=y1(i)+et;
      [d,f1]=feval(name,y1);
      der=(f1-f)/et;
      err(:,i)=der-fy(:,i);
    end
    disp(err);  pause(1), clear err
  elseif flg==3
    disp('err Lyy');
    for i=1:p
      y1=y;
      y1(i)=y1(i)+et;
      [d,d,f1]=feval(name,y1);
      der=(f1-Ly)'/et;
      err(:,i)=der-Lyy(:,i);
    end
    disp(err);  pause(1), clear err
  elseif flg==4
    disp('err fyy'); 
    for i=1:p
      y1=y;
      y1(i)=y1(i)+et;
      [d,d,d,f1]=feval(name,y1);
      dertmp=(f1-fy)/et;
      for j=1:q
        der(p*(j-1)+1:p*j)=dertmp(j,1:p)';
      end
      der=der(:);
      err(:,i)=der-fyy(:,i);
    end
    disp(err); pause(1), clear err
  end
end
