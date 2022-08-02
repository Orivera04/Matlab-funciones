function value= get(m,property);
% XREGMODEL/GET overlaoaded get function for model class
%
% value= get(m,property)
% Supported properties:
%   'ytrans'     Y Transformation
%   'yinv'       Inverse Y Transformation
%   'code'       X Coding Transformation 
%                returns a structure array with fields:
%                   min   minimum
%                   max   maximum
%                   g     inline object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:51:55 $



if nargin==1
   % 
   value= {'symbols','ytrans','yinv',...
         'tbs','fitalg','nfactors',...
         'code','shift','boxcox','outliers'}';
else
   switch lower(property)
   case {'symbol','symbols'}
      % this was symbol before
      value= m.Xinfo.Symbols;
   case 'ytrans'
      value= m.ytrans;
   case 'yinv'
      value= m.yinv;
   case 'tbs'
      value= m.TransBS;
   case 'fitalg'
      value= m.FitAlgorithm;
   case 'nfactors'
      value= nfactors(m);
   case 'boxcox'
      if ~isempty(m.ytrans);
         Texpr=char(m.ytrans);
         lind=findstr(Texpr,'log');
         if ~isempty(lind) %& (Texpr(find(Texpr=='l'):find(Texpr=='l')+2)=='log')
            value=0;
         else
            % Decipher the non-log transform  
            pwrind=find(Texpr=='^');
            mnsind=find(Texpr=='-');
            strend=mnsind(find(mnsind>pwrind+2));
            value=str2num(Texpr(pwrind+1:strend-1));
         end
      else
         value=1;
      end
   case 'code'
      % this needs to be modified to get new target (see model/setcode)
      value=m.code;
      ws=warning;
      warning off
      for i=1:length(value)
         g= char(value(i).g);
         if ~isempty(g) & ~strcmp(g,'x')
            % invert min and max
            g=strrep(g,'.^','^');
            ginv = finverse(sym(  g ));
            ginv = inline(ginv);
            value(i).min = ginv(value(i).min);
            value(i).max = ginv(value(i).max);
         end
      end
      warning(ws);
   case 'datum'
      if ~isempty(m.code)
         value = [m.code.mid]';
      else
         value = 0;
      end
	case 'outliers'
		value= m.Outliers;
   otherwise
      error('MODEL/GET invalid property');
   end
end
