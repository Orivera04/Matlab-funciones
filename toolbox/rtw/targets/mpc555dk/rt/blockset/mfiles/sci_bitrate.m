function [SCxBR, achieved] = sci_bitrate(ideal,f)
%SCI_BITRATE calculates bit rate parameters for the Motorola SCI
%   [SCXBR, ACHIEVED] = ASC0_BITRATE(IDEAL, F) calculates the register field
%   SCXBR to give an ACHIEVED bitrate that is the closest approximation to the
%   IDEAL bitrate. The parameter F is the system frequency.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2002/11/13 14:52:35 $

SCxBR_max = 8191;
SCxBR_min = 1;

SCxBR = round(f/(32 * ideal));
SCxBR = max( min( SCxBR_max, SCxBR ), SCxBR_min );

achieved = f / (32 * SCxBR);
