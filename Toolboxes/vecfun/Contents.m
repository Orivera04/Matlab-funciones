% Vector Analysis Toolbox
% Version 1.8 25-Nov-2002
%  Copyright (c) 2001-08-25 - 2002-11-25, B. Rasmus Anthin.
%
% What's new.
%   readme_vecfun.txt - New features, bug fixes, and changes in this version.
%
% Common arithmetic operators.
%   plus       - Plus                      +
%   uplus      - Unary plus                +
%   minus      - Minus                     -
%   uminus     - Unary minus               -
%   mtimes     - Multiply                  *
%   mpower     - Power                     ^
%   mrdivide   - Divide                    /
%
% Common relational operators.
%   eq         - Equal                    ==
%   ne         - Not equal                ~=
%   lt         - Less than                 <
%   gt         - Greater than              >
%   le         - Less than or equal       <=
%   ge         - Greater than or equal    >=
%
% Common elementary math functions.
%   sin        - Sine.
%   sinh       - Hyperbolic sine.
%   asin       - Inverse sine.
%   asinh      - Inverse hyperbolic sine.
%   cos        - Cosine.
%   cosh       - Hyperbolic cosine.
%   acos       - Inverse cosine.
%   acosh      - Inverse hyperbolic cosine.
%   tan        - Tangent.
%   tanh       - Hyperbolic tangent.
%   atan       - Inverse tangent.
%   atanh      - Inverse hyperbolic tangent.
%   cot        - Cotangent.
%   coth       - Hyperbolic cotangent.
%   acot       - Inverse cotantgent.
%   acoth      - Inverse hyperbolic cotangent.
%   exp        - Exponential.
%   log        - Natural logarithm.
%   log10      - Common (base 10) logarithm.
%   sqrt       - Square root.
%   conj       - Complex conjugate.
%   imag       - Complex imaginary part.
%   real       - Complex real part.
%
% Common elementary data functios
%   max        - Largest value.
%   min        - Smallest value.
%   range      - Max - min.
%
% Common functions for coordinate transformation.
%   cart2cyl   - Transform Cartesian to cylindrical coordinates.
%   cart2sph   - Transform Cartesian to spherical coordinates.
%   cyl2cart   - Transform cylindrical to Cartesian coordinates.
%   cyl2sph    - Transform cylindrical to Spherical coordinates.
%   sph2cart   - Transform spherical to Cartesian coordinates.
%   sph2cyl    - Transfomr spherical to cylindrical coordinates.
%
% Scalar functions.
%   abs        - Absolute value.
%   angle      - Phase angle.
%   ctranspose - Derivation operator: Gradient.
%   display    - Display a scalar object.
%   expand     - Expand expression.
%   expr       - Eval expression.
%   formula    - Function formula.
%   grad       - Gradient vector.
%   horzcat    - Build vector function.
%   int        - Integrate scalar function.
%   isconst    - True for constant function.
%   lapl       - Laplacian of a scalar.
%   meshgrid   - Generate meshgrids.
%   pdiff      - Partial differentiation.
%   plot       - Plot scalar function.
%   resize     - Resize scalar function.
%   scalar     - Scalar constructor.
%   setrange   - Set the range for function variables.
%   size       - Size of a scalar function.
%   subsasgn   - Subscripted assignment.
%   subsref    - Subscripted reference.
%   type       - Display type of coordinates.
%   value      - Return constant value.
%
% Vector functions.
%   abs        - Vector length.
%   angle      - Angle between vectors.
%   ctranspose - Derivation operator: Divergence.
%   curl       - Curl or rotation of a vector field.
%   display    - Display a vector object.
%   div        - Divergence of a vector field.
%   dot        - Vector dot product.
%   expand     - Expand expression.
%   expr       - Eval expressions.
%   formula    - Function formulas.
%   isconst    - True for constant function.
%   lapl       - Laplacian of a vector.
%   meshgrid   - Generate meshgrids.
%   pdiff      - Partial differentiation.
%   plot       - Plot vector function.
%   resize     - Resize vector function.
%   setrange   - Set the range for function variables.
%   size       - Size of a vector function.
%   subsasgn   - subscripted assignment.
%   subsref    - subscripted reference.
%   times      - Vector dot product.
%   type       - Display type of coordinates.
%   value      - Return constant values.
%   vector     - Vector constructor.
%
% Common functions.
%   coeffs     - Coordinate coefficients.
%   isscalar   - True for scalar functions.
%   isvector   - True for vector functions.
%   plane      - Plane from normal.
%   vars       - Extract coordinates from function.
%   vecinit    - Initiate function variables.

% Internal aid functions.
%   cell2num   - Convert cell array into numeric array.
%   cplxread   - Translate complex number to string.
%   edges      - Draw edges.
%   findfunc   - Find functions in string.
%   index      - Gives index for function matrix.
%   integral   - Integral of a function matrix.
%   pdiffev    - Partial differentiation.
%   scanner    - Scan string into tokens.
%   setcorners - Force plot matrices to be non constant.
%   slices     - Create slice values for use by plot.
%   strrepx    - Replace string with another using exception.
%   texstring  - TeX'ify the string for use by plot.
%   tokcat     - Concatenate tokens to string.
%   vec2sca    - Convert vector to scalar.
%
% Demos.
%   te         - Plots waves given a TE-mode in a waveguide.
%   tm         - Plots waves given a TM-mode in a waveguide.
%   vectest    - Demonstration of how to use this toolbox by EM-examples.
%   voltline   - Example of plotting a potential distribution on a wire.

% Copyright (c) 2001-08-25 - 2002-11-25, B. Rasmus Anthin.
