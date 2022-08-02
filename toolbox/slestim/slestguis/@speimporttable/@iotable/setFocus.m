function setFocus(h)
%SETFOCUS
%
%   Authors: James G. Owen
%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/12/04 02:39:30 $

import com.mathworks.toolbox.control.spreadsheet.*;
import javax.swing.*;

% Brings the gui to the front - jgo

rw = MLthread(h.Explorer, 'setVisible',{true});
SwingUtilities.invokeLater(rw);