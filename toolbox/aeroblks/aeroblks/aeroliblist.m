function libs = aeroliblist
% AEROLIBLIST Return list of Aerospace libraries.
%

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.2.3 $ $Date: 2003/07/11 15:49:47 $


% Aerospace Blockset Version 1.5:
libs.aero11 = {'aerolib3dof2','aerolib6dof2',...
             'aerolib3dofsys','aerolib6dofsys',...
             'aerolibactuator','aerolibadyn','aerolibanim', ...
             'aerolibasang','aerolibatmos2','aerolibbdyn', ...
             'aerolibconvert','aerolibgravity2','aerolibguid', ...
             'aerolibpropulsion2','aerolibschedule', ...
             'aerolibtransform2','aerolibutil', ...
             'aerolibwind2','aerolibwindfilters'};

% Aerospace Blockset Version 1:
libs.aero1 = {'aerolib3dof','aerolib6dof',...
             'aerolibactuator','aerolibanim', ...
             'aerolibatmos','aerolibconvert', ...
             'aerolibgravity','aerolibpropulsion', ...
             'aerolibschedule','aerolibtransform', ...
             'aerolibwind'};

% [EOF] aeroliblist.m
