function [beta, rsq, sse, sst]=getRegressionRsq(x,y)
      beta = x\y;
      yhat = x*beta;
      residuals = y - yhat;
      ybar = mean(y);
      sse = norm(residuals)^2;    
      sst = norm(y - ybar)^2; 
      rsq = 1 - (sse ./ sst);
end