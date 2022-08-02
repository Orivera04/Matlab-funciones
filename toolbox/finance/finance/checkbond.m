function OutputBond = checkbond(InputBond)
%CHECKBOND Tested Bond Structure from Input Bond Structure.
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Author(s): C. Bassignani, 04-18-98 
%              J. Akao,       05-20-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $   $Date: 2002/04/14 21:57:11 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (nargin < 1)
     error('You must enter at least the input bond structure!')
end

if (nargin > 1)
     error('Too many input arguments specified!')
end


%Check to see if the check and default bond structure have been passed in;
%if not get them
if  ((nargin == 1) & (~isa(InputBond, 'struct')))
     
     error('Input bond must be a structure!')
     
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check to see if the bond has already been checked; if it has don't check it
%again
if (isfield(InputBond, 'BondCheckFlag'))
     
     if (InputBond.BondCheckFlag)
          
          OutputBond = InputBond;
          
          return
     end
end
    

%Check the basic fields and values of the input bond structure
InputBond = checkstruct(InputBond, 'bondstand');

%Check all the date parameters for the bond itself
InputBond = ckbasedates(InputBond);


%Check the date paramters for all options
InputBond = ckoptdates(InputBond);


%If all flags indicate success, set the overall bond flag and return
if ((InputBond.CSCheckFlag) & (InputBond.BaseDateCheckFlag) &...
          (InputBond.OptDateCheckFlag))
     
     InputBond.BondCheckFlag = 1;
     
     %Remove the other flags
     InputBond = rmfield(InputBond, 'CSCheckFlag');
     InputBond = rmfield(InputBond, 'BaseDateCheckFlag');
     InputBond = rmfield(InputBond, 'OptDateCheckFlag');
     
else
     error('An error occurred in check all components of the bond structure!')
end

OutputBond = InputBond;

%end of CHECKBOND function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%          CKBASEDATES Subroutine for Checking Bond Date Fields
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InputBond = ckbasedates(InputBond)

if (isfield(InputBond, 'BaseDateCheckFlag'))
     
     %Check to see if the bond's base dates have already been checked
     if (InputBond.BaseDateCheckFlag == 1)
          
          return
          
     end
end


% unpack dates and make them numeric
Settle =          makedatenumeric(InputBond.Settle);
Maturity =        makedatenumeric(InputBond.Maturity);
IssueDate =       makedatenumeric(InputBond.IssueDate);
FirstCouponDate = makedatenumeric(InputBond.FirstCouponDate);
LastCouponDate =  makedatenumeric(InputBond.LastCouponDate);
StartDate =       makedatenumeric(InputBond.StartDate);

% check required user inputs: Settle, Maturity
if (isempty(Settle) | isempty(Maturity))
     error('Bond fields Settle and Maturity must be specified');
end

% check that dates are scalar or empty
if all( prod(size(Settle)) ~= [0 1] )
     error('Bond date field Settle must be scalar');
end
if all( prod(size(Maturity)) ~= [0 1] )
     error('Bond date field Maturity must be scalar');
end
if all( prod(size(IssueDate)) ~= [0 1] )
     error('Bond date field IssueDate must be scalar or empty');
end
if all( prod(size(FirstCouponDate)) ~= [0 1] )
     error('Bond date field FirstCouponDate must be scalar or empty');
end
if all( prod(size(LastCouponDate)) ~= [0 1] )
     error('Bond date field LastCouponDate must be scalar or empty');
end
if all( prod(size(StartDate)) ~= [0 1] )
     error('Bond date field StartDate must be scalar or empty');
end

% check date conformance

% Settle <= Maturity
if ( Settle > Maturity )
     error('Settle must precede Maturity');
end

% Issue <= Settle
if (~isempty(IssueDate) & (IssueDate > Settle))
     error('IssueDate must precede Settle');
end
     
%Write any changes back to the input bond structure
InputBond.Settle = Settle;
InputBond.Maturity = Maturity;
InputBond.IssueDate = IssueDate;
InputBond.FirstCouponDate = FirstCouponDate;
InputBond.LastCouponDate  = LastCouponDate;
InputBond.StartDate       = StartDate;

InputBond.BaseDateCheckFlag = 1;

