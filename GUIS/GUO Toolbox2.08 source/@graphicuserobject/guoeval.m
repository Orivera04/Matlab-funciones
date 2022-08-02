function [GUO, ExpressionResult] = guoeval(GUO, ChildGUO, Expression);

% function [GUO, ExpressionResult] = guoeval(GUO, ChildGUO, Expression);
% 
% Evaluates expression for a child GUO within "GUO".
% "ChildGUO" may be a Tag name or a child GUO number (see "addchildguo").
% "Expression" is a string containing the function to be evaluated, the first 
% argument of which (the child GUO) must be omitted - this will be inserted
% automatically.  If the result is a GUO, it replaces the child GUO within 
% "GUO", otherwise it is returned as "ExpressionResult".
% "GUO" is always returned, whether changed or not.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if ~ishandle(GUO.Frame)
   error('Object (GUO frame) has been deleted');
end
nChildGUOs = length(GUO.ChildGUOs);
if ischar(ChildGUO)
   ChildTag = ChildGUO;
   ChildGUO = 0;
   for k = 1:nChildGUOs
      if strcmpi(get(GUO.ChildGUOs{k}, 'Tag'), ChildTag)
         ChildGUO = k;
         break;
      end
   end
end
if ChildGUO > 0 & ChildGUO <= nChildGUOs
   Expression = deblank(Expression);
   Param1Str = ['GUO.ChildGUOs{' num2str(ChildGUO) '}'];
   LParenPos = strfind(Expression, '(');
   if length(LParenPos) > 0
      P = LParenPos(1);
      FName = Expression(1:P-1);
      if Expression(P+1) ~= ')'
         Param1Str = [Param1Str ','];
      end
      Expression = [Expression(1:P) Param1Str Expression(P+1:end)];
   else
      FName = Expression;
      Expression = [Expression '(' Param1Str ')'];
   end
   Fset = strcmpi(FName, 'set');
   LExpression = lower(Expression);
   % The following and similar lines should theoretically use the FindProperty function or equivalent...
   if Fset & length(strfind(LExpression, '''parent''')) > 0
      error('Parent property may not be set for Child GUOs');
   end
   if Fset
      % Modify child GUO with Visible=off to avoid flicker when
      % positioning, unless the Visible property is supplied.
      VisiblePropertyFound = length(strfind(LExpression, '''visible''')) > 0;
      if ~VisiblePropertyFound
         RParenPos = strfind(Expression, ')');
         P = RParenPos(length(RParenPos)) - 1;
         Expression = [Expression(1:P) ',''Visible'',''off''' Expression(P+1:end)];
      end
      try  % try/catch necessary in MATLAB R13 because of error "One or more output arguments not assigned during call to 'set'"
         warning off;  % Suppress warning in R12 when the "set" function doesn't deliver a result (normal case!)
         ER = eval(Expression);
         warning on;
      catch
         eval(Expression);
      end
   else
      try  % try/catch in case Expression doesn't deliver a result
         ER = eval(Expression);
      catch
         eval(Expression);
      end
   end
   if exist('ER')
      if isa(ER, 'graphicuserobject');
         GUO.ChildGUOs{ChildGUO} = ER;
      else
         ExpressionResult = ER;
      end
   end
   if Fset
      if ~exist('ExpressionResult')
         CGUO = GUO.ChildGUOs{ChildGUO};
         if length(strfind(LExpression, '''position''')) > 0
            % Position/size child GUO relative to GUO frame
            GUO = PositionInFrame(GUO, CGUO, ChildGUO);
         elseif length(strfind(LExpression, '''units''')) > 0
            GUO.NormalizedChildGUOs(ChildGUO) = strcmpi(get(CGUO, 'Units'), ...
                                                     'normalized');
         end
         if ~VisiblePropertyFound
            set(CGUO, 'Visible', 'on');
         end
      end
   elseif strcmpi(FName, 'delete')
      GUO.ChildGUOs = [GUO.ChildGUOs{1:ChildGUO-1} GUO.ChildGUOs{ChildGUO+1:end}];
   end
end
