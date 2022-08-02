Description of Simulation Software for the book:

DOPPLER APPLICATIONS IN LEO SATELLITE COMMUNICATION SYSTEMS  by 
Irfan Ali, Pierino G. Bonanni, Naofal Al-Dhahir, and John E. Hershey 
Kluwer Academic Publishers, 101 Philip Drive, Norwell, MA 02061

For inquiries please contact:

  Dr. Pierino G. Bonanni
  GE Corporate Research & Development
  bonanni@crd.ge.com

  Dr. Irfan Ali
  Motorola
  Irfan.Ali@motorola.com


-------------------------
COPYRIGHT AND DISCLAIMER
-------------------------

Copyright 2001, Pierino G. Bonanni and Irfan Ali.  All Rights Reserved.

These M-files are User Contributed Routines which are being distributed 
by The MathWorks, upon request, on an "as is" basis.  A User Contributed 
Routine is not a product of The MathWorks, Inc. and The MathWorks assumes 
no responsibility for any errors that may exist in these routines. 

The software is distributed via this Web site with NO WARRANTY from 
the authors or from Kluwer Academic Publishers.  The authors and Kluwer 
Academic Publishers shall not be liable for damage in connection with, 
or arising out of, the furnishing, performance or use of this software.

Use or reproduction of these M-files for commercial gain is strictly 
prohibited.  Explicit permission is given for reproduction and use 
in an instructional setting, provided proper reference is given to 
the original source.


------------
DESCRIPTION
------------

DBMA Simulation Software

These routines are written to aid the reader in the visualization of LEO 
satellite orbit geometry and dynamics of the Doppler Based Multiple Access 
(DBMA) communication protocol described in Chapter 5 of the book.

The "demo" functions are a set of graphical animations driven by a simple 
graphical user interface (GUI) modeled after the MATLAB Lorenz demo.  These 
illustrate a typical LEO orbit, its coverage regions, and the DBMA concept. 

The support functions are a small collection of functions useful for 
calculating satellite orbits, terrestrial contours and regions, and 
coordinate transformations based on Earth rotation.  These are intended 
to "jump start" any readers who might wish to advance the material in the 
book. 

These functions are drawn from a larger toolbox of satellite oriented 
routines under development by P.G. Bonanni.


---------------------------------------
1. LOADING AND USING THE DEMO SOFTWARE
---------------------------------------

The complete set of routines is available on CD-ROM provided with the book.
Alternatively, the software and any future updates can be accessed via the
MathWorks Web site.  Instructions for download are

Web:          ftp://ftp.mathworks.com/pub/books/bonanni

Unix login:   ftp ftp.mathworks.com
              Name: anonymous
              Guest login ok, send your complete e-mail address
              Password: (type in e-mail address)
              cd /pub/books/bonanni

The routines have been tested with Versions 5.3.1, 6.0, and 6.1 of MATLAB.

To install the software, simply copy all the provided files to a convenient
folder.  Upon startup of MATLAB, use the path command to ensure that the
selected folder is included in the search path.  Then enter a demo command
(demo1, demo2, demo3, ...)  to bring up a GUI from which an animation can be
launched.

The following animations are included in the initial release:

  o  demo1  -  Satellite ground track animation. This demo animates 
     the ground track of a typical LEO satellite.  The chosen trajectory 
     is an inclined circular orbit at 1000 km altitude. 

  o  demo2  -  Visibility-based coverage region animation. This demo 
     displays and animates the visibility-based coverage region of a 
     typical LEO satellite.  Visibility from points on the Earth's 
     surface is established if the satellite appears above a given 
     elevation angle in the sky.  The satellite in this demo follows 
     an inclined circular orbit at 1000 km altitude.

  o  demo3  -  DBMA-based coverage region animation.  This demo 
     displays and animates the DBMA-based coverage region of a typical 
     LEO satellite.  The "region of eligibility" for DBMA coverage is 
     symmetric about the sub-satellite point and is given by the 
     intersection of three larger regions:

         (1) Visibility cone around the sub-satellite point -- the 
         region in which the elevation to the satellite from the 
         ground exceeds a given angle.  Nodes may transmit at a given 
         time only if the satellite is above this elevation.

         (2) Orbital swath -- the region defined by a lower bound 
         to the maximum elevation angle to the satellite.  Only nodes 
         that have observed, or will observe, an elevation angle 
         greater than the given value upon closest passage of the 
         satellite during the current orbital cycle are permitted 
         to transmit.

         (3) Orbital time window -- the region observing closest 
         passage of the satellite within a given time window.  Only 
         nodes that have observed (will observe) maximum elevation 
         within this interval from the given time are permitted to 
         transmit.

     The satellite in this demo follows an inclined circular orbit 
     at 1000 km altitude.


