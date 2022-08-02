function sp = clean_sympoly(sp) 
% clean_sympoly: clean up a scalar sympoly, coallesce terms & drop excess vars
%
% arguments:
%  sp - a scalar sympoly

% collect any terms that may have coallesced
if length(sp.Coefficient)>1
  [sp.Exponent,sp.Coefficient] = consolidator( ...
    sp.Exponent,sp.Coefficient,'sum');
end

% drop any variables that have all zero exponents
k = all(sp.Exponent==0,1);
if all(k)
  sp.Exponent = 0;
  sp.Var = {''};
  sp.Coefficient = sum(sp.Coefficient);
elseif any(k)
  k=find(k);
  L = cellfun('isempty',sp.Var(k));
  k(L)=[];
  
  sp.Exponent(:,k) = [];
  sp.Var(k) = [];
end

% drop any terms with a zero coefficient, unless it was
% the only term.
k = (sp.Coefficient==0);
if any(k)
  sp.Exponent(k,:)=[];
  sp.Coefficient(k,:)=[];
end

% check for a degenerate sympoly
if isempty(sp.Coefficient)
  % its zero
  sp.Var = {''};
  sp.Exponent = 0;
  sp.Coefficient = 0;
end


