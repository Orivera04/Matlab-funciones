function [out] = getstages(bdev)
%GETSTAGES The stages of the model that this boundary dev object is for
%
%   GETSTAGES(BR) is the number of stages for the boudray tree node object
%   BR. 
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:13:06 $ 

% xregbdrydev objects hande the response feature
p = Parent( bdev );
if isempty( p ),
    out = 0;
else
    out = p.getstages;
end
