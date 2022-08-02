function [mle,cov,dev,devRes,fits] = ordinalMLE(data,K,link)

% ordinalMLE computes the MLE for ordinal regression of N on X.
%
%  data:   data matrix of form [y x], where y is ordinal response 1,2,...
%         and x is covariate matrix
%  K:      number of categories (limits on y are 1 to k)
%  link:   must be either "logistic" or "probit" 
%
%	mle:    MLE of category cutoffs theta_2,...,theta_K-1 (theta_1==0),
%		     followed by MLE of regression parameter. Dimension of
%	        mle is K-2+p, if X has p columns.
%	cov:    Asymptotic covariance matrix for the MLE
%  dev:    Deviance statistic.
%  devRes: Individual components of deviance.
%  fit:    matrix of fitted probabilities, where a row gives fitted probabilities
%          for a given observation

%	Notation and algorithm based on Jansen, 91, 
%       Biometrical Journal, vol 33, 807-815.
%
%	N:	The count vector.  Assumed to have IxK rows, where
%		I is the number of treatments, and K is the number of
%		categories.  The elements of the i^th row contain the
%		category counts for treatment combination i. Ji
%		denotes the number of observations in row i.
%	X:	Design matrix for linear regression of cumulative
%		probabilities.  In this parameterization, a column of
%		1's is likely required since the first category cutoff
%		is assumed to be 0.  X*mle is the MLE linear
%               predictor.  It does not contain category-cutoff indicators.
%	
%		

[N,X]=reformdata(data,K);

if strcmp(link,'logistic')+strcmp(link,'probit') == 0
  error('invalid link specification in ordinalMLE')
end

[I,K] = size(N);
[I0,p] = size(X);

if I0~=I
  error('N and X are not compatibly sized')
end

