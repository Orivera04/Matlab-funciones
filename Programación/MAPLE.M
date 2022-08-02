function [result,status] = maple(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
%MAPLE	Access the Maple kernel.
%	This function is used by other functions in the Student Edition
%	Symbolic Toolbox to communicate with the Maple kernel.

%	Copyright (c) 1993-94 by The MathWorks, Inc.

% Check for 'traceon' or 'traceoff'.

global MAPLETRACE
if nargin > 0
   if strcmp(a0,'traceon')
      MAPLETRACE = 1;
      return
   elseif strcmp(a0,'traceoff')
      MAPLETRACE = 0;
      return
   end
end

% Convert and concatenate arguments.

statement = [];
if nargin > 0
   if nargin > 1
      if ~isstr(a0)
         error('First argument to maple function must be a string.')
      end
      statement = [a0 '('];
      for k = 1:nargin-1
         if k > 1, statement = [statement ',']; end
         eval(['a = a' int2str(k) ';'])
         if ~isstr(a)
            a = sym(a);
         end
         if ~isempty(a)
            if a(1) == '['
               a = sm2ar(a);
            end
         end
         statement = [statement  a];
      end
      statement = [statement ')'];
   elseif ~isstr(a0) & length(a0) == 1
      statement = sym(a0);
   elseif ~isstr(a0) & ~isempty(a0)
      statement = sm2ar(a0);
   else
      statement = a0;
   end
end

% Terminate with a semicolon if necessary.

k = length(statement);
if k == 0
   return
elseif statement(k) ~= ';'
   statement(k+1) = ';';
end

% Access the Maple kernel via a Mex-file interface.

if MAPLETRACE, statement, end

[result,status] = maplemex(statement);

if MAPLETRACE, result, end

% Print any warning messages.

if nargout < 2
   if status == 1
       disp('Warning: Maple result too long.  String truncated.')
   elseif status == 2
       error(result)
   elseif status == 3
       error(result)
   elseif status == 4
       % Status info, bytes used.
       disp(result);
       result = [];
   elseif status == 5
       disp('Warning: Maple(quit, done or stop) ignored.')
   elseif status == 6
       % Debugging info, printlevel.
       disp(result);
       result = [];
   elseif status == 7
       disp('Use pretty instead of maple(''prettyprint()'').')
   elseif status == 8
       disp('Use mhelp topic instead of maple(''help(topic)'').')
   end
end
if isempty(result) | (status ~= 0)
   return
end

% Change any nullparm[x] to nullparm(x).

if length(result) > 9
   r = find(result == ']');
   for k = findstr('nullparm[',result);
      result(k+8) = '(';
      result(min(r(r>k))) = ')';
   end
end

% Eliminate any "ans := "
for k = findstr('ans := ',result)
   result(k:k+6) = [];
end

% Shift decimal point in any Maple E-notation numbers.

result = shiftept(result);

% Convert any 'MATRIX' or 'VECTOR' to a symbolic matrix.

result = ar2sm(result);
