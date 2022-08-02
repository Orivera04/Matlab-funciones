function [ChkBond, DefBond] = bondstand(AugFlag)
%BONDSTAND Bond Structure Standards for Default Setting/Argument Checking
%
%Summary: This function returns two structures, one of which contains the
%         standard ranges or list of possible values against which the
%         fields of an input bond structure can be evaluated. The other
%         structure contains the default values for the input structure.
%
% Inputs: AugFlag - scalar flag specifying the sets of field to be returned
%              as part of the check and default bond structures; posssible
%              flag values (and their corresponding sets of fields) include:
%              AugFlag = 0 - basic bond structure containing the
%                   following fields:
%                   1) IssueDate
%                   2) Settle
%                   3) Maturity
%                   4) CouponRate
%                   5) Face
%                   6) Period
%                   7) Basis
%                   8) EndMonthRule
%              AugFlag = 1 (default) - augmented bond structure
%                   containing the above fields and the following
%                   additional fields which pertain to embedded options:
%                   9) CallType
%                  10) CallStartDate
%                  11) CallExpiryDate
%                  12) CallStrike
%                  13) PutType
%                  14) PutStartDate
%                  15) PutExpiryDate
%
%   Note: For a detailed explanation of each of these fields, at the
%         command line type 'help' followed by 'fin' plus the field name
%         (e.g. 'help finbasis').
%
%Outputs: ChkBond - 1x1 structure array whose fields contain either the 
%              range within which an input paramter must fall, or a discrete
%              list of possible values for that paramter. Lists of possible
%              values for a single paramter are arranged as row vectors.
%         DefBond - 1x1 structure array whose fields contain the default
%              values for an input parameter. If not default exists, the
%              field is left empty.
%
%See Also: CHECKBOND

%Author: C. Bassignani, 01-27-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:52:15 $ 



%Parse the augmented matrix flag
if ((nargin < 1) | (isempty(AugFlag)))
     AugFlag = logical(1);
end

if (isstr(AugFlag))
     error('Augmented matrix flag must be numeric!');
end

if (max(size(AugFlag)) > 1)
     error('Augmented matrix flag must be a scalar value!');
elseif (~isempty(find(AugFlag ~= 0 & AugFlag ~= 1)))
     error('Augmented matrix flag must be 0 or 1')
end


%Specify the possible values for each field if any limitations exist

%Note: The use of negative infinity as the first element in any row vector
%containing EXACTLY three elements denotes the fact the the two remaining
%elements constitute a range of possible values NOT a discrete list.

%Define the check bond structure

%Base parameters
ChkBond.IssueDate = [];
ChkBond.Settle = [];
ChkBond.FirstCouponDate = [];
ChkBond.LastCouponDate = [];
ChkBond.Maturity = [];
ChkBond.StartDate = [];
ChkBond.CouponRate = [-inf 0 1];
ChkBond.Period = [0 1 2 3 4 6 12];
ChkBond.Face = [-inf 0 inf];
ChkBond.Basis = [0 1 2 3];
ChkBond.EndMonthRule = [0 1];


%Specify the defaults for each field if any exist
DefBond.IssueDate = [];
DefBond.Settle = [];
DefBond.FirstCouponDate = [];
DefBond.LastCouponDate = [];
DefBond.Maturity = [];
DefBond.StartDate = [];
DefBond.CouponRate = 0;
DefBond.Period = 2;
DefBond.Face = 100;
DefBond.Basis = 0;
DefBond.EndMonthRule = 1;


%Check to see if an augmented structure has been requested
if (AugFlag)
     %Option parameter checks
     ChkBond.OptionFlag = [0 1];
     
     %Call parameter checks
     ChkBond.CallType = [0 1];
     ChkBond.CallStartDate = [];
     ChkBond.CallExpiryDate = [];
     ChkBond.CallStrike = [-inf 0 inf];

     %Put parameter checks
     ChkBond.PutType = [0 1];
     ChkBond.PutStartDate = [];
     ChkBond.PutExpiryDate = [];
     ChkBond.PutStrike = [-inf 0 inf];
     
     %Option parameter defaults
     DefBond.OptionFlag = 0;
     
     %Call parameter defaults
     DefBond.CallType = [];
     DefBond.CallStartDate = [];
     DefBond.CallExpiryDate = [];
     DefBond.CallStrike = [];

     %Put parameter defaults
     DefBond.PutType = [];
     DefBond.PutStartDate = [];
     DefBond.PutExpiryDate = [];
     DefBond.PutStrike = [];
end
