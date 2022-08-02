function names = InputSignalNames(mdev);
%INPUTSIGNALNAMES names of the signals into the model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:31:43 $

m = model(mdev);
names = factorNames(m);