%end of CKBASEDATES subroutine

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      CKOPTDATES Subroutine for Checking Embedded Option Date Fields
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InputBond = ckoptdates(InputBond, j)

if (isfield(InputBond, 'OptDateCheckFlag'))
     
     if (InputBond.OptDateCheckFlag == 1)
          
          return
     end
end

% unpack parameters
Settle =      InputBond.Settle;
Maturity =    InputBond.Maturity;

CallType       = InputBond.CallType;
CallStartDate  = InputBond.CallStartDate;
CallExpiryDate = InputBond.CallExpiryDate;
CallStrike     = InputBond.CallStrike;

PutType        = InputBond.PutType;
PutStartDate   = InputBond.PutStartDate;
PutExpiryDate  = InputBond.PutExpiryDate;
PutStrike      = InputBond.PutStrike;

% make dates numeric
CallStartDate = makedatenumeric( CallStartDate );
CallExpiryDate = makedatenumeric( CallExpiryDate );
PutStartDate = makedatenumeric( PutStartDate );
PutExpiryDate = makedatenumeric( PutExpiryDate );

CallOptionFieldCheck = 0;

if (~isempty(CallType) | ~isempty(CallStartDate) |...
         ~isempty(CallExpiryDate) | ~isempty(CallStrike) )

     if isempty(CallStrike)
          error(['Bond field CallStrike must be specified if a' ...
                   ' call exists']);
     end
     
     if isempty(CallType)
          % American
          CallType = 1;
     end
     
     if isempty(CallExpiryDate)
          CallExpiryDate = Maturity;
     end
     
     if isempty(CallStartDate);
          if (CallType==0)
               % European
               CallStartDate = CallExpiryDate;
          else
               % American
               CallStartDate = Settle;
          end
     end
     if ( (CallType==0) & (CallStartDate~=CallExpiryDate) )
       error(['A European Call cannot have a CallStartDate different',...
          ' from CallExpiryDate']);
     end
     
     CallOptionFieldCheck = 1;
end


PutOptionFieldCheck = 0;

if (~isempty(PutType) | ~isempty(PutStartDate) |...
         ~isempty(PutExpiryDate) | ~isempty(PutStrike) )

     if isempty(PutStrike)
          error(['Bond field PutStrike must be specified if a' ...
                   ' Put exists']);
     end
     
     if isempty(PutType)
          % set to american
          PutType = 1;
     end
     
     if isempty(PutExpiryDate)
          PutExpiryDate = Maturity;
     end
     
     if isempty(PutStartDate);
          if (PutType==0)
               % European
               PutStartDate = PutExpiryDate;
          else
               % American
               PutStartDate = Settle;
          end
     end
     if ( (PutType==0) & (PutStartDate~=PutExpiryDate) )
       error(['A European Put cannot have a PutStartDate different',...
          ' from PutExpiryDate']);
     end
     
     PutOptionFieldCheck = 1;
end

if ((CallOptionFieldCheck) | (PutOptionFieldCheck))
     InputBond.OptionFlag = 1;
else
     InputBond.OptionFlag = 0;
end

InputBond.OptDateCheckFlag = 1;

% save changes
InputBond.CallType =        CallType       ; 
InputBond.CallStartDate =   CallStartDate  ; 
InputBond.CallExpiryDate =  CallExpiryDate ; 
InputBond.CallStrike =      CallStrike     ; 
                                            
InputBond.PutType =         PutType        ; 
InputBond.PutStartDate =    PutStartDate   ; 
InputBond.PutExpiryDate =   PutExpiryDate  ; 
InputBond.PutStrike =       PutStrike      ; 

     
%end of CKOPTDATES subroutine

function DateNumber = makedatenumeric(DateParameter)
% MAKEDATENUMERIC takes numbers, strings, or cell arrays of strings
% and changes them to date numbers.

if ischar(DateParameter)
     % can only be a column
     MRows = size(DateParameter,1);
     NCols = 1;
     DateNumber = datenum(DateParameter);
elseif iscell(DateParameter)
     [MRows, NCols] = size(DateParameter);
     DateNumber = datenum(char(DateParameter));
else
     [MRows, NCols] = size(DateParameter);
     DateNumber = DateParameter;
end
DateNumber = reshape(DateNumber, MRows, NCols);


