function bondspecguicall()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.10 $   $Date: 0000/00/00 00:00:00

global GIBOND;
global GSETTLE;
global GMATURITY;
global GBONDSPECFLAG;

IBond = bondspecdone;                                                                                   

GIBOND = IBond;

if(~isempty(IBond))
     
%Unpack the bond structure for plotting
Settle = IBond.Settle;
Maturity = IBond.Maturity;
Period = IBond.Period;
Basis = IBond.Basis;
EndMonthRule = IBond.EndMonthRule;
IssueDate = IBond.IssueDate;
FirstCouponDate = IBond.FirstCouponDate;
LastCouponDate = IBond.LastCouponDate;

CouponRate = IBond.CouponRate;

GSETTLE = Settle;
GMATURITY = Maturity;

[CFlowAmounts, CFDates] = cfamounts(CouponRate, Settle, Maturity,...
     Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate);


%Get the handle of the axes for plotting the bond
BondAxesHandle = findobj('Tag', 'AxesBond');

axes(BondAxesHandle);

cfplot(CFDates, CFlowAmounts);

plotscale(0.20);

set(gca, 'XTick', []);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
set(gca, 'YTick', []);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           


set(gca, 'Tag', 'AxesBond');

end


function IBond = bondspecdone()

global GBONDSPECFLAG;

%Set the output initially to an empty matrix
IBond = [];

ErrorFlag = 0;


%Make sure that no error message is displayed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
EditErrorMsgHandle = findobj(gcbf, 'Tag', 'EditBondSpecErrorMessage');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
ErrorMessage = '';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
set(EditErrorMsgHandle, 'String', ErrorMessage);
drawnow;


%Get the handles of all the date paramter fields                            
SettleHandle =  findobj(gcbf, 'Tag', 'EditSettle');                         
MaturityHandle =  findobj(gcbf, 'Tag', 'EditMaturity');                     
IssueDateHandle =  findobj(gcbf, 'Tag', 'EditIssueDate');                   
FirstCouponDateHandle =  findobj(gcbf, 'Tag', 'EditFirstCouponDate');       
LastCouponDateHandle =  findobj(gcbf, 'Tag', 'EditLastCouponDate');         
StartDateHandle =  findobj(gcbf, 'Tag', 'EditStartDate');                   
CallStartDateHandle =  findobj(gcbf, 'Tag', 'EditCallStartDate');           
CallExpiryDateHandle =  findobj(gcbf, 'Tag', 'EditCallExpiryDate');         
CallStrikePriceHandle =  findobj(gcbf, 'Tag', 'EditCallStrikePrice');       
PutStartDateHandle =  findobj(gcbf, 'Tag', 'EditPutStartDate');             
PutExpiryDateHandle =  findobj(gcbf, 'Tag', 'EditPutExpiryDate');           
PutStrikePriceHandle =  findobj(gcbf, 'Tag', 'EditPutStrikePrice');         
                                                                            
                                                                            
%Get the contents of the date parameter strings                     
SettleString = get(SettleHandle, 'String');                         
MaturityString = get(MaturityHandle, 'String');                     
IssueDateString = get(IssueDateHandle, 'String');                   
FirstCouponDateString = get(FirstCouponDateHandle, 'String');       
LastCouponDateString = get(LastCouponDateHandle, 'String');         
StartDateString = get(StartDateHandle, 'String');                   
CallStartDateString = get(CallStartDateHandle, 'String');           
CallExpiryDateString = get(CallExpiryDateHandle, 'String');         
CallStrikePriceString = get(CallStrikePriceHandle, 'String');       
PutStartDateString = get(PutStartDateHandle, 'String');             
PutExpiryDateString = get(PutExpiryDateHandle, 'String');           
PutStrikePriceString = get(PutStrikePriceHandle, 'String');         
                                                                    
                                                                    
%Convert all strings to numeric values                              
Settle = datenum(SettleString);                                     
Maturity = datenum(MaturityString);                                 
IssueDate = datenum(IssueDateString);                               
FirstCouponDate = datenum(FirstCouponDateString);                   
LastCouponDate = datenum(LastCouponDateString);                     
StartDate = datenum(StartDateString);                               
CallStartDate = datenum(CallStartDateString);                       
CallExpiryDate = datenum(CallExpiryDateString);                     
CallStrike = str2double(CallStrikePriceString);
if isnan(CallStrike),
	CallStrike = [];
end
PutStartDate = datenum(PutStartDateString);                         
PutExpiryDate = datenum(PutExpiryDateString);                       
PutStrike = str2double(PutStrikePriceString); 
if isnan(PutStrike),
	PutStrike = [];
end

