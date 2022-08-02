function M = evalAveOtherVariables(eq, var)
%EVALAVEOTHERVARIABLES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:31 $

%evaluate eq at the variables given, then 
%average the variables that appear in eq, but not in the list var

   
% evaluate the expression at the values set up
M = eval(eq);

% get the pointers to variables in the expression, don't put in duplicates
varExpr = vectors(eq);

dvarExpr = double(varExpr);
dvar = double(var);

numvectors = 0;
for i = 1:length(varExpr)
   %if it is a vector valued variable, that is not in the table, needs to be averaged
   if ~varExpr(i).isscalar
      numvectors = numvectors +1;
      [OK,Spare] = cgvardiff(varExpr(i),var);
      if isempty(OK) % if varExpr(i) is not in the table      
         M = mean(M,numvectors);
      end   
   end
end
% this relies on the current way that eval works by ndgridding, then squeezing
M = squeeze(M);

if length(dvar) == 2
    % determine whether to transpose M or not. Depends on the order of the variables in the list
    for i = 1:length(varExpr)
        if cgvarcompatible(varExpr(i),var(1));
            break
        end
    end
    for j = 1:length(varExpr)
        if cgvarcompatible(varExpr(j),var(2));
            break
        end
    end
    if i > j
        M = M';
    end
end

% fill the matrix with zeros where the matrix is complex
if ~isreal(M)
   M(find(imag(M))) = 0;
end
   