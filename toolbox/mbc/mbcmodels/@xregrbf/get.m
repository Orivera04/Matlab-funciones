function Value = get(r, Property, varargin);
%XREGRBF/GET   Get RBF object properties.
%   GET(M,'PropertyName') returns the value of the specified property for
%   the RBF model M. GET(M) returns a list of GET'able properties for
%   XREGRBF objects.
%
%   Properties:
%     Centers - centers;
%     Width   - rbf width 
%     Weights - rbf weights;
%     Cont    - continuity (only used for Wendland)
%   Also, can get any properties inherited from the parent XREGLINEAR
%   object.
%
%   See also XREGLINEAR/GET.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 07:54:41 $

if nargin == 1
    Value = [{'centers','width','kernel','cont'}'; get(r.xreglinear)];
else
    switch lower(Property)
        case 'centers'
            Value=r.centers;    
        case 'width'
            Value = r.width;  
        case 'kernel'
            Value = func2str(r.kernel);
        case 'cont'
            Value = r.cont;
        otherwise
            try
                Value=get(r.xreglinear,Property);
            catch
                error('RBF/GET invalid property');
            end
    end   
end
