function data = getdata( bdev, var, docode )
%GETDATA Get the modeling data from boundary constraint model node.
%
%  DATA = GETDATA(BDEV) is the data that is valid for the boundary modeling
%  at the given model node.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:13:05 $ 

%% function [data] = getdata( bdev )
% p = parent( bdev );
% if isempty( p ),
%     data = [];
% else
%     data = p.getdata;
% end

% Should the version below only be avialble fro xregtwostagebdrydev
% objects?

%    Stages = 0 (Response) double array of all data points
%    Stages = 1 (Local) sweepset of local and global data
%    Stages = 2 (Global) double array of global data points

if nargin < 2 
    var= [];;
end
if nargin<3
    docode= true;
end


p= Parent(bdev);
if ~isempty(var) && ~ischar( var ) 
    switch var,
        case 0,
            var = 'Response';
        case 1,
            var = 'Local';
        case 2,
            var = 'Global';
    end
end
data = p.getdata( var, docode);
