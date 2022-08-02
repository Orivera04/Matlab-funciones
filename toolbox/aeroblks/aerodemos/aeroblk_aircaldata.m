% AEROBLK_AIRCALDATA contains the airspeed calibration data for 
% aeroblk_indicated.mdl and aeroblk_calibrated.mdl

% Cessna 150M airspeed calibration table
% flaps   KIAS    KCAS
% (deg)  (kts)   (kts)
%   0      40      43
%          50      51
%          60      59
%          70      68
%          80      77
%          90      87
%         100      98
%         110     108
%         120     118
%         130     129
%         140     140
%         
%  10      40      42
%          50      50
%          60      60
%          70      69
%          80      78
%          85      82
%          
%  40      40      40
%          50      50
%          60      61
%          70      72
%          80      83
%          85      89         
%          
%         
% Data is from "Pilot's Operating Handbook, Cessna 1976 150 Commuter, Cessna 
%               Model 150M", Cessna Aircraft Company, Wichita, Kansas, USA, 1976.       
%          

%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2002/11/07 20:59:02 $

flaps0IAS = 40:10:140;
flaps0CAS = [43 51 59 68 77 87 98 108 118 129 140];

flaps10n40IAS = [40:10:80 85];
flaps10CAS = [42 50 60 69 78 82];
flaps40CAS = [40 50 61 72 83 89];