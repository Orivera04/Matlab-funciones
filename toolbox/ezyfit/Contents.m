% EzyFit Toolbox
% Version 2.30 05-Fev-2009
% F. Moisy
%
% Curve Fitting
%   ezfit        - Fit data with arbitrary fitting function
%   showfit      - Show the fit for the active curve.
%   efmenu       - Ezyfit menu
%   plotsample   - Display a sample plot.
%   undofit      - Remove the last fit from the current figure
%   rmfit        - Remove fits from the current figure
%   fitparam     - Default settings for the EzyFit toolbox
%
% Curve fitting "by eye"
%   getslope     - Slope of the current line.
%   showslope    - Draw a line with fixed slope
%
% Curve Fitting Tools
%   editcoeff    - Edit the coefficients of a fit
%   makevarfit   - Create variables from the parameters of a fit
%   evalfit      - Evaluate a fit
%   showresidual - Show the residuals of a fit
%   editfit      - Edit a user defined fit
%   loadfit      - Load the predefined and the user-defined fitting functions.
%   dispeqfit    - Display the equation of a fit.
%   showeqbox    - Show the equation box of a fit.
%
% Miscellaneous
%   ezfft        - Power spectrum
%   pickdata     - Picks data from the active curve.
%   myginput     - Graphical input from mouse.
%   about_ef     - display the "About" information of the EzyFit toolbox
%   checkupdate_ef - check for update of the EzyFit toolbox
%
% Quick change of the axis scales
%   linx         - Turn the X axis to LIN
%   liny         - Turn the Y axis to LIN
%   logx         - Turn the X axis to LOG
%   logy         - Turn the Y axis to LOG
%   swx          - LIN<->LOG swap of the X axis
%   swy          - LIN<->LOG swap of the Y axis
%   sw           - LIN<->LOG swap of the X and Y axis
%
% Some useful plot tools
%   dfig         - Create a docked figure window
%   gridc        - Centered cross grid
%   axisc        - Centered axis
%   axis0        - Include the origin in the axis
%   axisl        - Include the nearest power of 10 in the axis of a log plot
%   loglogpn     - Log-log scale plot for positive and negative data
%   semilogypn   - Semilogarithmic  plot for positive and negative data
