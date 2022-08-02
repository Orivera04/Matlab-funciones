function [A] = pmf(std_state, scalar)

% Returns matrix of numerical PMF/PDF results for standard probability models

global Primary_state 

switch std_state

  % Binomial
  case 1
    k = scalar(1) ;
    p = scalar(2) ;
    A = [[0:k]; binpmftotal(k,p)]';
    m = k+1;

  % Erlang
  case 2
    k = scalar(1) ;
    l = scalar(2) ;
    kmax = (k/l)+5*sqrt(k/l^2);
    kmin = max(0,(k/l) - 5*sqrt(k/l^2));
    x = [kmin:((kmax-kmin)/50):kmax];
    temp = erlangpdf(k,l,x);
    A = [x;temp]';   
    m = length(x);   
  
  % Exponential
  case 3
    l = scalar(1) ;
    k = -log(0.0001)/l ;
    x = [0:(k/50):k];
    temp = exppdf(l,x);
    A = [x;temp]';   
    m = length(x);   

  % Geometric
  case 4    
    p = scalar(1) ;
    k = ceil(log(.00001)/log(1-p)) ;
    A = [[0:k-1]; geometricpmf(p,k)]';
    m = k;

  % Negative Binomial
  case 5    
    r = scalar(1) ;
    p = scalar(2) ;
    k = ceil(r/p + 5*sqrt(r*(1-p)/p^2)) ;
    temp = negbinpmf(r,p,k);
    temp(1:(r-1))=[];
    A = [[r:(r+k)]; temp]';
    m = k+1;

  % Normal
  case 6
    mu = scalar(1) ;
    sigma = scalar(2) ;
    k = 5*sqrt(sigma);  
    x = [-k+mu:(k/25):k+mu];
    temp = normalpdf(mu,sigma,x);
    A = [x;temp]';   
    m = length(x);   
   
  % Poisson
  case 7
    l = scalar(1) ;
    k = round(max(10, l + 5*sqrt(l)));
    A = [[0:k]; poissonpmf(l,k)]';
    m = k+1;

end % switch std_state

