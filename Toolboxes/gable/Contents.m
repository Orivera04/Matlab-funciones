% GABLE is a Matlab toolkit for geometric algebra.
%
% Documentation on GABLE is available at
%    http://www.wins.uva.nl/~leo/clifford/gable.html
%    http://www.cgl.uwaterloo.ca/~smann/gable.html
%  
% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%    All rights for commercial use reserved; for more information
%    contact Leo Dorst (leo@wins.uva.nl).
%
%    This software is unsupported.
%=====================================================================
%
% Elements
%  The standard basis elements of the geometric algebra are e1,e2,e3.
%  I3 represents the trivector e1^e2^e3.
%
% Operations
%  You can use the operations +, -, *, ^, ==, ~= on multivectors.
%    dual             - Computes the dual of a multivector
%    gexp             - Computes the geometric product exponential
%    grade            - Find/return the grade of a blade
%    inner            - Compute the inner product
%    inverse          - Compute the inverse of a multivector
%    isGrade          - Test if a multivector is of a particular grade
%    join             - Join two blades
%    meet             - Meet two blades
%    norm             - Returns the norm of a multivector
%    sLog             - Computes the geometric logarithm of a spinor
%    unit             - Return the unit blade
%
% Demonstrations
%    GAdemo           - A simple demo of the algebra
%    GAblock          - Run sample code in tutorial
%
% Graphics Routines
%    draw             - Basic drawing routine
%    DrawBivector     - Draw a bivector as a parallelogram
%    DrawGP           - Draw the geometric product A*B.
%    DrawInner        - Draw the inner product
%    DrawOuter        - Draw the outer product
%    DrawTrivector    - Draw a trivector as a parallelepiped
%    DrawHomogeneous  - Draw a simplex
%    DrawPoint        - Draw a point
%    DrawPolygon      - Draw a polygon
%    DrawPolyline     - Draw a polyline
%    DrawSimplex      - Draw a simplex
%    GAbvShape        - Query/set the rendered shape of bivectors
%    GAorbit          - Rotate the view
%    GAorbiter        - Rotate the view
%    GArender         - Query/set the rendering method
%    GAtext           - Draw text at the tip of a vector
%    GAview           - Change the view
%    drawall          - Draw the objects created by geoall
%
% Frames
%    Frame            - Create a frame
%    FE               - Extract a frame element
%    OFrame           - Set the output frame
%
% Advanced
%    bilinear         - Compute the bilinear form of two multivectors
%    blade            - Convert a multivector into a blade
%    conjugate        - Compute the Clifford Conjugate
%    connection       - Compute the translational moment.
%    contraction      - Lounesto inner product
%    innerH           - Hestenes inner product
%    innerS           - Modified Hestenes inner product
%    geoall           - Compute all the geometric relations between blades
%    GAs              - Convert a double into a GA object
%    GAitype          - Set the type of inner product
%    GAsignature      - Query/set the signature
%    GAversion        - return the version number of GABLE
%    GAautoscalar     - Query/set autoconversion to scalars
%    gazv             - set small terms to zero, giving warning
%    GAZ              - set small terms to zero, no warning
