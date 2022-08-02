function wf = allwaves(this)
%ALLWAVES  Collects all @waveform components.

%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:30 $
wf = [this.Responses;this.TestData];

