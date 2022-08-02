function [beta, pvalue, rsq, sse, sst]=getRegressionPValues(x,y)
  [Q,R]=qr(x,0);
  beta = R\(Q'*y);  
  
  yhat = x*beta;
  residuals = y - yhat;
  ybar = mean(y);  
  
  sse = norm(residuals)^2;        
  sst = norm(y - ybar)^2; 
  rsq = 1 - (sse ./ sst);
  
  nobs = length(y);
  p = length(beta);
  dfe = nobs-p;

  mse = sse./dfe;
  ri = R\eye(p);
  xtxi = ri*ri';
  covb = xtxi*mse;
  se = sqrt(diag(covb));
  t = beta ./ se;
  pvalue = 2*(tcdf(-abs(t), dfe));
end