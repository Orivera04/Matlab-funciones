/*
 * File: aerogravitywgs84.c
 *
 * Abstract:
 *
 *      C-file containing functions for defining a continuous World 
 *      Geodetic System (WGS 84) Earth gravity.
 *      
 *      The WGS 84 model is defined as a geocentric equipotential ellipsoid. 
 *      This model can be found in NIMA TR8350.2,  "Department of Defense 
 *      World Geodetic System 1984, Its Definition and Relationship with Local
 *      Geodetic Systems"
 *
 *  S. Gage, 16 JUL 2001
 *  Copyright 1990-2002 The MathWorks, Inc.
 *
 *  $Revision: 1.3 $ $Date: 2002/04/10 16:51:06 $
 */

#include <math.h>
#include "aerogravitystruct.h"

/*
 * Function: wgs84_taylor_series ==========================================
 * Abstract:
 *          Taylor Series expansion approximation of WGS84 model of 
 *          ellipsoid normal gravity
 */
double wgs84_taylor_series(double      h,
                           double      phi,
                           WGS_params *WGS,
                           double      opt_m2ft)
{
    double gamma_ts, m, sinphi, sin2phi;

    sinphi = sin(phi);
    sin2phi = sinphi*sinphi;
        
    /* Calculate theoretical normal gravity (gamma) /eq. 4-1/ */
    gamma_ts = (WGS->gamma_e)*( 1.0 + (WGS->k)*sin2phi )/( sqrt( 1.0 - 
                                                        (WGS->e2)*sin2phi ) ); 
        
    m = (WGS->a)*(WGS->a)*(WGS->b)*(WGS->omega_default)*(WGS->omega_default)/
        (WGS->GM_default);
    
    /* Return normal gravity as the output /eq. 4-3/ */
    return opt_m2ft*gamma_ts*( 1.0 - 2.0*( 1.0 + 1.0/(WGS->inv_f) + 
                                        m - 2.0*sin2phi/(WGS->inv_f) )*h/
                            (WGS->a) + 3.0*h*h/((WGS->a)*(WGS->a)) );
}

/*
 * Function: calc_Julian_date ==========================================
 * Abstract:
 *          Calculate the Julian date
 */
static double calc_Julian_date( const SFcnCache *udata )
{
    double month, day, year;
    double temp1, temp2;
            
    month = (double)udata->month;
    day   = udata->day;
    year  = udata->year;
            
    /* calculate Julian Date (JD) */

    if ( udata->month <= FEBRUARY ){
        year  -= 1.0;
        month += 12.0;
    }
            
    temp1 = floor( year/100.0 );
    temp2 = 2.0 - temp1 + floor( temp1/4.0 );
            
    return floor( 365.25*(year + 4716.0)) + 
        floor( 30.6001*( month + 1.0)) + temp2 + day - 1524.0;
}

/*
 * Function:  wgs84_calc_shared_var ==========================================
 * Abstract:
 *          Calculate the variables shared by close approx. and exact methods.
 */
