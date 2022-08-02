function [results] = mean_variance(std_state, scalar)

% Computes Mean and Variance for all standard Probability Models 

switch std_state
  % Binomial
  case 1
     mean = scalar(1)*scalar(2) ;
     variance = mean*(1-scalar(2)) ;

  % Erlang
  case 2
     mean = scalar(1)/scalar(2);
     variance = scalar(1)/scalar(2)^2;   

  % Exponential
  case 3
     mean = 1/scalar(1);
     variance = 1/(scalar(1)^2);

  % Geometric
  case 4    
     mean = 1/scalar(1);
     variance = (1-scalar(1))/(scalar(1)^2);
     
  % Negative Binomial
  case 5     
     mean = scalar(1)/scalar(2);
     variance = scalar(1)*(1-scalar(2))/scalar(2)^2;

  % Normal
  case 6
     mean = scalar(1);
     variance = scalar(2);   

  % Poisson
  case 7
     mean = scalar(1);
     variance = scalar(1);
end

results = [mean, variance] ;