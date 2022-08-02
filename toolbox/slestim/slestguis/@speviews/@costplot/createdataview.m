function [data, view, dataprops] = createdataview(this, Nresp)
% CREATEDATAVIEW  Abstract Factory method to create @data and @view "product"
% objects to be associated with a @waveform "client" object.

%   Author(s): Bora Eryilmaz
%   Copyright 1986-2002 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $ $Date: 2004/04/16 22:20:46 $

% Create data object
data = speviews.costdata;

% Create view objects
view = speviews.costview;
view.AxesGrid = this.AxesGrid;

% Return list of data-related properties of data object
dataprops = [data.findprop('Time'); data.findprop('Amplitude')];
