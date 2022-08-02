function [A] = cdf(std_state, scalar)

% Returns matrix of numerical CDF results for standard probability models

switch std_state

  % Binomial
  case 1
    k = scalar(1);
    p = scalar(2) ;
    A = [[0:k]; bincdf(k,p)]';
    m = k+1;
   
  % Erlang
  case 2
    k = scalar(1) ;
    l = scalar(2) ;
    kmax = (k/l)+5*sqrt(k/l^2);
    kmin = max(0,(k/l) - 5*sqrt(k/l^2));
    x = [kmin:((kmax-kmin)/50):kmax];
    temp = erlangcdf(k,l,x);
    A = [x;temp]';   
    m = length(x);   

  % Exponential
  case 3
    l = scalar(1) ;
    k = -log(0.0001)/l ;
    x = [0:(k/50):k];
    temp = expcdf(l,x);
    A = [x;temp]';   
    m = length(x);   

  % Geometric
  case 4    
    p = scalar(1) ;
    k = ceil(log(.00001)/log(1-p)) ;
    temp = geometriccdf(p,k) ;
    A = [[0:k-1]; temp]';
    m = k;

  % Negative Binomial
  case 5    
    r = scalar(1) ;
    p = scalar(2) ;
    k = ceil(r/p + 5*sqrt(r*(1-p)/p^2)) ;
    temp = negbincdf(r,p,k);
    temp(1:(r-1)) = [];
    A = [[r:(r+k)]; temp]';
    m = k+1;

  % Normal
  case 6
    mu = scalar(1) ;
    sigma = scalar(2) ;
    k = 5*sqrt(sigma);  
    x = [-k+mu:(k/25):k+mu];
    temp = normalcdf(mu,sigma,x);
    A = [x;temp]';   
    m = length(x);   

  % Poisson
  case 7
    l = scalar(1) ;
    k = round(max(10, l + 5*sqrt(l)));
    temp = poissoncdf(l,k);
    A = [[0:k]; temp]';
    m = k;
   
end % switch std_state
