% Geometry Toolbox
% Version 0.1 - 2005, March 04.
%
%   Creation, transformations, algorithms and visualization of geometrical
%   3D primitives, such as points, lines, planes, polyhedra, circles and
%   spheres.
%   
%   - Angles are defined as follow :
%   THETA is the colatitude, the angle with the Oz axis
%   PHI is the angle of the projection on horizontal plane with the Ox axis
%   PSI is the 'roll', i.e. the rotation around the (THETA, PHI) direction
%
%   Base format for primitives :
%   Points : [x0 y0 z0]
%   Lines :  [x0 y0 z0 dx dy dz]
%   Edges :  [x1 y1 z1 x2 y2 z2]
%   Planes : [x0 y0 z0 dx1 dy1 dz1 dx2 dy2 dz2]
%   Sphere : [x0 y0 z0 R]
%   Circle : [x0 y0 z0 R PHI THETA PSI] (origin+center+normal+'roll').
%   
%   Polyedra : {N, E, F}
%     with N = [x1 y1 z1; ... ; xn yn zn];
%          E is a [Ne*2] array containing references to ending nodes
%          F is either a [Nf*3] or [Nf*4] array containing reference for
%          vertices of each face, or a [Nf*1] cell array, where each cell
%          is an array containing a variable number of node indices.
%
%
% Primitives creation:
% ---------------------
%   createLine3d             - create a line with various inputs.
%   medianPlane              - create a plane in the middle of 2 points
%   createPlane              - create a plane in parametrized form
%   createSphere             - create a sphere containing 4 points
%   revolutionSurface        - create a surface of revolution from a planar curve
%   randomAngle3d            - return a 3D angle uniformly distributed on unit sphere
%
% Operations on shapes:
% ----------------------
%   intersectLineSphere      - return intersection between a line and a sphere
%   intersectPlaneLine       - return intersection between a plane and a line
%   intersectPlanes          - return intersection between 2 planes in space
%   intersectPlaneSphere     - return intersection between a plane and a sphere
%   circle3dOrigin           - return the first point of a 3D circle
%   clipPolygon3dPlane       - clip a 3D polygon with Half-space
%   clipConvexPolygon3dPlane - clipConvexPolygon3dPlane clip a convex 3D polygon with Half-space
%   isBelowPlane             - test whether a point is below or above a plane
%   isCoplanar               - Tests input points for coplanarity in 3-space.
%   normalizePlane           - normalize parametric form of a plane
%   projPointOnPlane         - return the projection of a point on a plane
%   transformPoint3d         - transform a point with a 3D affine transform
%   normalize3d              - normalize a 3D vector
%
% Create polyhedra:
% ------------------
%   createCube               - create a 3D cube
%   createCubeOctahedron     - create a cube-octahedron
%   createIcosahedron        - create an Icosahedron.
%   createOctahedron         - create an octahedron
%   createRhombododecahedron - create a 3D rhombododecahedron
%   createTetrahedron        - create a tetrahedron  with 4 vertices and faces
%   createTetrakaidecahedron - create a tetrakaidecahedron
%   createSoccerBall         - return a soccerball as a polyhedra
%   minConvexHull            - return the unique minimal convex hull in 3D
%   steinerPolytope          - Create a steiner polytope from a set of vectors
%
% Measurements:
% --------------
%   circle3dPosition         - return the angular position of a point on a 3D circle
%   distancePointLine3d      - compute euclidean distance between 3D point and line
%   distancePointPlane       - compute euclidean distance betwen 3D point and plane
%   distancePoints3d         - compute euclidean distance between 3D Points
%   planeNormal              - compute the normal to a plane
%   linePosition3d           - return position of a 3D point on a 3D line
%   planePosition            - compute position of a point on a plane
%   vecnorm3d                - compute norm of vector or of set of 3D vectors
%   faceNormal               - compute normal vector of a polyhedron face
%
% Angle computations :
% --------------------
%   anglePoints3d            - compute angle between 2 3D points
%   dihedralAngle            - compute dihedral angle between 2 planes
%   sphericalAngle           - compute angle on the sphere
%   angleSort3d              - sort 3D coplanar points according to their angles in plane
%   polygon3dNormalAngle     - compute normal angle at a vertex of the 3D polygon
%   polyhedronNormalAngle    - compute normal angle at a vertex of a 3D polyhedron
%
% Tests on vectors:
% --------------
%   isParallel3d             - check parallelism of two vectors
%   isPerpendicular3d        - check orthogonality of two vectors
%
% Coordinate transforms :
% -----------------------
%   sph2cart2                - convert spherical coordinate to cartesian coordinate
%   cart2sph2                - convert cartesian 2 spherical coordinate
%   cart2cyl                 - Convert cartesian to cylindrical coordinates
%   cyl2cart                 - Convert cylindrical to cartesian coordinates
%
% Draw Functions :
% ----------------
%   drawCircle3d             - draw a 3D circle
%   drawCircleArc3d          - draw a 3D circle arc
%   drawCurve3d              - draw a 3D curve specified by a list of points
%   drawCylinder             - draw a cylinder
%   drawEdge3d               - draw the edge in the current Window
%   drawLine3d               - draw the line in the current Window
%   drawPlane3d              - draw a plane clipped in the current window
%   drawPoint3d              - draw 3D point on the current axis.
%   drawPolyhedra            - draw polyhedra defined by vertices and faces
%   drawSphere               - draw a sphere as a mesh
%   drawSphericalTriangle    - draw a triangle on a sphere
%   drawSurfPatch            - draw surface patch, with 2 parametrized surfaces
%   drawGrid3d               - draw a grid in 3 dimensions
%   fillPolygon3d            - fill a 3D polygon specified by a list of points
%
% Geometric transforms :
% ----------------------
%   translation3d            - return 4x4 matrix of a 3D translation
%   rotationOx               - return 4x4 matrix of a rotation around x-axis
%   rotationOy               - return 4x4 matrix of a rotation around y-axis
%   rotationOz               - return 4x4 matrix of a rotation around z-axis
%   scale3d                  - return 4x4 matrix of a 3D scaling
%   composeTransforms3d      - concatenate several space transformations
%
%
%   Credits:
%   * function isCoplanar was originally written by Brett Shoelson.
%   * Songbai Ji enhanced file intersectPlaneLine (6/23/2006).
%
%   ------
%   Author: David Legland
%   e-mail: david.legland@jouy.inra.fr
%   Created: 2005-11-07
%   Copyright 2005 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas).
%   Licensed under the terms of the LGPL, see the file "license.txt'

