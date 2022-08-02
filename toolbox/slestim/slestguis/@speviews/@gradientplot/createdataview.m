function [data, view, dataprops] = createdataview(this, varargin)
% Abstract Factory method to create @data and @view "product" 
% objects to be associated with a @waveform "client" object.

%   Author(s): Bora Eryilmaz
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:08 $

% Create data object
data = speviews.paramdata;

% Create view object
view = speviews.gradientview;
view.AxesGrid = this.AxesGrid;

% Return list of data-related properties of data object
dataprops = [data.findprop('Iterations'); data.findprop('Values')];
