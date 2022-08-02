function [Zij, Z, S, Cats, accept] = sampleMulti(N,sampSize,alpha,lambda)
% sampleOrdProb returns a sample from the posterior on the
%   rater-item values (Zij), the latent item traits, Z, the rater
%   variances S, and the category-cutoffs Cats. 
%   IT IS ASSUMED THAT THE MULTINOMIAL DENOMINATORS ARE ALL 1.
%   
%   N:		the data matrix, with "items" rows and "raters" columns.
%               Entries are labeled 1 to C, and it is assumed that each
%		rater rated each item.     
%   sampSize:	desired number of MCMC iterates. 
%   alpha,lambda: prior parameters on rater variances 
%   Zij:	sampSize x items x raters array containing sample
%               rater-item values z_ij.
%   Z:          sampSize x items array containing estimates z_i's
%   S           sampSize x rater array wit sampled variances
%   Cats        sampSize x C+1 x rater array with sampled category
%               cutoffs.  For simplicity (,1,) element is -10,
%               (,C+1,1)=10.  (i,j,r) is the ith sampled value of the
%               lower cutoff for the j'th category (upper cutoff for
%               the (j-1) category) for the r'th rater
%   
%   accept:	acceptance ratio for category cutoffs

%   Matlab initialize vectors

    [items raters] = size(N);
    C = max(max(N));
    Zij(1:sampSize,1:items,1:raters) = 0;
    Z = zeros(sampSize,items);
    S = zeros(sampSize,raters);
    Cats(1:sampSize,1:(C+1),1:raters) = 0;

%   "Sample" first value of vectors

    muN = mean(N);
    stdN = sqrt(var(N));
    Zij(1,:,:) = (N-ones(items,1)*muN)./(ones(items,1)*stdN);
    temp = squeeze(Zij(1,:,:));
    Z(1,:) = mean(temp');

    Cats(:,1,:) = -10;
    Cats(:,(C+1),:) = 10;
    for i=2:C
	Ind = ones(size(N));
        j = find(N>=i);
	Ind(j) = 0;
        Cats(1,i,:) = Phiinv((sum(Ind)+.5)/(items+.501));
    end

    tZij = squeeze(Zij(1,:,:));
    tZ   = squeeze(Z(1,:))'; 
    ss   = sum( (tZij-tZ*ones(1,raters)).^2 )';
    temp = (rgamma( 0.5*items + alpha*ones(raters,1), 0.5*ss +lambda)).^(-1);
    S(1,:) = temp';

    sigma = sqrt(S);
    
    sm = 0.4/C;
    g = zeros(C+1,1);
    oldg = zeros(C+1,1);
    accept = 0;


%   Begin real sampling loop;

    for i=2:sampSize

%     1. Sample latent vector Zij

	  for j=1:raters
	     upper = Cats((i-1),(N(:,j)+1),j)';
	     lower = Cats((i-1),N(:,j),j)';
             Zij(i,:,j) = truncNorm(Z((i-1),:)',sigma((i-1),j),lower,upper); 
	  end

%     2. Sample gamma
          
	  for j=1:raters      
%	      a) Put proposal gamma in g; the old gamma in oldg
		oldg = Cats((i-1),:,j)'; 
                g = oldg;
                for k=2:C 
		   g(k) = truncNorm(oldg(k),sm,g(k-1),oldg(k+1));
	        end
	    

%	      b) Calculate acceptance ratio R
		%   adjust R for proposal density truncation
                R = 1;
		for k=2:C
		   R = R * ( Phi((oldg(k+1)-oldg(k))/sm) -  ...
                         Phi((g(k-1)-oldg(k))/sm) ) / ... 
                       ( Phi((g(k+1)-g(k))/sm) - ...
                         Phi((oldg(k-1)-g(k))/sm) );
	        end
	        %  multiply in likelihood

                phiYnew = Phi( (g(N(:,j)+1) - Z((i-1),:)')/sigma((i-1),j) );
                phiYold = Phi( (oldg(N(:,j)+1) - Z((i-1),:)')/sigma((i-1),j) );
		phiYm1new=Phi( (g(N(:,j)) - Z((i-1),:)')/sigma((i-1),j));
	        phiYm1old=Phi( (oldg(N(:,j)) -Z((i-1),:)')/sigma((i-1),j));
	        R = R*prod( (phiYnew-phiYm1new)./(phiYold-phiYm1old));

%             c) Accept/reject
                % accept/reject
                if rand < R
                  Cats(i,:,j) = g';
                  accept = accept+1;
		else
		  Cats(i,:,j) = oldg';
                end

	    end

  
%     3. Sample Z given Zij
                b = sum((squeeze(Zij(i,:,:))./(ones(items,1)*S((i-1),:)))' )';
                a = 1+sum((ones(items,raters)./(ones(items,1)*S((i-1),:)))' )';
		Z(i,:) = (b ./ a)'+randn(1,items)./sqrt(a');

%     4. Sample S
	        tZij = squeeze(Zij(i,:,:));
		tZ   = squeeze(Z(i,:))'; 
		ss   = sum( (tZij-tZ*ones(1,raters)).^2 )';
		temp = (rgamma( 0.5*items + alpha*ones(raters,1), ...
			0.5*ss +lambda)).^(-1);
		S(i,:) = temp';
		sigma = sqrt(S);

  end

  accept = accept/((sampSize-1)*raters);
  
  function val=Phi(x)
val=.5*(1+erf(x/sqrt(2)));

function val=Phiinv(x)
val=sqrt(2)*erfinv(2*x-1);

function gam = rgamma(alpha,lambda)
% Generates random gamma deviates from density
%       lambda^alpha g^alpha-1 exp(-lambda*x)/Gamma(alpha)
%       E(gam) = alpha/lambda   Var(gam)=a/lambda^2
%
%  Begin by generating g~gamma(alpha,1)
%
  e = exp(1);
  gam = -ones(size(alpha));
  if alpha<1
     for i=1:length(alpha)
        g = -1; 
        a = alpha(i);
        aa = (a+e)/e;
        while g<0
          r1 = rand;
          r2 = rand;
          if r1>1/aa
             w = -log(aa*(1-r1)/a);
             if r2 < w^(a-1)
                g = w;
             end
          else
             w = (aa*r1)^(1/a);
             if r2<exp(-w)
                g = w;
             end
          end
        end
        gam(i) = g;
     end
  elseif alpha>1
     for i=1:length(alpha)
        a = alpha(i)-1;
        b = (alpha(i)-1/(6*alpha(i)))/a; 
        m = 2/a;
        d = m+2;
        g = -1;
        while g<0
           x = rand;
           y = rand;
           v = b*y/x;
           if (m*x-d+v+1/v) <= 0
                g = a*v;
           elseif (m*log(x)-log(v)+v-1) <= 0
                g = a*v;
           end
        end
        gam(i) = g;
      end
  else
        gam = -log(rand(size(alpha)));
  end
  gam = gam ./ lambda;
         
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
  
