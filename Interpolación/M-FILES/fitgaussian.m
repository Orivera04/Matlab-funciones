function [f X err it]=fitgaussian(x,y,init,w)
% FITGAUSS is a function to fit a gaussian curve "f" to experimental data 
% by Marquardt-Levenberg non-linear least squares minimisation.
% "f" has a form like a*exp(-((x-b)/c)^2)+d*x+e
% INPUTS
% "x,y" is input coordinates
% "init" is initial guess for parameteres [a b c d e]. If is empty they
% will be determinded automatically from input data
% "w" is weight vector (default is ones(size(x)))
% OUTPUTS
% "f" is the fitted function
% "X" is the estimated parameters
% "err" is the normalized error
% "it" is number of iteartions
%
% Mehmet OZTURK
% 
% Example:
% [x y]=getpts;
% fitgauss(x,y);

if nargin==1 % only one input is supplied
    y=x; x=1:length(y); w=ones(numel(x),1);
    det_init=true;
elseif nargin==2
    det_init=true; w=ones(numel(x),1);
elseif nargin==3
    w=ones(numel(x),1);
    det_init=false;
else
    det_init=false;    
end

% bias=mean(y);

x=x(:); y=y(:); w=w(:);

if det_init % determine initials
    dyf=csaps(x,y);
    dy=fnval(fnder(dyf,1),x);
    [ymax,imax,ymim,imin] = extreme(dy);
    maximum=imax(1); minimum=imin(1);
    st=min([maximum minimum]); fi=max([maximum minimum]);
    
    a0=y(round((st+fi)/2));
    b0=x(round((st+fi)/2));
    c0=abs(x(fi)-x(st))/2;
    d0=0;
    e0=mean(y);
else
    a0=init(1); b0=init(2); c0=init(3); d0=init(4); e0=init(5);
    if c0==0, c0=1; end
end
% a0,b0,c0,d0,e0

W=frepmat(w(:),1,5);
n_iters=100; % set # of iterations for the LM
lamda=1; % set an initial value of the damping factor for the LM
updateJ=1;
a_est=a0; b_est=b0; c_est=c0; d_est=d0; e_est=e0;
warning('off','all')
for it=1:n_iters
    if updateJ==1
        % Evaluate the Jacobian matrix at the current parameters (a_est, b_est)
        common = exp(-((x-b_est)./c_est).^2);

        J(:,1)=-common;
        J(:,2)=-2*a_est*(x-b_est)/c_est.^2.*common;
        J(:,3)=-2*a_est*(x-b_est).^2/c_est.^3.*common;
        J(:,4)=-x;
        J(:,5)=-ones(size(x));

        J(isnan(J))=1;
        J=J.*W;
        % Evaluate the distance error at the current parameters
        y_est = a_est.*exp(-((x-b_est)./c_est).^2)+d_est.*x+e_est;
        D=(y-y_est).*w;
        
        % compute the approximated Hessian matrix, J’ is the transpose of J
        H=J.'*J;
        
        if it==1 % the first iteration : compute the total error
            E=sum(D.*D);
        end
    end
    
    % Apply the damping factor to the Hessian matrix
    H_lm=H+lamda*eye(5);
    
    % Compute the updated parameters
    dp=-H_lm\(J.'*D(:));
    a_lm=a_est+dp(1);
    b_lm=b_est+dp(2);
    c_lm=c_est+dp(3);
    d_lm=d_est+dp(4);
    e_lm=e_est+dp(5);
    
    % Evaluate the total distance error at the updated parameters
    y_est_lm = a_lm.*exp(-((x-b_lm)./c_lm).^2)+d_lm.*x+e_lm;
    D_lm=(y-y_est_lm).*w;
    E_lm=sum(D_lm.*D_lm);
    
    % If the total distance error of the updated parameters is less than the previous one
    % then makes the updated parameters to be the current parameters
    % and decreases the value of the damping factor
    diff_E = abs(E_lm - E);
    if E_lm < E
        lamda=lamda/10;
        a_est=a_lm;
        b_est=b_lm;
        c_est=c_lm;
        d_est=d_lm;
        e_est=e_lm;
        E=E_lm;
        updateJ=1;
    else % otherwise increases the value of the damping factor
        updateJ=0;
        lamda=lamda*10;
    end
    if diff_E < 1e-7
        break
    end
end

f=a_est.*exp(-((x-b_est)./c_est).^2)+d_est.*x+e_est;
err=realsqrt(E)/numel(x);
X=[a_est b_est c_est d_est e_est];

warning('on','all')
if nargout==0
    figure,plot(x,y,'.',x,f,'.-r')
end