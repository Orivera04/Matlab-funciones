function TrueFalse= ne(U1,U2)
%NE

%  Copyright 2000-2004 The MathWorks, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:43:42 $

%JUNIT/NEQ  Tests if two junit-s, UnitA and UnitB, are not equal.
%
%   TrueFalse = NE(UnitA, UnitB) tests if two junit-s, UnitA and UnitB
%   are not equal.
%
%   See also ==, NE.

% ---------------------------------------------------------------------------
% Description : Method to test if UnitA and UnitB are not equal.
% Inputs      : UnitA     - junit object (junit)
%               UnitB     - junit object (junit)
% Outputs     : TrueFalse - UnitA ~= UnitB? (0 or 1)
% ---------------------------------------------------------------------------

TrueFalse = ~(U1==U2);