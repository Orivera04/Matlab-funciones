function [csum, msg] = consumcgmodel(varargin)
% CONSUMCGMODEL CAGE sum model constraint
%
%  CONSUMCGMODEL objects constrain points according to the equation:
%      ---- 
%      \               <=, <
%       |  model(X(i))  or    b
%      /               >=, >
%      ----
%  Dataset row(i)
%
%  CSUM=CONSUMCGMODEL creates an empty CONSUMCGMODEL object
%  CSUM=CONSUMCGMODEL(PMOD, OPPT) creates a CONSUMCGMODEL object where 
%  the dataset for the underlying model to be summed over is pointed 
%  to by OPPT. 
%  CSUM=CONSUMCGMODEL(PMOD, OPPT, WTS) creates a CONSUMCGMODEL object
%  with the weights specified by the column vector, WTS. This 
%  vector must have the same number of rows as the dataset.
%  CSUM=CONSUMCGMODEL(PMOD, OPPT, WTS, BD, BDT) creates a 
%  CONSUMCGMODEL object with the sum bounded either above (BDT = 0)
%  or below (BDT = 1) by BD.
%
%  Class Notes:
%  IMPLEMENTS conxxx interface
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:09 $

if nargin == 1 | nargin == 4
   error('CONSUMCGMODEL::This function requires 0, 2, 3 or 5 inputs');
end

s = struct('modptr', [], 'bound', 0.0, 'bound_type', 0, 'oppoint', [], 'weights', []);
csum = class(s, 'consumcgmodel'); 

if length(varargin) 
   incell{1} = 'modptr';
   incell{2} = varargin{1};
   incell{3} = 'oppoint';
   incell{4} = varargin{2};   
   if length(varargin) > 2
      incell{5} = 'weights';
      incell{6} = varargin{3};
   end
   if length(varargin) > 3
      incell{7} = 'bound';
      incell{8} = varargin{4};
      incell{9} = 'bound_type';
      incell{10} = varargin{5};      
   end  
   [csum,msg]=setparams(csum,incell{:});
else
   msg={};   
end