------------------------
2. OVERVIEW OF ROUTINES
------------------------

The demos described above are built on a platform of satellite oriented 
routines and some supporting math functions that supplement the basic 
MATLAB command set.  The  most direct reliance is on two high-level 
routines, 'walker' and 'dbmacover', which compute the satellite orbits 
and the DBMA coverage regions displayed dynamically in the animations.  
Function 'walker' generates orbit trajectories for a Walker satellite 
constellation, which describes a pattern of identical circular orbits 
regularly spaced about a series of planes at a fixed inclination.  
Function 'dbmacover' computes the geographic "region of eligibility" 
defined by the DBMA protocol of Chapter 5, given parameters specifying 
the visibility cone, the orbital swath, and the orbital time window.

The satellite oriented support functions on which these high-level 
routines are based are next listed and described:
  o  arcangle - Calculates the angular distance (central angle) between 
     two terrestrial surface points specified by latitude and longitude.
  o  drawmap - Draws a map using a rectangular grid projection (latitude 
     versus longitude).  A "map" is defined as a sequence of contiguous 
     latitude-longitude pairs delimited by "pen-up" indications.   
     Example maps are provided in the MAT-file 'maps.mat'.  Included 
     are maps representing Earth land-water boundaries, U.S. state 
     borders, and a grid constructed from parallels of latitude and 
     meridians of longitude.
  o  eci2ecf2 - Transforms a position/velocity trajectory from Earth-
     centered-inertial (ECI) to Earth-centered-fixed (ECF) coordinates.
  o  greatarc - Computes a latitude-longitude sequence representing the 
     great-circle arc connecting two terrestrial surface points.
  o  grnwich - Calculates the Greenwich right ascension for a given 
     Julian date and time.  This is used to compensate for Earth rotation 
     in transformations between ECI and ECF coordinates.
  o  intreg - Computes a latitude-longitude sequence representing the 
     intersection of two geographic regions, themselves defined by 
     latitude-longitude sequences.
  o  kepl2eci - Transforms Keplerian to ECI coordinates.  Keplerian 
     coordinates are convenient for specification of elliptical orbits; 
     conversion to ECI enables Cartesian representation of position and 
     velocity.
  o  lonlat - Calculates longitude, latitude, and range from a Cartesian 
     position specification (ECI or ECF).  Opposite of 'posllr'.
  o  orbitper - Calculates the orbital period as a function of semi-major 
     axis for satellites in orbit about Earth.
  o  perimvis - Computes a latitude-longitude sequence describing the 
     perimeter of the region on Earth's surface visible from a given 
     position in space.  Visibility is defined by the criterion that 
     the elevation to the satellite from the ground exceeds a given 
     angle.
  o  posllr - Calculates Cartestian position (ECI or ECF) given longitude, 
     latitude, and range.  Opposite of 'lonlat'.
  o  str2jt - Converts a date-time string specification to a real-valued 
     Julian time in days, suitable for use in astronomical formulas.
  o  swath - Generates a latitude-longitude sequence defining the swath 
     of visibility for an orbit.  Visibility from a given ground point 
     is defined by the criterion that the maximum elevation reached by 
     the satellite on the current pass exceeds a given angle.
  o  ucompass - Calculates unit vectors defining local bearings (East, 
     North, and Zenith) for a given latitude and longitude on Earth.

