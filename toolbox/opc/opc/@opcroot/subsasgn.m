function Obj = subsasgn(Obj, Struct, Value)
%SUBSASGN Subscripted assignment into OPC Toolbox objects.
%   Obj(I) = B Assigns the values of B into the elements of Obj specified
%   by the subscript vector I. B must have the same number of elements as I
%   or be a scalar. 
%
%   Obj.Propname = B assigns the value B to the property, Propname, of OPC
%   Toolbox object Obj.
%
%   Supported syntax for OPC Toolbox objects: 
%   Dot Notation                            Equivalent SET Notation
%   ============                            =======================
%   obj.Timeout = 300;                      set(obj,'Timeout',300); 
%   obj(1).Timeout = 300;                   set(obj(1),'Timeout',300); 
%   obj(1:4).Timeout = 300;                 set(obj(1:4),'Timeout',300); 
%   obj([true false true]).Timeout=300;     set(obj([true false true]),'Timeout',300)
%   obj(1) = obj(2);               	
%   obj(2) = [];    
%
%   See also OPCROOT/SET, OPCROOT/SUBSASGN, PROPINFO, OPCHELP

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/03/24 20:43:45 $

% Initialize variables.
prop1 = '';
index1 = {};
StructL = length(Struct);

% Assuming obj is originally empty...
if isempty(Obj)
   % RHS must be the constructor
   % Ex. obj(1) = opc('host', 'serv') or obj(:) = opc('host', 'serv') or
   % opc(1:n) = opc('host', 'serv')
   if strcmp(Struct.type, '()') && (isequal(Struct.subs{1}, 1:length(Value)) || ...
           strcmp(Struct.subs{1},':'))
      Obj = Value;
      return
   elseif length(Value) ~= length(Struct.subs{1})
      % Ex. obj(1:2) = opcda('host', 'serv');
      rethrow(mkerrstruct('opc:subasgn:mismatch'));
   elseif Struct.subs{1}(1) <= 0
      % Ex. obj(-3) = opcda('host', 'serv');
      rethrow(mkerrstruct('opc:subasgn:negativeind'));
   else
      % Ex. obj(2) = opcda('host', 'serv'); and av is []..
      rethrow(mkerrstruct('opc:subasgn:syntaxerror'));
   end
end


% The first Struct can either be:
switch Struct(1).type
case '.'
    % Ex. obj.FramesPerTrigger = 10;
   prop1 = Struct(1).subs;
case '()'
    % Ex. obj(1) = obj(2); 
   index1 = Struct(1).subs; 
   % TODO: This doesn't work for obj(2,1)=blah
   if strcmp(index1{:}, ':')
       index1 = 1:length(Obj);
   end
case '{}'
    % Ex. obj{3} = obj(2);
   rethrow(mkerrstruct('opc:subasgn:cellsubs'));
otherwise
   rethrow(mkerrstruct('opc:subasgn:substype'));
end

if StructL > 1
   % Ex. obj(1).TimerFcn = 'mycallback' creates:
   %    Struct(1) -> () and 1
   %    Struct(2) ->  . and 'TimerFcn'
   %    StrcutL   ->  3
   switch Struct(2).type
   case '.'
      if isempty(index1)
         % Ex. obj.FramesAvailable.Prop2 = 5
         rethrow(mkerrstruct('opc:subasgn:dotsubs'));
      else
         % Ex. obj(1).TimerFcn = 'mycallback';
         % Ex. obj(2).PointstoStore = 10
         prop1 = Struct(2).subs;
      end
   case '()'
      rethrow(mkerrstruct('opc:subasgn:parensubs'));
   case '{}'
      rethrow(mkerrstruct('opc:subasgn:cellsubs'));
   otherwise
      rethrow(mkerrstruct('opc:subasgn:substype'));
   end  
end   

% Index1 will be entire object if not specified.
if isempty(index1)
   index1 = 1:length(Obj);
end

% Convert index1 to a cell if necessary.
if ~iscell(index1)
   index1 = {index1};
end

% Set the specified value.
if ~isempty(prop1)
   % Ex. obj.Tag = '10'
   % Ex. obj(2).tag = '10'
   
   % Extract the object.
   [indexObj, errflag] = localIndexOf(Obj, index1{1}); %index1{1} must be a double array here
   if errflag
      rethrow(mkerrstruct(lasterror));
   end
   
   % Set the property.
   try
      set(indexObj, prop1, Value);
   catch
      rethrow(mkerrstruct(lasterror));
   end
else
   % Ex. obj(2) = obj(1);
   if ~(isa(Value, 'opcroot') || isempty(Value)),
      rethrow(mkerrstruct('opc:subasgn:classmismatch'));
   end
   
   % Ex. obj(1) = [] and obj is 1-by-1.
   if ((length(Obj) == 1 || length(index1{:}) == length(Obj)) && isempty(Value))      
      rethrow(mkerrstruct('opc:subasgn:emptyarrays'));
   end

   % Error if a gap will be placed in array.
   % Ex. obj(4) = obj2 and obj is 1-by-1.
   if (max(index1{:}) > length(Obj)+length(Value))      
      rethrow(mkerrstruct('opc:subasgn:exceedsdims'));
   end
   
   % If the objects are the same length replace.
   if (length(index1{:}) == length(Value)) || isempty(Value) || (length(Value) == 1)
      [Obj, errflag] = localReplaceElement(Obj, index1, Value);
      if errflag
         rethrow(mkerrstruct(lasterror));
      end       
   else
      rethrow(mkerrstruct('opc:subasgn:mismatch'));
   end  
end

% *********************************************************************
% Index into an opc array.
function [result, errflag] = localIndexOf(obj, index)

% Initialize variables.
errflag = false;
result = obj;

try
   % Get the field information of the entire object.
   uddobj = getudd(obj);
   % Create result with only the indexed elements.
   reqhandle = uddobj(index);
   % Error if any of the resulting objects are invalid
   for k=1:length(reqhandle)
       if strcmp(class(reqhandle(k)), 'handle'),
           rethrow(mkerrstruct('opc:subsasgn:objinvalid'));
       end
   end
   % Make up an object as long as we require
   result.uddobject = reqhandle;
catch
   result = [];
%    lasterr('Index exceeds matrix dimensions.');
   errflag = 1;
   return;
end


% *********************************************************************
% Replace the specified element.
function [result, errflag] = localReplaceElement(obj, index, Value)

% Initialize variables.
errflag = 0;
result = obj;
try
   % Get the current state of the object.
   uddobj = getudd(obj);
  
   % Replace the specified index with Value.
   if ~isempty(Value)
      uddobj(index{1}) = getudd(Value);
   else
      uddobj(index{1}) = [];
   end
   result.uddobject = uddobj;
catch
   result = [];
   errflag = 1;
   return
end
