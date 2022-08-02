function [Price, PriceTree] = proptbond(IBond, DiscTree, FwdProbDefault, CoupCFlows, AccrCFlows, CallCFlows, PutCFlows) 
%PROPTBOND Value of an Option Embedded Bond Given a Tree of discount Factors
%
% IBond : Bond structure (for face value)
% CoupCFlows [NTimes by 1] : Bond Coupon cash flows at every point
% in the model, including -(accrued interest) at Settlement
% AccrCFlows [NTimes by 1] : Accrued Interest on bond at every point.
% CallCFlows [NTimes by 1] : Call Strikes at every time point (-Inf)
% PutCFlows  [NTimes by 1] : Put Strikes at every time point  ( Inf)
% DiscTree   [NTimes-1 by NTimes-1] : discounts at intervals
% between cash flows.
% FwdProbDefault [NTimes-1 by 1] : Probability of default in interval
%
% Backward Dynamic programming at time step i for value:
% Exercise convention invloves transfering ownership away from the holder
%  1) discount future value to expected value V at time i
%  2) evaluate call struck at K : V = min( V , K+AI )
%  3) evaluate put struck at K    V = max( V , K+AI )
%  4) get coupon payment C      : V = V + C
%  5) multiply by forward prob of default
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Author: C. Bassignani, 04-18-98 
%         J. Akao        05-12-98
%   Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.8 $   $Date: 2002/04/14 21:47:44 $ 

%Check bond structure
IBond = checkbond(IBond);
 
%Unpack input bond structure for Face
Face = IBond.Face;

% find the probablility of not defaulting
P = 1 - FwdProbDefault;
% P = ones(size(FwdProbDefault)); % disable the defaulting here

% Get sizes
NTimes = length(CoupCFlows);
NTree = NTimes - 1;

% storage for the tree of bond prices at each stage
PriceTree = NaN*ones(NTree, NTimes);

%-------------------------------------------------------------------------
% Initial Bond value at all final states
BondValOpt = Face*ones(NTree,1);

% Averaging steps
for jTime = NTimes:-1:3
     iTree = jTime-1; % Time in tree of interval ending at jTime
     iStates = (1:iTree)';

     % evaluate call
     BondValOpt(iStates) = min( BondValOpt(iStates) , ... 
         CallCFlows(jTime) + AccrCFlows(jTime) );
     
     % evaluate put
     BondValOpt(iStates) = max( BondValOpt(iStates) , ...
         PutCFlows(jTime) + AccrCFlows(jTime) );
     
     % coupon payment
     BondValOpt(iStates) = BondValOpt(iStates) + CoupCFlows(jTime);
     
     % record tree
     PriceTree(iStates,jTime) = BondValOpt(iStates);
     
     % discount
     BondValOpt(iStates) = BondValOpt(iStates) .* DiscTree(iStates,iTree);

     % default risk
     BondValOpt(iStates) = P(jTime) * BondValOpt(iStates);
     
     % average over states
     BondValOpt(iStates(1:end-1)) = 0.5* ... 
         ( BondValOpt(iStates(1:end-1)) + BondValOpt(iStates(2:end)) );
     
end

%-------------------------------------------------------------------------
% Remaining discounting and default
jTime = 2;
iTree = 1;
iStates = 1;

% evaluate call
BondValOpt(iStates) = min( BondValOpt(iStates) , ... 
    CallCFlows(jTime) + AccrCFlows(jTime) );

% evaluate put
BondValOpt(iStates) = max( BondValOpt(iStates) , ...
    PutCFlows(jTime) + AccrCFlows(jTime) );
     
% coupon payment
BondValOpt(iStates) = BondValOpt(iStates) + CoupCFlows(jTime);
     
% record tree
PriceTree(iStates,jTime) = BondValOpt(iStates);
     
% discount
BondValOpt(iStates) = BondValOpt(iStates) .* DiscTree(iStates,iTree);

% default risk
BondValOpt(iStates) = P(jTime) * BondValOpt(iStates);
     
%-------------------------------------------------------------------------
% Remaining options and coupon payment (accrued interest owed at settlement)
% There is no discount on this payment nor any probability of default
jTime = 1;
iStates = 1;

% evaluate call
BondValOpt(iStates) = min( BondValOpt(iStates) , ... 
    CallCFlows(jTime) + AccrCFlows(jTime) );

% evaluate put
BondValOpt(iStates) = max( BondValOpt(iStates) , ...
    PutCFlows(jTime) + AccrCFlows(jTime) );
     
% coupon payment
BondValOpt(iStates) = BondValOpt(iStates) + CoupCFlows(jTime);
     
% record tree
PriceTree(iStates,jTime) = BondValOpt(iStates);
     
%-------------------------------------------------------------------------
% read off the price at Settlement
% return the clean price
Price = BondValOpt(iStates) - AccrCFlows(jTime);
     