Additionally, the satellite routines make use of the following mathematical 
support functions:
  o  pvdeg - Principal value in degrees.  Converts angles outside the 
     range [0,360] degrees to the equivalent angle in that range.
  o  pvdegs - Symmetric principal value in degrees.  Converts angles 
     outside the range [-180,180] degrees to the equivalent angle in 
     that range.
  o  pvrad - Principal value in radians.  Converts angles outside the 
     range [0,2*pi] radians to the equivalent angle in that range.
  o  pvrads - Symmetric principal value in radians.  Converts angles 
     outside the range [-pi,pi] radians to the equivalent angle in 
     that range.
  o  rot3x - Computes the 3x3 matrix representing a rotation about 
     the x-axis by a given angle.
  o  rot3y - Computes the 3x3 matrix representing a rotation about 
     the y-axis by a given angle.
  o  rot3z - Computes the 3x3 matrix representing a rotation about 
     the z-axis by a given angle.
  o  rotate3x - Rotates a 3-space trajectory about the x-axis.
  o  rotate3y - Rotates a 3-space trajectory about the y-axis.
  o  rotate3z - Rotates a 3-space trajectory about the z-axis.


----------------------------------
3. ALPHABETICAL LIST OF FUNCTIONS
----------------------------------

 ARCANGLE  - Angular distance between surface points.
 DBMACOVER - Coverage region using DBMA protocol.
 DEMO1     - Satellite ground track animation.
 DEMO2     - Visibility-based coverage region animation.
 DEMO3     - DBMA-based coverage region animation.
 DRAWMAP   - Draw a map using a rectangular grid projection.
 ECI2ECF2  - Pos/vel ECI to ECF transformation.
 GREATARC  - Great arc connecting two surface points.
 GRNWICH   - Greenwich right ascension.
 INTREG    - Intersection of two geographic regions.
 KEPL2ECI  - Keplerian to ECI transformation.
 LONLAT    - Calculate longitude, latitude, and range.
 ORBITPER  - Calculate period for terrestrial orbits.
 PERIMVIS  - Calculate perimeter of visible ground region.
 POSLLR    - Calculate position given longitude, latitude, and range.
 PVDEG     - Principal value in degrees.
 PVDEGS    - Symmetric principal value in degrees.
 PVRAD     - Principal value in radians.
 PVRADS    - Symmetric principal value in radians.
 ROT3X     - 3-space rotation matrix - x.
 ROT3Y     - 3-space rotation matrix - y.
 ROT3Z     - 3-space rotation matrix - z.
 ROTATE3X  - Rotate a 3-space trajectory about the x-axis.
 ROTATE3Y  - Rotate a 3-space trajectory about the y-axis.
 ROTATE3Z  - Rotate a 3-space trajectory about the z-axis.
 STR2JT    - Convert date-time string to Julian Time.
 SWATH     - Calculate swath of visibility for an orbit.
 UCOMPASS  - Calculate compass directions.
 WALKER    - Generate a Walker satellite constellation.


