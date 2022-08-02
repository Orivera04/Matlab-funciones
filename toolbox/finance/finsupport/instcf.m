function varargout = instcf(varargin)
%INSTCF Constructor for the 'Type','CashFlow' instrument.
%
%   To create a new instrument variable from data arrays:
%   ISet = instcf(CFlowAmounts, CFlowDates, Settle, Basis)
%
%   To add 'CashFlow' instruments to an instrument variable:
%   ISet = instcf(ISet, CFlowAmounts, CFlowDates, Settle, Basis)
%
%   To list field meta-data for the 'CashFlow' instrument:
%   [FieldList, ClassList, TypeString] = instcf;
%
%   Inputs: 
%     Data arguments are NINST x MOSTCFS matrices or empty.
%     Only one data argument is required to create the instruments,
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instcf" to see the classes. 
%     Dates can be input as serial date numbers or as date strings.
%
%     CFlowAmounts - NINST x MOSTCFS matrix of cash flow amounts.  Each row
%     is a list of cash flow values for one instrument.  If an instrument
%     has fewer than MOSTCFS cash flows, the end of the row is padded
%     with NaN's.
%
%     CFlowDates - NINST x MOSTCFS matrix of cash flow dates.  Each entry
%     contains the date of the corresponding cash flow in CFlowAmounts. 
%
%     Settle     - Settlement date.
%
%     Basis      - Day-count basis.  Default is 0 (actual/actual).
%
%   Outputs:
%     ISet - Variable containing a collection of instruments.  Instruments
%     are broken down by type and each type can have different data
%     fields.  Each stored data field has a row vector or string for each
%     instrument.  Type "help instget" for more information on the ISet
%     variable. 
%   
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%     data field for this instrument type.
%   
%     ClassList - NFIELDSx1 cell array of strings listing the data class
%     of each field.  The class determines how arguments will be parsed.
%     Valid strings are 'dble', 'date', and 'char'. 
%   
%     TypeString - String specifying the type of instrument added.
%     TypeString = 'CashFlow'.
%
%   See also INSTARGCF, INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.

%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.15 $  $Date: 2002/04/14 21:39:55 $

%---------------------------------------------------------------------
% Checking input arguments
%---------------------------------------------------------------------
if nargin > 1
    if isafin(varargin{1},'Instruments')
        NargNum = 2;
    else
        NargNum = 1;
    end
    DateInd = NargNum+1;
    
    if nargin > NargNum & iscell(varargin{DateInd})
        EDates  = varargin{DateInd};
        InSize  = size(EDates);
        EDates = EDates(:);
        StrMask = cellfun('isclass', EDates, 'char');
        EDates(~StrMask) = {'01/01/2000'}; % Placeholder
        EDates = datenum(EDates);
        EDates(~StrMask) = NaN;
        varargin{DateInd} = reshape(EDates, InSize);
    end
end

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'CashFlow';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
  'CFlowAmounts'   , 'dble' , [Inf Inf] , [NaN] ;
  'CFlowDates'     , 'date' , [Inf Inf] , [NaN] ;
  'Settle'         , 'date' , [1 1]     , [NaN] ;
  'Basis'          , 'dble' , [Inf 1]   , [0]  };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return