%Get the values of the other bond paramters                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
CallOptionTypeHandle =  findobj(gcbf, 'Tag', 'PopCallOptionType');       
PutOptionTypeHandle =  findobj(gcbf, 'Tag', 'PopPutOptionType');                
FrequencyHandle =  findobj(gcbf, 'Tag', 'PopFrequency');
BasisHandle =  findobj(gcbf, 'Tag', 'PopBasis');
CouponRateHandle = findobj(gcbf, 'Tag', 'EditCouponRate');
FaceHandle = findobj(gcbf, 'Tag', 'EditFace');

CallOptionTypeValue = get(CallOptionTypeHandle, 'Value');
PutOptionTypeValue = get(PutOptionTypeHandle, 'Value');
FrequencyValue = get(FrequencyHandle, 'Value');
BasisValue = get(BasisHandle, 'Value');
CouponRateString = get(CouponRateHandle, 'String');
CouponRate = str2double(CouponRateString);
FaceString = get(FaceHandle, 'String');
Face = str2double(FaceString);

if (CallOptionTypeValue == 1)
     CallType = [];
elseif (CallOptionTypeValue == 2)
     CallType = 1;
elseif (CallOptionTypeValue == 3)
     CallType = 0;
end

if (PutOptionTypeValue == 1)
     PutType = [];
elseif (PutOptionTypeValue == 2)
     PutType = 1;
elseif (PutOptionTypeValue == 3)
     PutType = 0;
end

if (FrequencyValue == 1)
     Period = [];
elseif (FrequencyValue == 2)
     Period = 1;
elseif (FrequencyValue == 3)
     Period = 2;
elseif (FrequencyValue == 4)
     Period = 4;
elseif (FrequencyValue == 5)
     Period = 12;
end

if (BasisValue == 1)
     Basis = [];
elseif (BasisValue == 2)
     Basis = 0;
elseif (BasisValue == 3)
     Basis = 1;
elseif (BasisValue == 4)
     Basis = 2;
elseif (BasisValue == 5)
     Basis = 3;
end

%Set all defaults
EndMonthRule = 1;

if (isempty(Face))
     Face = 100;
end

if (isempty(Period))
     Period = 2;
end

if (isempty(CouponRate))
  CouponRate = 0;
end

%Do checking on parameters
ErrorFlag = 0;
if (Settle > Maturity)
     ErrorFlag = 1;
     ErrorMessage = 'Settle exceeds maturity!';
elseif (IssueDate > Settle)
     ErrorFlag = 1;
     ErrorMessge = 'Issue exceeds settle!';
elseif (FirstCouponDate < IssueDate)
     ErrorFlag = 1;
     ErrorMessage = 'Check first coupon date!';
elseif (LastCouponDate < IssueDate)
     ErrorFlag = 1;
     ErrorMessage = 'Check last coupon date!';
elseif (LastCouponDate < FirstCouponDate)  
     ErrorFlag = 1;
     ErrorMessage = 'Check last coupon date!';
elseif (LastCouponDate > Maturity)
     ErrorFlag = 1;
     ErrorMessage = 'Check last coupon date!';
elseif ((StartDate < Settle) | (StartDate > Maturity))
     ErrorFlag = 1;
     ErrorMessage = 'Check start date!';
end


%Check if any fields are empty when the should not be and report an error
%where appropriate
if (isempty(Settle) | isempty(Maturity) | isempty(CouponRate))
     ErrorFlag = 1;
     ErrorMessage = 'Parameters missing!';
end

if (ErrorMessage)
     set(EditErrorMsgHandle, 'String', ErrorMessage);
     drawnow;
else
     %Build output bond structure and pass it back to the GUI
     %Build the main command string                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
     IBond.IssueDate = IssueDate;
     IBond.Settle = Settle;
     IBond.FirstCouponDate = FirstCouponDate;
     IBond.LastCouponDate = LastCouponDate;
     IBond.Maturity = Maturity;
     IBond.StartDate = StartDate;
     IBond.CouponRate = CouponRate;
     IBond.Period = Period;
     IBond.Face = Face;
     IBond.Basis = Basis;
     IBond.EndMonthRule = EndMonthRule;
     IBond.CallType = CallType;
     IBond.CallStartDate = CallStartDate;
     IBond.CallExpiryDate = CallExpiryDate;
     IBond.CallStrike = CallStrike;
     IBond.PutType = PutType;
     IBond.PutStartDate = PutStartDate;
     IBond.PutExpiryDate = PutExpiryDate;
     IBond.PutStrike = PutStrike;
     
     GBONDSPECFLAG = 1;
     GIBOND = IBond;
     
     %Close the bond spec GUI
     close(gcbf);

end



