function [CFAmounts, CFDates, Settle, Basis] = instargcf(varargin)
%INSTARGCF Subroutine for 'Type','CashFlow' argument validation.  
%   This function is called at the top of processing routines.
%
%   [CFlowAmounts, CFlowDates, Settle, Basis] = instargcf(Arglist{:})
%
%   Inputs: 
%     Arglist{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     Outputs are conforming NINST x MOSTCFS matrices.
%
%     CFlowAmounts - NINST x MOSTCFS matrix of cash flow amounts.  Each row
%     is a list of cash flow values for one instrument.  If an instrument
%     has fewer than MOSTCFS cash flows, the end of the row is padded
%     with NaN's.
%
%     CFlowDates - NINST x MOSTCFS matrix of cash flow dates.  Each entry
%     contains the serial date of the corresponding cash flow in
%     CFlowAmounts. 
%
%     Settle - Settlement date.
%
%     Basis - Day-count basis.  The default is 0 (actual/actual).
%
%   See also INSTCF.

%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:39:34 $

% get the argument information for the cash flow instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instcf;

% Check the number of arguments, 1 to 3
if nargin<3,
  error('CFlowAmounts, CFlowDates, and Settle are required');
elseif nargin>4
  error('Too many input arguments');
else
  EndArgs = cell(1,4-nargin);
end

% Parse for type 
[CFAmounts, CFDates, Settle, Basis] = ...
    finargparse(ClassList, varargin{:}, EndArgs{:});

% Enforce size limits if possible by transposing 
%[CFAmounts, CFDates, CFTimes] = ... 
%    finargflip(SizeList, CFAmounts,CFDates, CFTimes);

% perform row expansion along the instruments
[CFAmounts, CFDates, Settle, Basis] = ...
   finargsz(1,CFAmounts,CFDates, Settle, Basis);

% perform column expansion by nan-padding
NumCFs = [size(CFAmounts,2); size(CFDates,2)];
MostCFs = max( NumCFs );
NumInst = size(CFAmounts,1);

if NumCFs(1) < MostCFs
  CFAmounts = [CFAmounts, NaN*ones(NumInst,MostCFs - NumCFs(1))];
end
if NumCFs(2)<MostCFs
  CFDates =   [CFDates,   NaN*ones(NumInst,MostCFs-NumCFs(2))];
end

% Fill in defaults for all-NaN rows
Ind = all( isnan(CFDates) , 2 );
Row = (0:MostCFs-1);
CFDates(Ind,:) = Row(ones(sum(Ind),1),:);

% Check for conformance between cash flows
if any(any( isnan(CFAmounts) ~= isnan(CFDates) ))
  CFAmounts
  CFDates
  error('Cash flow mismatch between CFlowAmounts and CFlowDates');
end
