function ltimodels(type)
%LTIMODELS  Help on LTI models.
%
%   LTIMODELS gives general information on the various types of 
%   LTI models supported in the Control System Toolbox.
%
%   LTIMODELS(MODELTYPE) gives additional details and examples 
%   for each type of LTI model.  The string MODELTYPE selects
%   the model type among the following:
%      'tf'  :   transfer functions (TF objects)
%      'zpk' :   zero-pole-gain models (ZPK objects)
%      'ss'  :   state-space models (SS objects)
%      'frd' :   frequency response data models (FRD objects).
%
%   Note that you can type
%      ltimodels zpk
%   as a shorthand for
%      ltimodels('zpk') .
%
%   See also LTIPROPS, TF, ZPK, SS, FRD.

%	 Author: P. Gahinet 5-21-96
%	 Copyright 1986-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/10 06:24:30 $

if nargin==0,
   type = 'general';
elseif ~ischar(type)
   error('MODELTYPE must be a string.')
end

switch lower(type(1:min(3,end)))
case 'gen'
   % General information
   DisplayStr = {...
         ' Help on LTI models.'...
         ' '...
         '   The Control System Toolbox supports four commonly used representations of'...
         '   linear time-invariant (LTI) systems:'...
         '     * Transfer function (TF) models'...
         '     * Zero-pole-gain (ZPK) models'...
         '     * State-space (SS) models'...
         '     * Frequency response data (FRD) models.'...
         ' '...
         '   Customized data structures called the TF, ZPK, SS, and FRD objects are'...
         '   provided for each of these four model types.  These objects are collectively'...
         '   referred to as LTI objects or LTI models.  Each object has a number of '...
         '   "properties" that encapsulate the model data (type LTIPROPS for details).'...
         '   The LTI objects support continuous- or discrete-time, SISO or MIMO models.'...
         ' '...
         '   To create an LTI model or object, use the corresponding constructor TF,'...
         '   ZPK, SS, or FRD.  For example,'...
         '     sys = tf(1,[1 0]) .'...
         '   creates the transfer function H(s) = 1/s.  The result SYS is a TF object'...
         '   containing the numerator and denominator data.  You can then manipulate'...
         '   the entire model as the single MATLAB variable sys.'...
         ' '...
         '   For more details and examples on how to specify the various types of LTI '...
         '   models, type LTIMODELS followed by TF, ZPK, SS, or FRD.  For example, type'...
         '      ltimodels tf'...
         '   to get additional information on TF models.'...
         ' '...
      };
   
case 'tf'
   % TF models
   DisplayStr = {...
         ' Help on TF models.'...
         ' '...
         '   Transfer function (TF) models are created with the TF command.'...
         ' '...
         '   To create a SISO continuous-time transfer function, you can specify its '...
         '   numerator and denominator as row vectors of coefficients, e.g.,'...
         '      H = tf([1 2],[1 3 5])'...
         '   specifies H(s) = (s+2)/(s^2+3s+5).  You can also define the Laplace variable'...
         '   s as a special TF model by'...
         '      s = tf(''s'')'...
         '   and then enter your transfer function as a rational expression in s:'...
         '      H = (s+2)/(s^2+3*s+5) .'...
         ' '...
         '   To create a MIMO continuous-time transfer function, you need to specify a'...
         '   numerator and denominator for each I/O pair.  You can collect this data in'...
         '   a cell array of row vectors, e.g.,'...
         '      H = tf({1 ; [1 2]} , {[1 0] ; [1 3 5]})'...
         '   Alternatively, you can build this transfer matrix by concatenation of SISO'...
         '   transfer functions, as in'...
         '      H = [1/s ; (s+2)/(s^2+3*s+5)]   (where s = tf(''s'')),'...
         '   or equivalently,'...
         '      H = [tf(1,[1 0]) ; tf([1 2],[1 3 5])] .'...
         ' '...
         '   To specify discrete-time transfer functions, simply append the sample time'...
         '   Ts to the list of inputs to TF:'...
         '      H = tf([1 2],[1 6 9],Ts) .'...
         '   You can also define the z variable with sample time Ts by'...
         '      z = tf(''z'',Ts)'...
         '   and specify your discrete-time model as a rational expression in z:'...
         '      H = (z+2)/(z^2+6*z+9) .'...
         ' '...
         '   To create arrays of SISO or MIMO TF models, either specify the numerator'...
         '   and denominator of each SISO entry using ND cell arrays, or use a FOR'...
         '   loop to successively assign each TF model in the array.  For example,'...
         '      H = tf(zeros(1,1,10));'...
         '      for k=1:10,'...
         '         H(:,:,k) = k/(s^2+s+k); '...
         '      end'...
         '   creates a 10-by-1 TF array containing the transfer functions k/(s^2+s+k)'...
         '   for k=1,2,..,10.  The first statement pre-allocates the TF array and fills'...
         '   it with zero transfer functions.'...
         ' '...
      };
   