----------------------
4. FUNCTION REFERENCE
----------------------

 _________________________________________________________________
 ARCANGLE - Angular distance between surface points.
 angle = arcangle(elon1,nlat1,elon2,nlat2)

 Calculates the angular distance between surface points (elon1,nlat1) 
 and (elon2,nlat2), along the great arc connecting the points.  Inputs 
 'elon1' and 'elon2' are in east longitude degrees and 'nlat1' and 
 'nlat2' are in north latitude degrees.  These may be scalars or 
 column vectors of uniform length.  Output 'angle' (scalar or vector, 
 matching the inputs) is returned in degrees. 

 P.G. Bonanni
 6/29/00

 _________________________________________________________________
 DBMACOVER - Coverage region using DBMA protocol.
 [elon,nlat] = dbmacover(xECF,vECF,index,dt,elev1,elev2,tmax)

 Calculates a longitude and latitude sequence (elon,nlat) defining the 
 boundary of the region within which tags are allowed to communicate 
 by the DBMA protocol.  This "region of eligibility," computed for a 
 specific instant in time, is symmetric about the sub-satellite point 
 and is given by the intersection of three larger regions:

   (1) Visibility cone around the subsatellite point - the region 
       in which the elevation to the satellite from the ground exceeds 
       a given angle, specified by 'elev1' in degrees.  Nodes may 
       transmit only if the satellite is above this elevation at 
       the current time.
   (2) Orbital swath - the region defined by a lower bound to the 
       maximum elevation angle to the satellite, specified by 'elev2' 
       in degrees.  Only nodes that have observed, or will observe, 
       an elevation angle greater than this value upon closest passage 
       of the satellite during the current orbital cycle are permitted 
       to transmit.
   (3) Orbital time window - the region observing closest passage of 
       the satellite within a given time window, whose half width is 
       specified by 'tmax' in seconds.  Only nodes that have observed 
       (or will observe) maximum elevation within +/- this interval 
       from the current time are permitted to transmit.

 Parameters:
   xECF   - Earth-centered-fixed satellite location [x,y,z] in km
   vECF   - Earth-centered-fixed satellite velocity [vx,vy,vz] in km/sec
   index  - index into xECF (and vECF) defining the current time
   dt     - time between orbit samples, in sec
   elev1  - minimum current visibility angle, in degrees
   elev2  - minimum visibility at closest passage, in degrees
   tmax   - maximum time preceding/following closest passage, in sec

 NOTE: A negative value for 'tmax' specifies use of the full time 
 window during which the visibility and maximum elevation criteria 
 are met.

 Units for (elon,nlat) are east longitude degrees and north latitude 
 degrees, respectively.

 Irfan Ali / P.G. Bonanni
 7/10/00

 _________________________________________________________________
 DEMO1 - Satellite ground track animation.
 demo1(action)

 This demo animates the ground track of a typical LEO 
 satellite.  The chosen trajectory is a 53-deg inclined 
 circular orbit at 1000 km altitude. 

 Possible button actions:
  'initialize' - initialize UI and graphics
  'start'      - start animation
  'stop'       - stop animation
  'info'       - display help info
  'close'      - close graphics window

 P.G. Bonanni / Irfan Ali  7/17/00

 _________________________________________________________________
 DEMO2 - Visibility-based coverage region animation.
 demo2(action)

 This demo displays and animates the visibility-based coverage 
 region of a typical LEO satellite.  Visibility from points on 
 the Earth's surface is established if the satellite appears 
 above a given elevation angle in the sky.  The satellite in 
 this demo follows a 53-deg inclined circular orbit at 1000 km 
 altitude. 

 Possible button actions:
  'initialize' - initialize UI and graphics
  'start'      - start animation
  'stop'       - stop animation
  'info'       - display help info
  'close'      - close graphics window

 P.G. Bonanni / Irfan Ali  7/18/00

 _________________________________________________________________
 DEMO3 - DBMA-based coverage region animation.
 demo3(action)

 This demo displays and animates the DBMA-based coverage 
 region of a typical LEO satellite.  The "region of eligibility" 
 for DBMA coverage is symmetric about the sub-satellite point 
 and is given by the intersection of three larger regions:

   (1) Visibility cone around the subsatellite point - the region 
       in which the elevation to the satellite from the ground exceeds 
       a given angle, given by 'elev1' in degrees.  Nodes may transmit 
       at a given time only if the satellite is above this elevation.
   (2) Orbital swath - the region defined by a lower bound to the 
       maximum elevation angle to the satellite, given by 'elev2' in 
       degrees.  Only nodes that have observed, or will observe, an 
       elevation angle greater than this value upon closest passage 
       of the satellite during the current orbital cycle are permitted 
       to transmit.
   (3) Orbital time window - the region observing closest passage of 
       the satellite within a given time window, given by 'tmax' in 
       seconds.  Only nodes that have observed (will observe) maximum 
       elevation within this interval from the given time are 
       permitted to transmit.  (NOTE: A negative value for 'tmax' 
       specifies use of the full time window during which the 
       visibility criteria above are met.)

 The satellite in this demo follows a 53-deg inclined circular orbit 
 at 1000 km altitude. 

 Possible button actions:
  'initialize' - initialize UI and graphics
  'start'      - start animation
  'stop'       - stop animation
  'info'       - display help info
  'close'      - close graphics window

 P.G. Bonanni / Irfan Ali  7/17/00

 _________________________________________________________________
 DRAWMAP - Draw a map using a rectangular grid projection.
 handle = drawmap(map[,range,s])

 Draws that portion of 'map' which lies within the 
 geographical area specified by 'range', where 
 'map' is an [N,2] matrix of contiguous (elon,nlat) 
 pairs separated by "pen-up" indicators (i.e., the 
 pair "NaN NaN").  Units for (elon,nlat) are east 
 longitude degrees and north latitude degrees, 
 respectively.  Parameter 'range' is a 1x4 vector 
 whose format is like the Matlab 'axis' parameter 
 with x range referring to east longitude degrees 
 and y range to north latitude degrees.  Parameter 
 's' specifies the line type for the plot.  The 
 output of the function is a handle to the resulting 
 plot. 

 Other usage modes: 
  1) drawmap(map)
       displays the full map using a solid line type. 
  2) drawmap(map,range)
       displays the specified range using a solid line type. 
  3) drawmap(map,s)
       displays the full map using the specified line type. 

 P.G. Bonanni
 2/7/95

 _________________________________________________________________
 ECI2ECF2 - Pos/vel ECI to ECF transformation.
 [xECF,vECF] = eci2ecf2(JT,xECI,vECI)
 xECF = eci2ecf2(JT,xECI)

 Converts positions x and velocities v 
 from ECI to ECF, given Julian time JT 
 in days.

 Parameters:
  JT   - Nx1 vector of Julian times
  xECI - Nx3 ECI position trajectory
  vECI - Nx3 ECI velocity trajectory

 ECF outputs 'xECF' and 'vECF' are Nx3. 
 Input parameter 'vECI' may be omitted 
 if only a position transformation is 
 desired. 

 P.G. Bonanni
 9/28/94

 _________________________________________________________________
 GREATARC - Great arc connecting two surface points.
 [elon,nlat] = greatarc(elon1,nlat1,elon2,nlat2,npoints)

 Generates longitude (deg E) and latitude (deg N) coordinates 
 representing the great arc connecting points (elon1,nlat1) 
 and (elon2,nlat2).  Parameter 'npoints' specifies the number 
 of points on the arc. 

 P.G. Bonanni
 8/26/94

 _________________________________________________________________
 GRNWICH - Greenwich right ascension.
 az = grnwich(JT)

 Computes the right ascension of Greenwich (rad) given 
 Julian Time vector 'JT' (days).  (Algorithm from Meeus, 
 J., Astronomical Algorithms, p. 83-85.)

 P.G. Bonanni (adapted from code by Craig Bennett)
 10/31/94

 _________________________________________________________________
 INTREG - Intersection of two geographic regions.
 [elon,nlat] = intreg(elon1,nlat1,elon2,nlat2)

 Given two geographic regions bordered by the closed sequences 
 (elon1,nlat1) and (elon2,nlat2) where 'elon1' and 'elon2' are 
 vectors of east longitude degrees, and 'nlat1' and 'nlat2' are 
 vectors of north latitude degrees, calculate the region defined 
 by the intersection.  Assumes close sampling of the border contours, 
 and that both the input regions and the intersection region have 
 the property that great circle arcs directed outward from their 
 geographic centers intersect their boundaries only once. 

 P.G. Bonanni (adapted from code by Irfan Ali)
 7/10/00

 _________________________________________________________________
 KEPL2ECI - Keplerian to ECI transformation.
 [xECI,vECI] = kepl2eci(a,e,i,o,w,v)

 Calculates the Nx3 position trajectory 'xECI' and Nx3 velocity 
 trajectory 'vECI' in Earth-centered-inertial coordinates given 
 Keplerian orbit element Nx1 sequences (a,e,i,o,w,v).  Scalar 
 values for any of the inputs are acceptable.  Units for 'xECI' 
 and 'vECI' are km and km/sec, respectively. 

 The Keplerian elements are:
   a  :  semimajor axis (km)
   e  :  eccentricity (unitless)
   i  :  inclination (rad)
   o  :  right ascension of the
           ascending node (rad)
   w  :  argument of perigee (rad)
   v  :  true anomaly (rad)

 P.G. Bonanni
 3/10/95

 _________________________________________________________________
 LONLAT - Calculate longitude, latitude, and range.
 [elon,nlat,range] = lonlat(x)

 Given an Nx3 vector 'x' of Earth-fixed Cartesian positions, 
 calculate Nx1 input vectors specifying longitude, latitude, 
 and range.  Longitude 'elon' is specified in east degrees 
 and latitude in north degrees.  Ouput 'range' has units to 
 match those of input trajectory 'x'. 

 P.G. Bonanni
 6/28/00

 _________________________________________________________________
 ORBITPER - Calculate period for terrestrial orbits.
 T = orbitper(a)

 Calculates orbital period as a function of 
 semi-major axis for a body in Earth orbit. 
 The semi-major axis 'a' is specified in km 
 (vector input is permitted).  Orbit period 
 is returned in units of seconds. 

 P.G. Bonanni
 3/7/95

 _________________________________________________________________
 PERIMVIS - Calculate perimeter of visible ground region.
 [elon,nlat] = perimvis(x [, elev], npoints)

 Calculates a length 'npoints' sequence of (elon,nlat) pairs that 
 define the perimeter of the region on the Earth's surface visible 
 from a given position 'x' in space.  Visibility is defined by the 
 criterion that the elevation to the point 'x' from the ground is 
 greater than or equal to angle 'elev'.  This angle is given in 
 degrees, and defaults to zero if omitted from the argument list. 
 The position 'x' is specified in km with respect to Earth-centered 
 coordinates.  Units for 'elon' and 'nlat' are east longitude degrees 
 and north latitude degrees, respectively. 

 P.G. Bonanni
 6/22/00

 _________________________________________________________________
 POSLLR - Calculate position given longitude, latitude, and range.
 x = posllr(elon,nlat [,range])

 Calculates an Nx3 vector 'x' of Earth-fixed Cartesian 
 positions given Nx1 input vectors specifying longitude, 
 latitude, and range.  Longitude 'elon' is specified in 
 east degrees and latitude in north degrees.  If 'range' 
 parameter is omitted, Earth radius is assumed. 

 P.G. Bonanni
 3/7/95

 _________________________________________________________________
 PVDEG - Principal value in degrees.
 angle1 = pvdeg(angle)

 This function converts angles outside the 
 range [0,360] to their equivalent in that 
 range.  Both scalar and matrix inputs are 
 valid. 

 P.G. Bonanni
 10/31/94

 _________________________________________________________________
 PVDEGS - Symmetric principal value in degrees.
 angle1 = pvdegs(angle)

 This function converts angles outside the 
 range [-180,180] to their equivalent in that 
 range.  Both scalar and matrix inputs are 
 valid. 

 P.G. Bonanni
 10/31/94

 _________________________________________________________________
 PVRAD - Principal value in radians.
 angle1 = pvrad(angle)

 This function converts angles outside the 
 range [0,2*pi] to their equivalent in that 
 range.  Both scalar and matrix inputs are 
 valid. 

 P.G. Bonanni
 11/10/94

 _________________________________________________________________
 PVRADS - Symmetric principal value in radians.
 angle1 = pvrads(angle)

 This function converts angles outside the 
 range [-pi,pi] to their equivalent in that 
 range.  Both scalar and matrix inputs are 
 valid. 

 P.G. Bonanni
 11/10/94

 _________________________________________________________________
 ROT3X - 3-space rotation matrix - x.
 R = rot3x(theta)

 Computes the 3x3 matrix representing a rotation 
 about the x-axis by angle 'theta'. 

 P.G. Bonanni
 11/10/94

 _________________________________________________________________
 ROT3Y - 3-space rotation matrix - y.
 R = rot3y(theta)

 Computes the 3x3 matrix representing a rotation 
 about the y-axis by angle 'theta'. 

 P.G. Bonanni
 11/10/94

 _________________________________________________________________
 ROT3Z - 3-space rotation matrix - z.
 R = rot3z(theta)

 Computes the 3x3 matrix representing a rotation 
 about the z-axis by angle 'theta'. 

 P.G. Bonanni
 11/10/94

 _________________________________________________________________
 ROTATE3X - Rotate a 3-space trajectory about the x-axis.
 [x1,y1,z1] = rotate3x(x,y,z,theta)

 Rotates the 3-space trajectory [x,y,z] by an amount 
 'theta' radians about the x-axis, where 'theta' is 
 a vector equal in size to 'x', 'y', and 'z'.  Scalar 
 inputs are extended to vectors if needed. 

 P.G. Bonanni
 3/5/96

 _________________________________________________________________
 ROTATE3Y - Rotate a 3-space trajectory about the y-axis.
 [x1,y1,z1] = rotate3y(x,y,z,theta)

 Rotates the 3-space trajectory [x,y,z] by an amount 
 'theta' radians about the y-axis, where 'theta' is 
 a vector equal in size to 'x', 'y', and 'z'.  Scalar 
 inputs are extended to vectors if needed. 

 P.G. Bonanni
 3/5/96

 _________________________________________________________________
 ROTATE3Z - Rotate a 3-space trajectory about the z-axis.
 [x1,y1,z1] = rotate3z(x,y,z,theta)

 Rotates the 3-space trajectory [x,y,z] by an amount 
 'theta' radians about the z-axis, where 'theta' is 
 a vector equal in size to 'x', 'y', and 'z'.  Scalar 
 inputs are extended to vectors if needed. 

 P.G. Bonanni
 3/5/96

 _________________________________________________________________
 STR2JT - Convert date-time string to Julian Time.
 jt = str2jt(line)

 Converts a date-time string to Julian time, in days.  Julian 
 days are a continuous count of days starting from noon Univeral 
 Time on January 1 of the year 4713 BC, a reference useful in 
 astronomical formulas.  (Note: 0:00 UT corresponds to a Julian 
 time fraction of 0.5.)  Input 'line' is a string variable 
 having any of the following formats:

              FORMAT                  EXAMPLE
              ------                  -------
             'dd-mmm-yyyy HH:MM:SS'   01-Mar-1995 15:45:17
             'dd-mmm-yyyy'            01-Mar-1995
             'mm/dd/yy'               03/01/95
             'mm/dd'                  03/01
             'mmmyy'                  Mar95
             'HH:MM:SS'               15:45:17
             'HH:MM:SS PM'             3:45:17 PM
             'HH:MM'                  15:45
             'HH:MM PM'                3:45 PM

 (Variations on date and time can be combined.)

 P.G. Bonanni
 7/19/00

 _________________________________________________________________
 SWATH - Calculate swath of visibility for an orbit.
 [elon,nlat] = swath(xECF,vECF [,elev])

 Generates a sequence of (elon,nlat) pairs that define the swath of 
 coverage for a satellite with the given orbit.  Coverage is defined 
 by the criterion that the elevation to the satellite from the ground 
 is greater than or equal to angle 'elev' in degrees.  Units for 'elon' 
 and 'nlat' are east longitude degrees and north latitude degrees, 
 respectively.  The NX3 orbital position trajectory 'xECF' and velocity 
 trajectory 'vECF' are specified in km and km/sec respectively, with 
 respect to Earth-centered-fixed coordinates.  Elevation 'elev' may be 
 scalar or Nx1 corresponding to the orbit length.  If omitted entirely, 
 zero is assumed. 

 P.G. Bonanni (adapted from code by Irfan Ali)
 6/29/00

 _________________________________________________________________
 UCOMPASS - Calculate compass directions.
 [east,north,zenith] = ucompass(elon0,nlat0)

 Calculates 3x1 unit vectors 'east', 'north', and 
 'zenith' representing the corresponding local 
 directions for a given longitude 'elon0' and 
 latitude 'nlat' expressed in the ECF frame.  
 Input units are degrees east and degrees north, 
 respectively. 

 P.G. Bonanni
 3/8/95

 _________________________________________________________________
 WALKER - Generate a Walker satellite constellation.
 [XECI,VECI] = walker(nsat,radius,inclin,nplanes,harmonic,ran0,anom0,time)

 Generates orbit trajectories XECI = {xECI1,xECI2,...,xECInsat} and 
 corresponding velocity trajectories VECI = {vECI1,vECI2,...,vECInsat} 
 for a Walker satellite constellation orbiting the Earth at 'radius' km. 
 The Walker constellation is specified by the number of satellites 'nsat', 
 inclination angle 'inclin' (in degrees), number of planes 'nplanes', and 
 harmonic factor 'harmonic'.  Parameter 'ran0' specifies the right ascension 
 of the ascending node (in degrees), and 'anom0' the initial true anomaly 
 (in degrees), for the first satellite in the constellation.  Vector 'time' 
 (in seconds) defines the temporal spacing and duration of the trajectory 
 points.  (The initial value time(1) is referenced to 'anom0'.)

 P.G. Bonanni (adapted from code by Irfan Ali)
 6/28/00
