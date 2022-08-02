function result = brent ( f, xa, xb )

%% BRENT carries out Brent's method for seeking a real root of a nonlinear function.
%
%  Discussion:
%
%    This is a "stripped down" version with little error checking.
%
%    When the iteration gets going:
%      XB will be the latest iterate;
%      XA will be the previous value of XB;
%      XC will be a point with sign ( F(XC) ) = - sign ( F(XB) )
%
%  Modified:
%
%    05 August 2005
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    Richard Brent,
%    Algorithms for Minimization without Derivatives,
%    Prentice Hall, 1973.
%
%  Parameters:
%
%    Input, F, the function whose zero is desired.
%
%    Input, real XA, XB, two points.  The zero of the function
%    will be sought between these values.  F(XA) and F(XB) should
%    be of opposite signs.
%
%  Local parameters:
%
%    Local, real F_TOL_ABS, an absolute tolerance on the size of F(X).
%
%    Local, integer IT_MAX, the maximum number of iterations.
%
%    Local, real X_TOL_ABS, an absolute tolerance on the size of
%    of the change-of-sign interval.
%
%    Local, real X_TOL_REL, a relative tolerance on the size of
%    of the change-of-sign interval.
%
  f_tol_abs = 0.00001;
  it_max = 10;
  x_tol_abs = 0.00001;
  x_tol_rel = 0.00001;

  it = 0;

  fxa = feval ( f, xa );
  fxb = feval ( f, xb );

  xc = xa;
  fxc = fxa;
  d = xb - xa;
  e = d;

  format long

  while ( it <= it_max )

    it = it + 1;

    [ xa, xb, xc; fxa, fxb, fxc ]

    if ( abs ( fxc ) < abs ( fxb ) ) 
      xa = xb;
      xb = xc;
      xc = xa;
      fxa = fxb;
      fxb = fxc;
      fxc = fxa;
    end

    xtol = 2.0 * x_tol_rel * abs ( xb ) + 0.5 * x_tol_abs;

    xm = 0.5 * ( xc - xb );

    if ( abs ( xm ) <= xtol ) 
      fprintf ( 1, '\n' );
      fprintf ( 1, 'BRENT:\n' );
      fprintf ( 1, '  Interval small enough for convergence.\n' );
      result = xb;
      return
    end

    if ( abs ( fxb ) <= f_tol_abs )
      fprintf ( 1, '\n' );
      fprintf ( 1, 'BRENT:\n' );
      fprintf ( 1, '  Function value small enough for convergence.\n' );
      result = xb;
      return
    end
%
%  See if a bisection is forced.
%
    if ( abs ( e ) < xtol | abs ( fxa ) <= abs ( fxb ) )

      d = xm;
      e = d;

    else

      s = fxb / fxa;
%
%  Linear interpolation.
%
      if ( xa == xc )

        p = 2.0 * xm * s;
        q = 1.0 - s;
%
%  Inverse quadratic interpolation.
%
      else

        q = fxa / fxc;
        r = fxb / fxc;
        p = s * ( 2.0 * xm * q * ( q - r ) - ( xb - xa ) * ( r - 1.0 ) );
        q = ( q - 1.0 ) * ( r - 1.0 ) * ( s - 1.0 );

      end

      if ( 0.0 < p )
        q = - q;
      else
        p = - p;
      end

      s = e;
      e = d;

      if ( 3.0 * xm * q - abs ( xtol * q ) < 2.0 * p | ...
        abs ( 0.5 * s * q ) <= p )
        d = xm;
        e = d;
      else
        d = p / q;
      end

    end
%
%  Save old XB, FXB
%
    xa = xb;
    fxa = fxb;
%
%  Compute new XB, FXB,
%
    if ( xtol <= abs ( d ) )
      xb = xb + d;
    elseif ( 0.0 < xm )
      xb = xb + xtol;
    elseif ( xm <= 0.0 )
      xb = xb - xtol;
    end

    fxb = feval ( f, xb );

    if ( sign ( fxb ) == sign ( fxc ) ) 
      xc = xa;
      fxc = fxa;
      d = xb - xa;
      e = d;
    end 

  end

  fprintf ( 1, '\n' );
  fprintf ( 1, 'BRENT:\n' );
  fprintf ( 1, '  Maximum number of steps taken.\n' );

  result = xc;
