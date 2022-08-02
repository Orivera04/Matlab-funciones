% RF Toolbox
% Version 1.0 (R14) 05-May-2004
%
% RF Utility Functions
%
%   ABCD-parameters to ...
%       abcd2h      - Convert ABCD-parameters to H-parameters.
%       abcd2s      - Convert ABCD-parameters to S-parameters.
%       abcd2y      - Convert ABCD-parameters to Y-parameters.
%       abcd2z      - Convert ABCD-parameters to Z-parameters.
%
%   H-parameters to ...
%       h2abcd      - Convert H-parameters to ABCD-parameters.
%       h2s         - Convert H-parameters to S-parameters.
%       h2y         - Convert H-parameters to Y-parameters.
%       h2z         - Convert H-parameters to Z-parameters.
%
%   S-parameters to ...
%       s2abcd      - Convert S-parameters to ABCD-parameters.
%       s2h         - Convert S-parameters to H-parameters.
%       s2y         - Convert S-parameters to Y-parameters.
%       s2z         - Convert S-parameters to Z-parameters.
%       s2t         - Convert S-parameters to T-parameters.
%       t2s         - Convert T-parameters to S-parameters.
%       s2s         - Convert S-parameters to S-parameters.
%
%   Y-parameters to ...
%       y2abcd      - Convert Y-parameters to ABCD-parameters.
%       y2h         - Convert Y-parameters to H-parameters.
%       y2s         - Convert Y-parameters to S-parameters.
%       y2z         - Convert Y-parameters to Z-parameters.
%
%   Z-parameters to ...
%       z2abcd      - Convert Z-parameters to ABCD-parameters.
%       z2h         - Convert Z-parameters to H-parameters.
%       z2s         - Convert Z-parameters to S-parameters.
%       z2y         - Convert Z-parameters to Y-parameters.
%
%   Miscellaneous
%       gammain           - Calculate GammaIn.
%       gammaout          - Calculate GammaOut.
%       vswr              - Calculate VSWR.
%       cascadesparams    - Cascade S-parameters.
%       deembedsparams    - De-embed S-parameters.
%
%   Plot support
%       smithchart        - Draw the Smith chart.
%
% RFDATA objects
%     rfdata.data         - Object for RF data
%
% RFCKT objects
%   General RF Networks
%     rfckt.datafile      - RF network described by a data file
%     rfckt.amplifier     - Amplifier described by a data file
%     rfckt.mixer         - Mixer described by a data file
%     rfckt.cascade       - Cascaded network
%     rfckt.series        - Series connected network
%     rfckt.hybrid        - Hybrid connected network
%     rfckt.parallel      - Parallel connected network
%   Transmission Lines
%     rfckt.txline        - General transmission line
%     rfckt.twowire       - Two-Wire transmission line
%     rfckt.parallelplate - Parallel-Plate transmission line
%     rfckt.coaxial       - Coaxial transmission line
%     rfckt.microstrip    - Microstrip transmission line
%     rfckt.cpw           - Coplanar Waveguide transmission line
%   RLC Circuits
%     rfckt.seriesrlc     - Series RLC Circuit
%     rfckt.shuntrlc      - Shunt RLC Circuit
%   LC Ladder Filters
%     rfckt.lclowpasstee  - LC Lowpass Tee Network
%     rfckt.lclowpasspi   - LC Lowpass Pi Network
%     rfckt.lchighpasstee - LC Highpass Tee Network
%     rfckt.lchighpasspi  - LC Highpass Pi Network
%     rfckt.lcbandpasstee - LC Bandpass Tee Network
%     rfckt.lcbandpasspi  - LC Bandpass Pi Network
%     rfckt.lcbandstoptee - LC Bandstop Tee Network
%     rfckt.lcbandstoppi  - LC Bandstop Pi Network
%
% Graphical User Interfaces
%     rftool              - An RF Analysis GUI.
%
%  See also RFDEMOS, RFDATA, RFCKT

%   Copyright 2004 The MathWorks, Inc.
%   Generated from Contents.m_template revision 1.1.6.8  $Date: 2004/04/20 23:19:48 $