J = (sum(N'))'; %(I x 1) vector
C = diag(ones(K-1,1))+diag(-1*ones(K-2,1),-1); C = [C;[zeros(1,K-2), -1]];
Zt = diag(ones(K-1,1));
Zmult = Zt; Zmult(1,1) = 0;  % used to form gammas in loop 
Zt = Zt(:,2:(K-1)); % left part of Z - get rid of first column since
                    % theta_1 == 0.


% Initialize parameter vectors for iteratively reweighted least squares

mu = (J*ones(1,K)).*(N+0.5)./(J*ones(1,K)+K/2);
gam = ones(I,K-1);
pi0 = ones(I,K);


for k=1:K
  if k>1
    sumMu = sum( N(:,1:k)'+0.5 )';
  else
    sumMu = N(:,1)+0.5;
  end


  if strcmp(link,'logistic')
     if k < K
	gam(:,k) = log( (sumMu./(J+K/2)) ./ (1-sumMu./(J+K/2)) );
     end

     if k==1
	pi0(:,k) = invLogit(gam(:,k));
     else
        if k < K
	   pi0(:,k) = invLogit(gam(:,k))-invLogit(gam(:,k-1));
        else
           pi0(:,k) = 1 - invLogit(gam(:,k-1));
	end
     end
  end
  if strcmp(link,'probit')
     if k < K
	gam(:,k) = Phiinv(sumMu./(J+K/2));
     end
     if k==1
        pi0(:,k) = Phi(gam(:,k));
     else
        if k < K
           pi0(:,k) = Phi(gam(:,k))-Phi(gam(:,k-1));
        else
	   pi0(:,k) = 1 - Phi(gam(:,k-1));
        end
     end  
  end
% add other link functions here if needed
end


% Initialize parameter vector; assume regression parameter is 0

alpha = zeros(K-2+p,1);
alpha(1:(K-2)) = (mean( gam(:,2:(K-1) ) ))';


logLike0 = 0;
change = 1;
iter = 0;

while (change>0.0001 & iter<31) |  iter<4
  A = zeros(K-2+p,K-2+p);
  bb = zeros(K-2+p,1); % will equal sum_i Zi'Hi Ci'Vi(ni-mu_i)

  for i=1:I
    % Form Hi matrix.  Only it and pi0 depend on link
    if strcmp(link,'logistic')  % use logistic density
	Hi = diag( exp(gam(i,:)) ./ (1+exp(gam(i,:))).^2 );
    end
    if strcmp(link,'probit')   % use standard normal density
        Hi = diag( pdfnorm(gam(i,:),0,1) );
    end
    % Compute Ci
    Ci = J(i)*C;
    % Compute Zi
    Zi = [ Zt -ones(K-1,1)*X(i,:) ];
    % Compute Vi
    Vi = diag(ones(1,K)./mu(i,:));
    % Increment A and bb
    A = A + Zi'*Hi*Ci'*Vi*Ci*Hi*Zi;
    bb = bb + Zi'*Hi*Ci'*Vi*(N(i,:)-mu(i,:))';
  end

  cov = inv(A);
  alpha = alpha + cov*bb;


  % Now compute pi0, gam, mu

  for i=1:I
	% compute Zi*alpha = gamma(i,k)
        gam(i,:) = ([Zmult -ones(K-1,1)*X(i,:)]*[0; alpha])';
  end

  for k=1:K
    if strcmp(link,'logistic')
     if k==1
	pi0(:,k) = invLogit(gam(:,k));
     else
        if k < K
	   pi0(:,k) = invLogit(gam(:,k))-invLogit(gam(:,k-1));
        else
           pi0(:,k) = 1 - invLogit(gam(:,k-1));
	end
     end
    end
    if strcmp(link,'probit')
     if k==1
        pi0(:,k) = Phi(gam(:,k));
     else
        if k < K
           pi0(:,k) = Phi(gam(:,k))-Phi(gam(:,k-1));
        else
	   pi0(:,k) = 1 - Phi(gam(:,k-1));
        end
     end  
    end
    % add other link functions here if needed
  end

  mu = (J*ones(1,K).*pi0);

  

  logLike1 = ordLog(N,pi0);
  if logLike0 == 0
	change = - logLike1;
  else
	change = logLike1 - logLike0;
  end
  logLike0 = logLike1;
  iter = iter + 1;

end  

if iter == 30
	'No convergence after 30 iterations'
end

iter
mle = alpha;
[dev,devRes] = ordDev(N,pi0);
fits = mu;


function val=Phiinv(x)
% Computes the standard normal quantile function of the vector x, 0<x<1.
%
val=sqrt(2)*erfinv(2*x-1);

function y = Phi(x)
% Phi computes the standard normal distribution function value at x
%
y = .5*(1+erf(x/sqrt(2)));

function [dev,devRes] = ordDev(N,pi0)
% ordDev computes the deviance of N for probability vector pi0.
%
%	Notation and algorithm based on Jansen, 91, 
%       Biometrical Journal, vol 33, 807-815.
%
%	N:	The count vector.  Assumed to have IxK rows, where
%		I is the number of treatments, and K is the number of
%		categories.  The elements of the i^th row contain the
%		category counts for treatment combination i.
%       pi0:	I x K probability vector. 
%       dev:    Deviance of model
%       devRes: (UNSIGNED,UNSQUARE-ROOTED) contribution to deviance
%               from each observation.    
%
%	For simplicity, log-probability is actually computed for
%               pi0+eps
	
	[I K] = size(N);
	denom = (sum(N')')*ones(1,K);
	devRes = 2*sum( (N.*log((N+eps)./(denom.*pi0+eps)))');
	dev = sum(devRes);
   
function val = ordLog(N,pi0)
% ordLog computes the log-likelihood of N for probability vector pi0.
%
%	Notation and algorithm based on Jansen, 91, 
%       Biometrical Journal, vol 33, 807-815.
%
%	N:	The count vector.  Assumed to have IxK rows, where
%		I is the number of treatments, and K is the number of
%		categories.  The elements of the i^th row contain the
%		category counts for treatment combination i.
%       pi0:	I x K probability vector.  
%
%	For simplicity, log-probability is actually computed for
%               pi0+eps
	
	val = sum(sum(N.*log(pi0+eps)));

  function y = invLogit(x)
% INVLOGIT computes exp(x) / (1+exp(x)).  Extreme values are set to 0 or 1.

 extreme = 15;
 y = zeros(size(x));

 i = find( abs(x)<extreme ); 
 y(i) = exp(x(i))./(1+exp(x(i)));

 i = find( x>extreme );
 y(i) = ones(size(i));

 i = find( x< (-extreme) );
 y(i) = zeros(size(i));

function [N,X]=reformdata(data,k)

y=data(:,1);
n=size(data,1);
c=size(data,2);
X=data(:,2:c);
N=zeros(n,k);
for i=1:n
   N(i,y(i))=1;
end

function val=pdfnorm(x,mu,sigma)

if nargin==1, mu=0; sigma=1; end
val=1/sqrt(2*pi)./sigma.*exp(-.5./sigma.^2.*(x-mu).^2);
