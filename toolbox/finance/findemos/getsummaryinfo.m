function infoCellArray = getsummaryinfo(control)
%GETSUMMARYINFO Get summary GA information.
%   INFODATA = GETSUMMARYINFO(CONTROL) gather and format the text information 
%   for a selected line object. CONTROL is a control structure summarizing
%   parameter inputs and some output results of a differential evolutionary GA 
%   run. INFODATA is a cell array that contains the summary information (i.e., 
%   input control parameters and convergence criteria) as a selected line 
%   object's 'UserData' field. When the user clicks on a line object, a text 
%   object is created to display the contents of INFOCELLARRAY; the text is 
%   displayed inside a patch object that, for appearances, simply frames the 
%   text so grid lines don't show through (the patch object just makes it look 
%   better, and makes the text easier to read). When the user releases the 
%   mouse button, the text and patch is deleted.
%
%   See also DEGATOOL, DISPLAYSUMMARYINFO, DEGADEMO, RUNBUTTONCALLBACK.

% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:45:28 $

if control.convergenceFlag

   infoCellArray = [' Convergence on generation number ' num2str(control.generation) '. '];

else

   infoCellArray = [' No convergence: DE stopped at generation ' num2str(control.generation) '. '];

end

infoCellArray =  strvcat(' '                                                                 , ...
                 infoCellArray                                                               , ...
                 ['   Population members (NP) = ' num2str(control.nPopulationMembers)]       , ...
                 [' Mutation scale factor (F) = ' num2str(control.F)]                        , ...
                 ['   Crossover constant (CR) = ' num2str(control.CR)]                       , ...
                 ['     Convergence tolerance = ' num2str(control.similarityToleranceLimit)] , ...
                  ' ');
