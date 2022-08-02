function argout = classfin(argin1, argin2)
%CLASSFIN Create financial structure or return financial structure class name.
% 
%   Usage 1: Create a financial structure of class ClassName.
%     Obj = classfin(ClassName)
%     Obj = classfin(Struct, ClassName)
%
%     Inputs:
%       Struct - Structure to be converted into a financial structure.
%       ClassName - String containing name of financial structure class.
%
%     Outputs:
%       Obj - Instance of financial structure.
%
%
%   Usage 2: Return financial structure's class name.
%     ClassName = classfin(Obj)
% 
%     Inputs:
%       Obj - Instance of financial structure.
%
%     Outputs:
%       ClassName - String containing the name of the financial
%       structure class.
%
%   Examples:
%     1) Create a HJMTimeSpec financial structure instance, and
%        complete its fields (typically, the function 'hjmtimespec' 
%        would be used to create HJMTimeSpec structures).
%
%        TimeSpec = classfin('HJMTimeSpec');
%        TimeSpec.ValuationDate = datenum('Dec-10-1999');
%        TimeSpec.Maturity = datenum('Dec-10-2000');
%        TimeSpec.Compounding = 2;
%        TimeSpec.Basis = 0;
%        TimeSpec.EndMonthRule = 1;
%
%     2) Create a financial structure from an existing structure.
%
%        TSpec.ValuationDate = datenum('Dec-10-1999');
%        TSpec.Maturity = datenum('Dec-10-2000');
%        TSpec.Compounding = 2;
%        TSpec.Basis = 0;
%        TSpec.EndMonthRule = 0;
%        TimeSpec = classfin(TSpec, 'HJMTimeSpec');
%
%     3) Obtain a financial structure's class name.
%        load deriv
%        ClassName = classfin(HJMTree)
%
%
%   See also ISAFIN.

%   Author(s): J. Akao 12/17/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:40:56 $

%-----------------------------------------
% search for a ClassName (character)
%-----------------------------------------
if ischar(argin1)
  % usage 2
  ClassName = argin1;
  Obj = [];
elseif isstruct(argin1) & (nargin==2) & ischar(argin2)
  % usage 3
  ClassName = argin2;
  Obj = argin1;
elseif (nargin==1)
  % usage 1
  ClassName = '';
  Obj = argin1;
else
  % should parse different cases to try to find what person wanted to do JHA
  error('improper arguments');
end

%-----------------------------------------
% Outputs
%-----------------------------------------
if isempty(ClassName)
  % return ClassName output
  
  if isstruct(Obj) & isfield(Obj,'FinObj')
    % marked financial structure
    ClassName = getfield(Obj,'FinObj');
  else
    % return official object class
    ClassName = class(Obj)
  end
  
  argout = ClassName;
  
else
  % return Obj output
  
  if isempty(Obj)
    Obj = struct('FinObj', ClassName);

  elseif isstruct(Obj)
    
    try
      % try official object class
      TryObj = class(Obj, ClassName);
      
    catch
      % financial structure class
      TryObj = setfield(Obj, 'FinObj', ClassName);
        
    end
    Obj = TryObj;
    
  end
  
  argout = Obj;

end

