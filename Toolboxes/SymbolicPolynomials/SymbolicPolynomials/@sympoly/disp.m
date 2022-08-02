function expression = disp(sp,pretty)
% sympoly/disp: Disp a sympoly object
%
% arguments:
%  sp     - a sympoly object
%
%  pretty - (OPTIONAL) character flag - 
%           Default: 'off'
%
%           pretty == 'off' --> basic matlab
%           pretty == 'on'  --> As pretty as I could make it

% unpack the sympoly
coef = sp.Coefficient;
nt = length(coef);

expon = sp.Exponent;
vars = sp.Var;
nv = length(vars);

if (nargin<2) || isempty(pretty)
  pretty = 'off';
end

linewidth = 80;

breaks = [];
switch pretty
case 'off'
  % first, check to see if its just a constant.
  if (size(expon,1)==1) && all(expon==0)
    % a constant
    expression = ['    ',num2str(coef(1))];
    
  else
    % more than just a scalar constant
    expression = '    ';
    breaks = [];
    
    % loop over the terms in the poly
    firstterm = 1;
    for i = 1:nt
      
      % build the multinomial part
      term = '';
      for j = 1:nv
        if ~isempty(vars{j})
          if expon(i,j)~=0
            term = [term,vars{j}];
          end
          
          % do we need an exponent?
          if (expon(i,j)~=0) && (expon(i,j)~=1)
            term = [term,'^',num2str(expon(i,j))];
          end
          
          % insert a '*' between monomial parts
          if ~isempty(term) && (j<nv) && any(expon(i,(j+1):end)) && (term(end)~='*')
            term = [term,'*'];
          end
        end
        
      end
      
      C = coef(i);
      % if this is the first term, then leave the
      % coefficient alone
      if firstterm
        % this is the first term of possibly many terms
        if C == 0
          term = '';
        elseif (C == 1) && ~isempty(term)
          % term is already built
        elseif isempty(term)
          term = num2str(C);
        else
          term = [num2str(C),'*',term];
        end
      else
        % there are at least two terms in the expression
        if C == 0
          term = '';
        elseif (C == 1) && ~isempty(term)
          % term is already built. just append a sign
          term = [' + ',term];
        elseif (C == -1) && ~isempty(term)
          % term is already built. just append a sign
          term = [' - ',term];
        elseif isempty(term) && (C>0)
          term = [' + ',num2str(C)];
        elseif isempty(term) && (C<0)
          term = [' - ',num2str(abs(C))];
        elseif C>0
          term = [' + ',num2str(C),'*',term];
        else
          % must be C<0 
          term = [' - ',num2str(abs(C)),'*',term];
        end
      end
      
      % accumulate into the overall expression
      expression = [expression, term];
      
      % on to the rest of the terms
      firstterm = 0;
      
      % where can we break this expression?
      breaks = [breaks,length(expression)];
      
    end
  end
  
  case 'on'
    error 'Pretty is not enabled yet.'
    
    
    
    
end

% do we have an output argument?
if nargout==0
  disp(expression)
  clear expression
end