static int wgs84_calc_shared_vars( const SFcnCache *udata,
                                     double h,
                                     double E2,
                                     double cosphi, 
                                     double sinphi,
                                     double sin2phi,
                                     double coslambda,
                                     double sinlambda,
                                     double GM,
                                     double *gamma_u_ptr,
                                     double *gamma_beta_ptr,
                                     double *cosbeta_ptr,
                                     double *sinbeta_ptr,
                                     double *u_ptr,
                                     double *u2E2_ptr,
                                     double *w_ptr )
{
    double N, x_rec, y_rec, z_rec, D, u2, omega;
    double beta, sin2beta, cos2beta, q, qo, q_prime, cf_u, cf_beta;
    double w, u, u2E2, sinbeta, cosbeta, gamma_u, gamma_beta;

    WGS_params *WGS = udata->WGS;
 
    /* Radius of Curvature in prime vertical (N) /eq. 4-15/ */
    N = (WGS->a)/(sqrt( 1.0 - (WGS->e2)*sin2phi ));
        
    /* Calculate rectangular coordinates /eq. 4-14/ */
    x_rec = ( N + h )*cosphi*coslambda; 
    y_rec = ( N + h )*cosphi*sinlambda;
    z_rec = ((WGS->b_over_a)*(WGS->b_over_a)*N + h )*sinphi;
        
    /* Calculate various parameters */
    D    = x_rec*x_rec + y_rec*y_rec + z_rec*z_rec - E2;
    u2   = 0.5*D*( 1.0 + sqrt( 1.0 + 4.0*E2*z_rec*z_rec/(D*D) ));
    u2E2 = u2 + E2;
       
    /* /eq. 4-8/ */
    u = sqrt( u2 ); 
        
    /* /eq. 4-9/ */
    beta = atan(z_rec*sqrt( u2E2 )/(u*sqrt( x_rec*x_rec + y_rec*y_rec ))); 

    /* generate common sines and cosines */
    sinbeta  = sin(beta);
    sin2beta = sinbeta*sinbeta;
    cosbeta  = cos(beta);
    cos2beta = cosbeta*cosbeta;
        
    /* /eq. 4-10/ */
    w = sqrt(( u2 + E2*sin2beta )/( u2E2 ));
        
    /* /eq. 4-11/ */
    q = 0.5*(( 1.0 + 3.0*u2/( E2 ))*atan((WGS->E)/u ) - 3.0*u/(WGS->E));
        
    /* /eq. 4-12/ */
    qo = 0.5*(( 1.0 + 3.0*(WGS->b)*(WGS->b)/( E2 ))*atan((WGS->E)/(WGS->b))
              - 3.0*(WGS->b)/(WGS->E));
        
    /* /eq. 4-13/ */
    q_prime = 3.0*(( 1.0 + u2/( E2 ))*( 1.0 - (u/(WGS->E))*
                                        atan( (WGS->E)/u ))) - 1.0;
        
    /* Use precessing reference frame? */
    if ( udata->precessing == 0 ) { 
        omega = WGS->omega_default;
    }
    else { 
        double JD;

        /* calculate Julian Date (JD) */
        JD = calc_Julian_date( udata );
           
        /* Ang Vel of Earth (rad/sec) [precessing ref. frame] /eq. 3-8/ */
        omega = WGS->omega_prime + 7.086e-12 + 
            4.3e-15*((JD - 2451545.0)/36525.0);
    }

    /* Use Centrifugal Force? */
    if ( udata->centrifugal == 0 ) {
        cf_u    = u*cos2beta*omega*omega/w;
        cf_beta = sqrt( u2E2 )*cosbeta*sinbeta*omega*omega/w;
    }
    else {
        cf_u    = 0.0;
        cf_beta = 0.0;
    }
            
    /* /eq. 4-5/ */
    gamma_u = -( GM/u2E2 + omega*omega*(WGS->a)*(WGS->a)*(WGS->E)*q_prime*
                 ( 0.5*sin2beta - 1.0/6.0 )/(u2E2*qo))/w + cf_u;
        
    /* /eq. 4-6/ */
    gamma_beta = omega*omega*(WGS->a)*(WGS->a)*q*sinbeta*cosbeta/
        (sqrt( u2E2 )*w*qo) - cf_beta;

    *gamma_u_ptr    = gamma_u;
    *gamma_beta_ptr = gamma_beta;
    *cosbeta_ptr    = cosbeta;
    *sinbeta_ptr    = sinbeta;
    *u_ptr          = u;
    *u2E2_ptr       = u2E2;
    *w_ptr          = w;

    return 0;
} 

/*
 * Function: wgs84_approx ==========================================
 * Abstract:
 *          Close approximation of WGS84 model of ellipsoid normal gravity
 */
double wgs84_approx(double h,
                    double phi, 
                    double lambda,
                    const SFcnCache *udata,
                    double E2,
                    double GM,
                    double opt_m2ft )
{ 
    double gamma_u, gamma_beta, u, u2E2, sinbeta, cosbeta, w;

    double cosphi, sinphi, sin2phi, coslambda, sinlambda;

    /* generate common sines and cosines of lat and long angles */
    sinphi = sin(phi);
    sin2phi = sinphi*sinphi;
    cosphi    = cos(phi);
    coslambda = cos(lambda);
    sinlambda = sin(lambda);

    wgs84_calc_shared_vars( udata,h,E2,cosphi,sinphi,sin2phi,coslambda,
                                sinlambda,GM,&gamma_u,&gamma_beta,&cosbeta,
                                &sinbeta,&u,&u2E2,&w );

    /* Return normal gravity */
    /* gamma_lambda = 0 */
    return opt_m2ft*sqrt( gamma_u*gamma_u + gamma_beta*gamma_beta ); 
}

/*
 * Function: wgs84_exact ==========================================
 * Abstract:
 *          Exact WGS84 model of ellipsoid normal gravity
 */
