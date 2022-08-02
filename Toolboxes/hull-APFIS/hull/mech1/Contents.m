% Mastering Mechanics I Toolbox.
% Version 1.00 01-Mar-1998
%
% Details are to be found in Mastering Mechanics I, Douglas W. Hull,
% Prentice Hall, 1998
%
% Douglas W. Hull, 1998
% Copyright (c) 1998-99 by Prentice Hall
% Version 1.00
%
% General purpose.
%   cols         - Counts the number of columns in a matrix.
%   DR           - Converts degrees to radians.
%   interpolate  - Linear interpolation for a given value.
%   ispos        - True for positive numbers.
%   RD           - Converts radians to degrees.
%   rows         - Counts the number of rows in a matrix.
%
% Geometry.
%   findangle    - Finds unknown angles of a triangle.
%   hyp          - Finds the hypotenous of a right triangle.
%   leg          - Finds the leg length of a right triangle.
%
% General plotting.
%   expandaxis   - Extends the current axis in any or all directions.
%   showcirc     - Draws a circle on the current axis.
%   showrect     - Draws a  rectangle on the current axis.
%   showvect     - Draws a simple diagram showing the input vectors.
%   showx        - Draws a line across the current axis.
%   showy        - Draws a line across the current axis.
%   titleblock   - Adds two columns of text within the axis border.
%
% Vector manipulation.
%   deg2xy       - Converts vectors in degree angles to standard form.
%   dist2x       - Converts a distributed load to a force acting in the X.
%   dist2y       - Converts a distributed load to a force acting in the Y.
%   distload     - Converts a linearly distributed load to a point force.
%   mag          - Returns the magnitude of a vector.
%   move         - Changes the coordintes of a vector.
%   opp          - Returns the equal but opposite vector
%   rad2xy       - Convert vectors in radian angles to standard form.
%   rise2xy      - Converts vectors in rise-run format to standard form.
%   xy2deg       - Converts vectors in standard form to degree angle form.
%   xy2rad       - Converts vectors in standard form to radian angle form.
%
% Statics.
%   breakup      - Breaks a standard form force vector into its components.
%   onevector    - Negative of sum of forces acting at a point.
%   reaction     - Reaction force and moment needed to balance a force.
%   sumforce     - Sums a set of vectors into one force vector and a couple.
%   summoment    - Solves for the moment caused by a set of forces.
%   threevector  - Solves for three force vectors of known direction only.
%   twovector    - Solves for two force vectors of known direction only.
%
% Shapes.
%   channel      - U-shape shape routine.
%   circle       - Circle shape routine.
%   comp         - Composite shape routine.
%   halfcircle   - Semi-circle shape routine.
%   hortrap      - Horizontal trapazoid shape routine.
%   hortria      - Horizontal triangle shape routine.
%   ibeam        - I-beam shape routine.
%   lbeam        - L-beam shape routine.
%   obeam        - Circular tube shape routine.
%   quartercircle- Quarter circle shape routine.
%   rectangl     - Rectangular shape routine. (note spelling)
%   rectube      - Rectangular tube shape routine.
%   tbeam        - T-beam shape routine.
%   vertrap      - Horizontal trapazoid shape routine.
%   vertria      - Horizontal triangle shape routine.
%
% Stress.
%   mohrs        - Draws a Mohr's circle.
%   ppstress     - The principle planes of a stress state.
%   pristress    - Principal stresses.
%   stress2strain- Converts stress to strain.
%   stresstr     - Stress rotation.
%
% Strain.
%   mohrs2       - Draws a Mohr's circle.
%   ppstrain     - The principle planes of a strain state.
%   pristrain    - Principal strains.
%   rosette      - Converts strain gauge readings to strain state.
%   strain2stress- Converts strain to stress.
%   straintr     - Stress rotation.
%
% Material properties.
%   matprop      - Material properties look up.
%
% Diagrams and Displacement.
%   diagram      - Creates vectors for use in ploting of diagrams.
%   diagramintegral- Integral of the given numerical data.
%   displace     - Displacement of a beam.
%   fixedfixed   - Redundant support moments and forces.
%   fixedpin     - Redundant support moments and forces.
%   pinpin       - Redundant support forces.
%   plotSMD      - Plots a Shear Moment and optional Displacement diagram.
%   plotSMSD     - Plots a Shear, Moment, Slope and Displacement diagram.
