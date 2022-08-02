function varargout=set(m,property,value);
% XREGMODEL/SET overloaded set function for xregmodel class
%
% set(m,property,value)
%  Note inputname{1} is used as variable name in caller workspace
%  Therefore subsref expressions cannot be used for m.
%
% Supported properties:
%   'ytrans'     Y Transformation (could be inline, char or sym)
%                An empty matrix turns off amy y trans
%                The inverse function must exist. It is calculated here
%                and stored for speedy evaulation.
%   'code'       X Coding Transformation 
%                must a structure array with fields:
%                   min   minimum
%                   max   maximum
%                   g     inline object
%                An empty matrix turns off the coding transformation.
%   'boxcox'     Sets ytrans as a boxcox transformation
%                Value can be one of 
%                  lambda
%                  {lambda , y}
%                  {[lambda,shift], y}

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:53:03 $

switch lower(property)
case 'ytrans'
   ytrans = char(value);
   % calculate 
   if ~isempty(ytrans) & ~m.TransBS
      % warning turned off to prevent messages about nonunique inverses
      ws= warning;
      warning off
      % devectorise
      yt= strrep(ytrans,'.^','^');
      yt= strrep(yt,'.*','*');
      yt= strrep(yt,'./','/');
      yt= strrep(yt,'.\','\');
      
      % Calculate inverse transformation using symbolic toolbox
      yinv   = finverse(sym(yt));
      warning(ws)
      % make sure inline functions are vectorized (i.e. use .*,./,.^)
      m.ytrans = vectorize(inline(ytrans));
      m.yinv   = inline(yinv);
   else
      % Turn off Y Transformation if value is empty
      if ~isempty(ytrans) 
          m.ytrans = vectorize(inline(ytrans));
      else
          m.ytrans = '';
      end
      m.yinv   = '';
   end
case 'tbs'
   if supportTBS(m)
      m.TransBS= value;
      if value
         m.yinv = '';
      elseif ~isempty(m.ytrans)
         set(m,'ytrans',char(sym(m.ytrans)))
      end 
   end
case 'fitalg'
   m.FitAlgorithm= value;
case 'code'
   % see model/setcode for new, more general, method structure
   
   % check that coding structure is correct
   if isa(value,'struct') & all(ismember({'min','max','g'},fieldnames(value)))
      for i=1:length(value)
         c=value(i);
         g= c.g;
         if ~isempty(g)
            value(i).min= g(c.min);
            value(i).max= g(c.max);
         end
         value(i).mid = (value(i).min + value(i).max)/2;
         value(i).range = 2;
      end
      m.code = value;
   else
      error('Invalid Coding Structure');
   end
case 'datum'
   for i=1:length(value)
      c(i).min= 0;
      c(i).max= 2;
      c(i).g   = '';
      c(i).mid = value(i);
   end
   m.code=c;
case 'boxcox'
   if ~isa(value,'cell')
      % value = lambda;
      value={value};
   end
   lam= value{1}(1);
   if length(value)==2
      % value = lambda;
      y= value{2};
   else
      y=1;
   end
   y(isnan(y))=[];
   if length(value{1})>1;
      shift=value{1}(2);
   else
      % calculate shift from to ensure that all y are positive
      if  min(y)<0
         % Shift the data if negative numbers are in the data set
         shift=abs(min(y))+1;
      elseif min(y)==0
         shift=1;
      else
         shift=0;
      end
   end
   
   y=y+shift;
   % Calculate the geometric mean of the data
   geo_mean=exp(mean(log(y)));							   
   % Build up character expressions for 'ytrans' (Texpr) and 'yinv' (Iexpr)
   % Conditional statements are used to make efficient expressions
   if shift>0
      Texpr= sprintf('(y+%10.5g)',shift);
      Iexpr= sprintf('- %10.5g',shift);
   elseif shift>0
      Texpr= sprintf('(y-%10.5g)',-shift);
      Iexpr= sprintf('- %10.5g',-shift);
   else
      Texpr = '(y)';
      Iexpr = '';
   end 
   
   if lam==0
      % log transform is different T = geo_mean*log(y-shift)
      Texpr = ['log',Texpr];
      if geo_mean~=1
         Texpr = [sprintf('%10.5g*',geo_mean),Texpr];
         Iexpr = [sprintf('exp(x/%10.5g)',geo_mean),Iexpr];
      else
         Iexpr = ['exp(x)' Iexpr];
      end
               
   else
      % non-log transform  
      %   T = ((y-shift).^lambda - 1)/(lambda*geo_mean^(lambda-1))
      scale   = lam*geo_mean^(lam-1);
      Texpr = ['(',Texpr,sprintf('.^(%-5.3f) - 1)',lam)];
      if scale~=1
         Texpr= [Texpr,sprintf('/(%10.5g)',scale)];
         Iexpr= [sprintf('(%10.5g*x+1).^(%-5.3f)',scale,1/lam) Iexpr];
      else
         Iexpr= [sprintf('(x+1).^(%-5.3f)',1/lam) Iexpr];
      end
   end
   Iexpr=strrep(Iexpr,' ','');
   % make inline objects
   m.ytrans= inline(Texpr);
   if ~m.TransBS
      m.yinv  = inline(Iexpr); 
   else
      m.yinv='';
   end
case {'symbol','symbols'}
   
   m.Xinfo.Symbols = value;
   
case 'nfactors'
   % change the number of factors
   nlold= nfactors(m);
   if  value < nlold
      % delete some factor info
      m.code= m.code(1:value);
      m.Xinfo.Names= m.Xinfo.Names(1:value);
      m.Xinfo.Units= m.Xinfo.Units(1:value);
      m.Xinfo.Symbols= m.Xinfo.Symbols(1:value);
   elseif value > nlold 
      for i=nlold+1:value
         % new coding assume [-1,1]
         m.code(i).min = -1;
         m.code(i).max = 1;
         m.code(i).g   = '';
         m.code(i).mid = 0;
         m.code(i).range= 2;
         % extend xinfo
         s= sprintf('X%1d',i);
         m.Xinfo.Names{i}   = s;
         m.Xinfo.Units{i}   = '';
         m.Xinfo.Symbols{i} = s;
      end
   end
case 'outliers'
	if ischar(value)
		ok= exist(value)==2;
	else
		ok= isempty(value) | (isnumeric(value) & (size(value,2)==4 | size(value,2)==5));
	end
	if ok
		m.Outliers= value;
	else
		error('Invalid outlier setting'); 
	end
otherwise
   error('MODEL/SET invalid property');
end % switch

if nargout==1
   varargout{1}=m;
else
   assignin('caller',inputname(1),m);
end
