function im=replacecolor(im, MaskCol, NewCol, Tol)
% REPLACECOLOR  Replace a color in truecolor image with another
%
%   IM=REPLACECOLOR(IM, MASKCOLOR, NEWCOLOR, TOL)
%   IM=REPLACECOLOR(IM, MASKCOLOR, NEWCOLOR)
%   IM=REPLACECOLOR(IM, MASKCOLOR)
%   Replaces the color MASKCOLOR in IM with NEWCOLOR.
%   IM is an X-by-Y-by-3 image matrix.  Explicitly supported data
%   types are double and uint8.  Other types are cast to double.
%
%   MASKCOLOR is an RGB triplet representing the color to replace.
%
%   NEWCOLOR is an RGB triplet representing the new color to insert.
%   If this parameter is ommited, the default uicontrol background color is
%   used.  If IM is of type uint8, the default color will be expressed using
%   elements in the range 0-255.  Otherwise, each element will be in the
%   range 0-1.
%
%   TOL is the tolerance for matching elements in IM to those in MASKCOLOR.
%   Pixels will be altered if all elements satisfy:  abs( MASKCOLOR-IM(X,Y,:) )<TOL.
%   If this parameter is ommited, the value is 0.005 used.
%   If IM is of type uint8, TOL is ignored and all matches must be exact.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.4 $  $Date: 2004/04/04 03:29:32 $

if (nargin<2)
    error('Not enough arguments supplied');
elseif nargin<3
    NewCol=[];
end

if isa(im,'uint8')
    % MaskCol and NewCol must both be of type uint8.
    if ~isa(MaskCol,'uint8')
        MaskCol=uint8(MaskCol);
    end

    if isempty(NewCol)
        % assign a default color to replace with.
        sc = xregGui.SystemColors;
        NewCol=sc.CTRL_BACK;
    elseif ~isa(NewCol,'uint8')
        NewCol=uint8(NewCol);
    end

    % this version of the mex function takes
    % arguments of type uint8.
    im=RepColor8(im,MaskCol,NewCol);
else
    if isempty(NewCol)
        % assign a default color to replace with.
        NewCol=get(0,'defaultuicontrolbackgroundcolor');
    end

    % if the image is not of type double we will have to
    % cast it to double before calling the mex function, and
    % then back to its original type afterwards.
    recast=0;
    if ~isa(im,'double')
        cls=class(im);
        im=double(im);
        recast=1;
    end

    % MaskCol and NewCol must both be of type double.
    if ~isa(MaskCol,'double')
        MaskCol=double(MaskCol);
    end
    if ~isa(NewCol,'double')
        NewCol=double(NewCol);
    end
    % assign a default value to Tol if necessary
    if nargin<4
        Tol=.005;
    end

    % the version of the mex function takes parameters of type
    % double.
    im = RepColor(im,MaskCol,NewCol,Tol);

    % cast the image back to its original type if necessary.
    if recast
        im=feval(cls,im);
    end
end