case 'zpk'
   % ZPK models
   DisplayStr = {...
         ' Help on ZPK models.'...
         ' '...
         '   Zero-pole-gain (ZPK) models are created with the ZPK command.'...
         ' '...
         '   To create SISO continuous-time ZPK models, specify the vector of poles,'...
         '   the vector of zeros, and the gain as input arguments to ZPK.  For example,'...
         '      H = zpk(1,[2-i 2+i],3)'...
         '   specifies H(s) = 3(s-2)/(s^2-4s+5).  You can also define the Laplace '...
         '   variable s as a special ZPK model by'...
         '      s = zpk(''s'')'...
         '   and then enter your model as a rational expression in s:'...
         '      H = 3*(s-2)/(s^2-4*s+5) .'...
         ' '...
         '   To create MIMO continuous-time ZPK models, you need to specify a vector of'...
         '   zeros, a vector of poles, and a scalar gain for each I/O pair.  You can '...
         '   collect this data into two cell arrays for the zeros and poles,and a matrix'...
         '   for the gains, e.g.,'...
         '      H = zpk({[] ; [1 -1]} , {0 ; [1-i 1+i]} , [3 ; -1])'...
         '   Alternatively, you can build this MIMO model by concatenation of SISO'...
         '   models as in'...
         '      H = [3/s ; -(s-1)*(s+1)/(s^2-2*s+2)]   (where s = zpk(''s'')),'...
         '   or equivalently,'...
         '      H = [zpk([],0,3) ; zpk([1 -1],[1-i 1+i],-1)] .'...
         ' '...
         '   To specify discrete-time ZPK models, simply append the sample time Ts to'...
         '   the list of inputs to ZPK:'...
         '      H = zpk([],[0.4 0.6],1,Ts) .'...
         '   You can also define the z variable with sample time Ts by'...
         '      z = zpk(''z'',Ts)'...
         '   and enter your discrete-time model as a rational expression in z:'...
         '      H = 1/(z-0.4)/(z-0.6) .'...
         ' '...
         '   To create arrays of SISO or MIMO ZPK models, you can specify the zeros and'...
         '   poles for each SISO entry using ND cell arrays, and the gains using an ND'...
         '   array.  You can also use a FOR loop to successively assign each ZPK model'...
         '   in the array.  For example,'...
         '      H = zpk(zeros(1,1,5));'...
         '      for k=1:5,'...
         '         H(:,:,k) = k/(s+1)/(s+k);'...
         '      end'...
         '   creates a 5-by-1 ZPK array containing the ZPK models k/(s+1)/(s+k) for'...
         '   k=1,2,..,5.  The first statement pre-allocates the ZPK array and fills'...
         '   it with zero gains.'...
         ' '...
      };

