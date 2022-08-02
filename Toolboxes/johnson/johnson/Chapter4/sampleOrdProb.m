function [sampleBeta, lat_resid, accept] = sampleOrdProb(data,K,mle,sampSize)
% sampleOrdProb returns a sample from the posterior on the
%   category-cutoffs and regression parameters in an ordinal probit
%   model.  IT IS ASSUMED THAT THE MULTINOMIAL DENOMINATORS ARE ALL 1,
%   or that the row sum of N is a 1 vector.
%   
%   N:		the data matrix, as expected by ordinalMLE.m    
%   X:		design matrix, without indicators for the category-cutoffs.
%   mle:	initial estimate of the vector (\gamma_2, ..., 
%		\gamma_{C-1},\beta_0,...,\beta_p).
%   sampSize:	desired number of MCMC iterates.  
%   sampleBeta: MCMC sample with sampSize rows, and columns 
%		corresponding to the
%		components of mle.  
%   lat_resid:  posterior means of the sorted latent variables.
%   accept:	acceptance ratio for category cutoffs

[N,X]=reformdata(data,K);
h = waitbar(0,'Simulation running ...');

%   Initialize vectors
    [I K] = size(N);
    [p p0] = size(mle); % p should be rank(beta)+K-2
    [I0 a] = size(X);

    if p0 ~= 1
	error('mle should be a vector')
    end

    if I0 ~= I
        error('Design rows doesnt match observation rows')
    end

    if a ~= (p-K+2)
        error('Columns of X do not match mle beta columns')
    end 

    sampleBeta = zeros(sampSize,p);
    lat_resid = zeros(I,1);
    sampleBeta(1,:) = mle';
    std = ones(I,1);
    covB = inv(X'*X);
    sm = 0.8/K;
    g = zeros(K,1);
    oldg = zeros(K,1);
    accept = 0;
    linPred = X*sampleBeta(1,[(K-1):p])';


    for i=1:sampSize
       
       %     1. Sample latent vector Z
%        a) Form linear predictor
                if i~=1
		   i0 = i-1;
	        else
                   i0 = 1;
		end
		linPred = X*sampleBeta(i0,[(K-1):p])';
		
%        b) Form upper and lower truncation points
                upper = sum((N*diag([0 sampleBeta(i0,[1:(K-2)]) ... 
                                     sampleBeta(i0,K-2)+5.0 ]))')';
                lower = sum((N*diag([-10 0 sampleBeta(i0,[1:(K-2)]) ]))')';
%        c) Draw sample
                z = truncNorm(linPred,std,lower,upper);
                lat_resid = lat_resid + sort(z-linPred);

%     2. Sample gamma
%        a) Get proposal gamma in g; the old gamma in oldg
		oldg = [0 sampleBeta(i0,[1:(K-2)]) sampleBeta(i0,K-2)+4]'; 
                g(1) = 0;
                for j=2:(K-1) 
		   g(j) = truncNorm(oldg(j),sm,g(j-1),oldg(j+1));
	        end
	        g(K) = g(K-1)+4;

%        b) Calculate acceptance ratio R
		%   adjust R for proposal density truncation
                R = 1;
		for j=2:(K-1)
		   R = R * ( Phi((oldg(j+1)-oldg(j))/sm) -  ...
                         Phi((g(j-1)-oldg(j))/sm) ) / ... 
                       ( Phi((g(j+1)-g(j))/sm) - ...
                         Phi((oldg(j-1)-g(j))/sm) );
	        end
	        %  multiply in likelihood

                phiYnew = Phi( N*g  - linPred );
                phiYold = Phi( N*oldg - linPred );
		phiYm1new=Phi( N*[-1000 g([1:(K-1)])']' - linPred);
	        phiYm1old=Phi( N*[-1000 oldg([1:(K-1)])']' -linPred);
	        R = R*prod( (phiYnew-phiYm1new)./(phiYold-phiYm1old));

%        c) Accept/reject
                % accept/reject
                if rand < R
                  sampleBeta(i,[1:(K-2)]) = g([2:(K-1)])';
                  accept = accept+1;
		else
		  sampleBeta(i,[1:(K-2)]) = oldg([2:(K-1)])';
                end

  
%     3. Sample beta given Z
                LS = covB * X' * z;
                sampleBeta(i,[(K-1):p]) = rMultiNorm(LS,covB)';
                
                waitbar(i/sampSize)
             end
             
close(h)
  lat_resid = lat_resid/sampSize;
  accept = accept/sampSize;
  
  function val = truncNorm(mu,std,lower,upper)
% truncNorm returns a sample vector of normal deviates with means mu
%     standard deviation std, truncated to the intervals
%     (lower,upper).
%

% Calculate bounds on probabilities
  lowerProb = Phi((lower-mu)./std);
  upperProb = Phi((upper-mu)./std);

% Draw uniform from within (lowerProb,upperProb)
  u = lowerProb+(upperProb-lowerProb).*rand(size(mu));

% Find needed quantiles
  val = mu + Phiinv(u).*std;
  
  
  function y = Phi(x)
% Phi computes the standard normal distribution function value at x
%
y = .5*(1+erf(x/sqrt(2)));

function val=Phiinv(x)
% Computes the standard normal quantile function of the vector x, 0<x<1.
%
val=sqrt(2)*erfinv(2*x-1);

function rnorm = rMultiNorm(mu,cov)
% rMultiNorm generates a random multivariate normal vector.
%
%size(mu);
%size(cov);
%chol(cov);
randn(size(mu));
rnorm = mu +chol(cov)'*randn(size(mu));

function [N,X]=reformdata(data,k)

y=data(:,1);
n=size(data,1);
c=size(data,2);
X=data(:,2:c);
N=zeros(n,k);
for i=1:n
   N(i,y(i))=1;
end
