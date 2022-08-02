function [D, Slope]=displace(x,Moment,type,placement,E,I)
%DISPLACE Displacement of a beam.
%   [DISPLACEMENT,SLOPE]=DISPLACE(X,MOMENT,TYPE,PLACEMENT,E,I) will find the
%   DISPLACEMENT and SLOPE of a beam that is being acted upon by the MOMENT
%   given to it.  The MOMENT data should be developed with the DIAGRAM and
%   DIAGRAMINTEGRAL routines.
%
%   TYPE describes the type of supports used, the options are:
%     ['place' 'place'] for a pin supported beam.
%     ['slope' 'place'] and ['place' 'slope'] for a beam that has a 
%     restriction on it's slope at one point and its placement at that or 
%     another point.  Often the place and slope restraints will be at the 
%     same point for a fixed support like the wall in a cantilevered beam.
%   PLACEMENT is a two entry vector describing the place along the beam that
%     the corresponding support is acting.
%   E is the Young's modulus of the beam.
%   I is the area moment of inertia of the beams cross section.
%
%   See also DIAGRAM, DIAGRAMINTEGRAL, FIXEDFIXED, FIXEDPIN, PINPIN.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

type=lower(type);

if nargin<5 E=1; end
if nargin<6 I=1; end

%type is either 'place' or 'slope', will be in a vector with two words
%placement is the distance along the x that the restraint is placed

first=type(1:5);
second=type(6:10);
if ~(strcmp(first,'place') | strcmp(first,'slope'))
  disp('Invalid restraint type, use ''slope'' or ''place''');
  return
end

if ~(strcmp(second,'place') | strcmp(second,'slope'))
  disp('Invalid restraint type, use ''slope'' or ''place''');
  return
end

if strcmp(second,'slope') & strcmp(first,'slope')
    disp('Can not deal with ''slope'' ''slope'' restraint.')
    disp('Try a redundancy routine.')
    return
end

Slope=diagramintegral(x,Moment);

if strcmp(first,'slope')
  Slope=Slope-interpolate(x,Slope,placement(1));
  D=diagramintegral(x,Slope);
  D=D-interpolate(x,D,placement(2));
elseif strcmp(second,'slope')
  Slope=Slope-interpolate(x,Slope,placement(2));
  D=diagramintegral(x,Slope);
  D=D-interpolate(x,D,placement(1));
else
  D=diagramintegral(x,Slope);
  ErrorMatrix=[-interpolate(x,D,placement(1)); -interpolate(x,D,placement(2))];
  PlaceMatrix=[placement' [1 1]'];
  Coefs=inv(PlaceMatrix)*ErrorMatrix;
  Slope=Slope+Coefs(1);
  D=(D+Coefs(1)*x+Coefs(2));
end

Slope=Slope/(E*I);
D=D/(E*I);

