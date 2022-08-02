function mF=SimSetCode(m,mF,Mid,Gb)
% MODEL/SIMSETCODE builds SIMULINK block for coding
%
% This function will set up the appropriate coding info g
% in the math function block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:14 $

idx=[];
sys=get_param(Mid,'parent');
for i=1:length(mF)
   CODE= m.code;   
   op= char(CODE(i).g);
   if ~isempty(op)
      switch op
      case '1./x'
         op='reciprocal';
      case 'sqrt(x)'
         op= 'sqrt';
      case 'log10(x)'
         op= 'log10';
      case 'x.^2'
         op= 'square';
      case 'log(x)'
         op= 'log';
      end
      set_param(mF(i),'operator',op);
   end
end

% x(:,i)= (x(:,i) - c.mid)/(c.max-c.min)*c.range;

midValue=['[',num2str([m.code(:).mid],15),']'];
gval= [m.code(:).range]./([m.code(:).max]-[m.code(:).min]);

%rangeValue= ['[',num2str([m.code(:).range],15),']'];
%gainValue=[rangeValue,'.*[',num2str(1./([m.code(:).max]-[m.code(:).min]),15),']'];

gval(~isfinite(gval))=1;
gainValue= ['[',sprintf('%.15g ',gval),']'];

set_param(Mid,'value',midValue);
set_param(Gb,'gain',gainValue);