double wgs84_exact( double h,
                    double phi,
                    double lambda,
                    const SFcnCache *udata,
                    double E2,
                    double GM,
                    double opt_m2ft )
{
    /* Calculating exact normal gravity */
    double psi, tanphi, sinpsi, cospsi, alpha, cosalpha, sinalpha;
    double gamma_h, gamma_phi, gamma_r, gamma_psi;            

    double gamma_u, gamma_beta, u, u2E2, sinbeta, cosbeta, w;

    double sinphi, sin2phi, cosphi, coslambda, sinlambda;
       
    WGS_params *WGS = udata->WGS;

    /* generate common sines and cosines of lat and long angles */
    sinphi = sin(phi);
    sin2phi = sinphi*sinphi;
    cosphi    = cos(phi);
    coslambda = cos(lambda);
    sinlambda = sin(lambda);

    tanphi = sinphi/cosphi;
            
    /* Calc. geocentric latitude (psi) from geodetic latitude (phi) */
    psi = atan( tanphi*( 1.0 - 1.0/(WGS->inv_f))*( 1.0 - 1.0/(WGS->inv_f)));
            
    cospsi = cos(psi);
    sinpsi = sin(psi);
            
    /* /eq. 4-20/ */
    alpha = phi - psi;
            
    cosalpha = cos(alpha);
    sinalpha = sin(alpha);

    wgs84_calc_shared_vars( udata,h,E2,cosphi,sinphi,sin2phi,coslambda,
                            sinlambda,GM,&gamma_u,&gamma_beta,&cosbeta,
                            &sinbeta,&u,&u2E2,&w );

    /* /eq. 4-17, 4-18, 4-19/
     *
     * |gamma_r     |         |gamma_u     |
     * |gamma_psi   | = R2*R1*|gamma_beta  |  
     * |gamma_lambda|         |gamma_lambda|
     *
     * where:
     * gamma_lambda = 0
     *
     *      |cosbeta*coslambda*u   -sinbeta*coslambda    -sinlambda|
     *      |-------------------   ------------------              | 
     *      |    w*sqrt(u2E2)              w                       |
     * R1 = |                                                      | 
     *      |cosbeta*sinlambda*u   -sinbeta*sinlambda     coslambda| 
     *      |-------------------   ------------------              | 
     *      |    w*sqrt(u2E2)              w                       |
     *      |                                                      | 
     *      |      sinbeta              cosbeta*u            0     |
     *      |-------------------   ------------------              | 
     *      |        w                w*sqrt(u2E2)                 |
     *
     *
     *      | cospsi*coslambda  cospsi*sinlambda  sinpsi|
     * R2 = |-sinpsi*coslambda -sinpsi*sinlambda  cospsi|
     *      |-sinlambda         coslambda           0   |
     *
     *
     *         |cosB*cosP*u    sinB*sinP  sinP*cosB*u    sinB*cosP   0|
     *         |----------- +  ---------  ----------- -  ---------    |
     *         |w*sqrt(u2E2)       w      w*sqrt(u2E2)       w        |
     * R2*R1 = |                                                      |
     *         |sinB*cosP   sinP*cosB*u  cosB*cosP*u   sinB*sinP     0|
     *         |--------- - -----------  ----------- + ----------     |
     *         |    w       w*sqrt(u2E2) w*sqrt(u2E2)      w          |
     *         |                                                      |
     *         |           0                         0               1|
     *
     *
     *        where cosB = cosbeta
     *              sinB = sinbeta 
     *              cosP = cospsi 
     *              sinP = sinpsi 
     */
             
    gamma_r   = (cosbeta*cospsi*u/(w*sqrt(u2E2))+sinbeta*sinpsi/w)*
        gamma_u + (sinpsi*cosbeta*u/(w*sqrt(u2E2))-
                   sinbeta*cospsi/w)*gamma_beta;

    gamma_psi = (sinbeta*cospsi/w-sinpsi*cosbeta*u/(w*sqrt(u2E2)))*
        gamma_u + (cosbeta*cospsi*u/(w*sqrt(u2E2))+
                   sinbeta*sinpsi/w)*gamma_beta;
            
    /* "normal" gravity  / eq. 4-16 / */
    gamma_h = (-gamma_r)*cosalpha - gamma_psi*sinalpha;

    /* "tangent" gravity  / eq. 4-23 / */
    gamma_phi = (-gamma_r)*sinalpha + gamma_psi*cosalpha;

    /* Return total normal gravity as the output / eq. 4-24 / */
    return opt_m2ft*sqrt( gamma_h*gamma_h + gamma_phi*gamma_phi);
}



