case 'ss'
   % SS models
   DisplayStr = {...
         ' Help on SS models.'...
         ' '...
         '   State-space (SS) models are created with the SS command.'...
         ' '...
         '   You can create the (SISO or MIMO) continuous-time SS model'...
         '      .'...
         '      x = A x + Bu'...
         '      y = C x + Du ,'...
         '   by'...
         '      sys = ss(A,B,C,D) .'...
         ' '...
         '   The discrete-time counterpart is specified by'...
         '      sys = ss(A,B,C,D,Ts)'...
         '   where Ts is the sample time (use Ts=-1 to leave it unspecified).'...
         ' '...
         '   Descriptor state-space models of the form'...
         '        .'...
         '      E x = A x + B u'...
         '        y = C x + D u'...
         ' '...
         '   are specified by'...
         '      sys = dss(A,B,C,D,E)  or  sys = ss(A,B,C,D,''e'',E) .'...
         ' '...
         '   To create arrays of SS models, use ND arrays to specify the'...
         '   A,B,C,D matrices for each model.  The first two dimensions of'...
         '   these arrays must be the state, input, or output dimensions.'...
         '   You can use a 2D matrix for A, B, C, or D when this matrix is'...
         '   shared by all models.  Alternatively, you can use a FOR loop'...
         '   to successively assign each SS model in the array.  For example,'...
         '      sys = ss(zeros(2,3,10),4);'...
         '      for k=1:10,'...
         '         sys(:,:,k) = rss(4,2,3);'...
         '      end'...
         '   creates a 10-by-1 SS array containing random state-space models'...
         '   with 4 states, 2 outputs, and 3 inputs.  The first statement '...
         '   pre-allocates a 10-by-1 array of 4th-order SS models with zero '...
         '   A,B,C,D matrices.'...
         ' '...
      };

case 'frd'
   % FRD models
   DisplayStr = {...
         ' Help on FRD models.'...
         ' '...
         '   Frequency Response Data (FRD) models are created with the FRD command.'...
         ' '...
         '   To create a SISO continuous-time FRD model, you can specify its '...
         '   response data and frequencies as row vectors, e.g.,'...
         '      sys = frd([1+i 2+i 4+2i],[1.1 1.2 1.3])'...
         '   specifies an FRD model with the specified system responses '...
         '   at the frequencies 1.1, 1.2, and 1.3 rad/s.  To specify the frequency ' ...
         '   vector in units of Hz, use the ''Units'' property, e.g,' ...
         '      sys = frd([1+i 2+i 4+2i],[1.1 1.2 1.3],''Units'',''Hz'')'...
         ' '...
         '   To create a MIMO continuous-time FRD model, you need to specify the'...
         '   response data as a 3-dimensional array.  For example,'...
         '      sys = frd(rand(Ny,Nu,3),[1.1 1.2 1.3])'...
         '   creates an FRD model with Ny outputs and Nu inputs, with data' ...
         '   points at the frequencies 1.1, 1.2, and 1.3 rad/s.' ...
         ' '...
         '   To specify discrete-time FRD models in rad/s, simply append the sample time'...
         '   Ts to the list of inputs to FRD, e.g.,'...
         '      sys = frd([1+i 2+i 4+2i],[1.1 1.2 1.3],Ts)'...
         '   or to create the discrete-time FRD model with frequency points in Hz,' ...
         '      sys = frd([1.1+i 2.1+i 3.2+2.7i],[1.1 1.2 1.3],Ts,''Units'',''Hz'')'...
         ' '...
         '   To create arrays of SISO or MIMO FRD models, either specify the response' ...
         '   data as an array of size [Ny Nu Nf S1..Sn], where S1..Sn represent the' ...
         '   LTI array dimensions, or use a FOR loop to successively assign each FRD' ...
         '   model in the array.  For example,'...
         '      sys = frd(zeros(1,1,3,10),[1.1 1.2 1.3]);'...
         '      for k=1:10,'...
         '         sys(:,:,k) = frd(rand(1,1,3),[1.1 1.2 1.3]); '...
         '      end'...
         '   creates a 10-by-1 FRD array containing SISO FRD models.  The first' ...
         '   statement pre-allocates the FRD array and fills its response with zeros.'...
         ' '...
         '   In addition to conventional indexing methods for LTI models (see the' ...
         '   Control System Toolbox User''s Guide), you can access specific data' ...
         '   points in FRD models by using the keyword ''frequency.''  For example,' ...
         '      sys(''frequency'',sys.frequency>100)' ...
         '   extracts the response data at the frequencies greater than 100 (in the' ...
         '   units of sys.Units), and' ...
         '      sys(:,1:2,''frequency'',1:10)' ...
         '   selects the first 10 frequency points of the response from the first two' ...
         '   input channels to all output channels.' ...
         ' ' ...
      };
   
otherwise
   error(sprintf('Unknown model type ''%s''.',type))
   
end

disp(' ')
disp(char(DisplayStr))

      