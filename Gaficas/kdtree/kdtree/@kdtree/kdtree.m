% FUNCTION kdtree = kdtree_create(points)
%
% AUTHOR:     Steven Michael
%             (smichael@ll.mit.edu)
%
% DATE:       2/17/05
%
% DESCRIPTION:
%
%  This function creates a KD Tree from the given points
%  and outputs it in the abstract object "kdtree"
%  The "kdtree" object can then be used for range finding
%  and nearest neighbor searching.
%
% INPUTS:
%
%   points   :     A (npoints X ndim) array of points, where "npoints"
%                  is the number of points and "ndim" is the number
%                  of dimensions.  Note that the points, even if they
%                  are double precision, will be converted to single
%                  precision when the tree is populated.  This is for 
%                  speed -- most kdtree search applications don't
%                  necessitate double precision data.
%
% OUTPUTS:
%
%   kdtree   :     The abstract KD Tree object.
%
%
