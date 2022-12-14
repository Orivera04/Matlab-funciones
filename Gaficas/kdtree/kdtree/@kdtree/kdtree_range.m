% FUNCTION [idx,pnts] = kdtree_range(kdtree, range)
%
% AUTHOR:     Steven Michael
%             (smichael@ll.mit.edu)
%
% DATE:       2/17/05
%
% DESCRIPTION:
%
%  This function simply returns all the points of a kdtree that
%  are within an N-dimesional volume bounded by "range"
%
% INPUTS:
%
%   kdtree :    A KD Tree previously created with kdtree_create
%
%
%   range  :    An array (ndim X 2) of points that specify the bounds
%               of an "ndim" dimensional volume.  All the points of the
%               kdtree within this volume will be returned.
%               The range is boundary inclusive: [min,max]
%
%               Alternatively, range can be a (nsearches X ndim X 2)
%               array of points that describes multiple range boxes
%               -- the "nsearches" index references the range box.  The
%               output in this case will be put into "nsearches"
%               different cell arrays.
% 
%
% OUTPUTS:
%
%   idx    :    A (1 X N) array of points, where N is the number of
%               points within the "ndim" dimensional volume. The value is
%               the index to the releavant point in the array from which
%               the tree was created.
%
%               If multiple range boxes are searches (a 3D array is input
%               for range), then "pnt" will be a cell array, where the
%               "nth" cell contains a (1XN) array of points ; N is the
%               number of points within the "ndim" dimensional volume 
%               described by the "nth" index of the range input.
%
%
%   pnts:  :    A (N X ndim) array the actual points. If the actual point
%               instead of the index is desired, an optional second output
%               will hold the points.  Multiple range boxes are handled
%               as described above.
%

