function initialize(this,Axes)
% Initializes @paramview graphics.

%  Author(s): Bora Eryilmaz, John Glass
%  Revised  : Kamesh Subbarao
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:32 $

% (Axes = HG axes to which curves are plotted)
Np = size(Axes,1);
Curves = cell(Np,1);
for ct=1:Np
   Curves{ct} = line('XData', NaN, 'YData', NaN, ...
      'Parent',  Axes(ct), 'Visible', 'off');
end
this.Curves = Curves;
