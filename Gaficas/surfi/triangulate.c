//
//	ported from Paul Bourke's triangulate code at
//	http://astronomy.swin.edu.au/~pbourke/terrain/triangulate/
//	

typedef struct {
   int p1,p2,p3;
} ITRIANGLE;
typedef struct {
   int p1,p2;
} IEDGE;
typedef struct {
   double x,y,z;
} XYZ;

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,
                 const mxArray *prhs[])
{
	int N, ntri, n;
	double* xyz;
	double EPSILON;
	ITRIANGLE* v;
	mxArray* temp;
	int dims[2];
	
	if (nrhs<1) mexErrMsgTxt("Expected at least 1 argument");
	if (!mxIsDouble(prhs[0]) || mxGetNumberOfDimensions(prhs[0])!=2 || mxGetM(prhs[0])!=3)
		mexErrMsgTxt("Expected first argument to be 3xN double");
	N = mxGetN(prhs[0]);
	if (nrhs >= 2)
	{
		if (!mxIsDouble(prhs[1]) || mxGetNumberOfDimensions(prhs[1])!=2 || mxGetM(prhs[1])!=1 || mxGetN(prhs[1])!=1)
			mexErrMsgTxt("Expected second argument to be scalar double");
		EPSILON = *mxGetPr(prhs[1]);
	}
	else
	{
		EPSILON = mxGetEps();
	}
	
	//	copy input array into array with space for 3 more
	temp = mxCreateDoubleMatrix(3, N+3, mxREAL);
	xyz = mxGetPr(temp);
	memcpy(xyz,mxGetPr(prhs[0]),3*N*sizeof(double));
	
	dims[0] = 3;
	dims[1] = N * 3;
	plhs[0] = mxCreateNumericArray(2, dims, mxINT32_CLASS, mxREAL);
	v = mxGetPr(plhs[0]);
	
	//	Run Paul's code
	Triangulate(N, xyz, v, &ntri, EPSILON);
	
	//	Convert indices to matlab
	for (n=0; n<ntri; n++)
	{
		v[n].p1++;
		v[n].p2++;
		v[n].p3++;
	}
	
	//	truncate output array to number of triangles returned
	mxSetN(plhs[0], ntri);
}

int CircumCircle(double xp,double yp,
   double x1,double y1,double x2,double y2,double x3,double y3,
   double *xc,double *yc,double *r,double EPSILON);

/*
   Triangulation subroutine
   Takes as input NV vertices in array pxyz
   Returned is a list of ntri triangular faces in the array v
   These triangles are arranged in a consistent clockwise order.
   The triangle array 'v' should be malloced to 3 * nv
   The vertex array pxyz must be big enough to hold 3 more points
   The vertex array must be sorted in increasing x values say

   qsort(p,nv,sizeof(XYZ),XYZCompare);
      :
   int XYZCompare(void *v1,void *v2)
   {
      XYZ *p1,*p2;
      p1 = v1;
      p2 = v2;
      if (p1->x < p2->x)
         return(-1);
      else if (p1->x > p2->x)
         return(1);
      else
         return(0);
   }
*/
int Triangulate(int nv,XYZ *pxyz,ITRIANGLE *v,int *ntri,double EPSILON)
{
   int *complete = NULL;
   IEDGE *edges = NULL;
   int nedge = 0;
   int trimax,emax = 200;
   int status = 0;

   int inside;
   int i,j,k;
   double xp,yp,x1,y1,x2,y2,x3,y3,xc,yc,r;
   double xmin,xmax,ymin,ymax,xmid,ymid;
   double dx,dy,dmax;

   /* Allocate memory for the completeness list, flag for each triangle */
   trimax = 4 * nv;
   if ((complete = malloc(trimax*sizeof(int))) == NULL) {
      status = 1;
      goto skip;
   }

   /* Allocate memory for the edge list */
   if ((edges = malloc(emax*(long)sizeof(IEDGE))) == NULL) {
      status = 2;
      goto skip;
   }

   /*
      Find the maximum and minimum vertex bounds.
      This is to allow calculation of the bounding triangle
   */
   xmin = pxyz[0].x;
   ymin = pxyz[0].y;
   xmax = xmin;
   ymax = ymin;
   for (i=1;i<nv;i++) {
      if (pxyz[i].x < xmin) xmin = pxyz[i].x;
      if (pxyz[i].x > xmax) xmax = pxyz[i].x;
      if (pxyz[i].y < ymin) ymin = pxyz[i].y;
      if (pxyz[i].y > ymax) ymax = pxyz[i].y;
   }
   dx = xmax - xmin;
   dy = ymax - ymin;
   dmax = (dx > dy) ? dx : dy;
   xmid = (xmax + xmin) / 2.0;
   ymid = (ymax + ymin) / 2.0;

   /*
      Set up the supertriangle
      This is a triangle which encompasses all the sample points.
      The supertriangle coordinates are added to the end of the
      vertex list. The supertriangle is the first triangle in
      the triangle list.
   */
   pxyz[nv+0].x = xmid - 20 * dmax;
   pxyz[nv+0].y = ymid - dmax;
   pxyz[nv+0].z = 0.0;
   pxyz[nv+1].x = xmid;
   pxyz[nv+1].y = ymid + 20 * dmax;
   pxyz[nv+1].z = 0.0;
   pxyz[nv+2].x = xmid + 20 * dmax;
   pxyz[nv+2].y = ymid - dmax;
   pxyz[nv+2].z = 0.0;
   v[0].p1 = nv;
   v[0].p2 = nv+1;
   v[0].p3 = nv+2;
   complete[0] = 0;
   *ntri = 1;

   /*
      Include each point one at a time into the existing mesh
   */
   for (i=0;i<nv;i++) {

      xp = pxyz[i].x;
      yp = pxyz[i].y;
      nedge = 0;

      /*
         Set up the edge buffer.
         If the point (xp,yp) lies inside the circumcircle then the
         three edges of that triangle are added to the edge buffer
         and that triangle is removed.
      */
      for (j=0;j<(*ntri);j++) {
         if (complete[j])
            continue;
         x1 = pxyz[v[j].p1].x;
         y1 = pxyz[v[j].p1].y;
         x2 = pxyz[v[j].p2].x;
         y2 = pxyz[v[j].p2].y;
         x3 = pxyz[v[j].p3].x;
         y3 = pxyz[v[j].p3].y;
         inside = CircumCircle(xp,yp,x1,y1,x2,y2,x3,y3,&xc,&yc,&r,EPSILON);
         if (xc + r < xp)
            complete[j] = 1;
         if (inside) {
            /* Check that we haven't exceeded the edge list size */
            if (nedge+3 >= emax) {
               emax += 100;
               if ((edges = realloc(edges,emax*(long)sizeof(IEDGE))) == NULL) {
                  status = 3;
                  goto skip;
               }
            }
            edges[nedge+0].p1 = v[j].p1;
            edges[nedge+0].p2 = v[j].p2;
            edges[nedge+1].p1 = v[j].p2;
            edges[nedge+1].p2 = v[j].p3;
            edges[nedge+2].p1 = v[j].p3;
            edges[nedge+2].p2 = v[j].p1;
            nedge += 3;
            v[j] = v[(*ntri)-1];
            complete[j] = complete[(*ntri)-1];
            (*ntri)--;
            j--;
         }
      }

      /*
         Tag multiple edges
         Note: if all triangles are specified anticlockwise then all
               interior edges are opposite pointing in direction.
      */
      for (j=0;j<nedge-1;j++) {
         for (k=j+1;k<nedge;k++) {
            if ((edges[j].p1 == edges[k].p2) && (edges[j].p2 == edges[k].p1)) {
               edges[j].p1 = -1;
               edges[j].p2 = -1;
               edges[k].p1 = -1;
               edges[k].p2 = -1;
            }
            /* Shouldn't need the following, see note above */
            if ((edges[j].p1 == edges[k].p1) && (edges[j].p2 == edges[k].p2)) {
               edges[j].p1 = -1;
               edges[j].p2 = -1;
               edges[k].p1 = -1;
               edges[k].p2 = -1;
            }
         }
      }

      /*
         Form new triangles for the current point
         Skipping over any tagged edges.
         All edges are arranged in clockwise order.
      */
      for (j=0;j<nedge;j++) {
         if (edges[j].p1 < 0 || edges[j].p2 < 0)
            continue;
         if ((*ntri) >= trimax) {
            status = 4;
            goto skip;
         }
         v[*ntri].p1 = edges[j].p1;
         v[*ntri].p2 = edges[j].p2;
         v[*ntri].p3 = i;
         complete[*ntri] = 0;
         (*ntri)++;
      }
   }

   /*
      Remove triangles with supertriangle vertices
      These are triangles which have a vertex number greater than nv
   */
   for (i=0;i<(*ntri);i++) {
      if (v[i].p1 >= nv || v[i].p2 >= nv || v[i].p3 >= nv) {
         v[i] = v[(*ntri)-1];
         (*ntri)--;
         i--;
      }
   }

skip:
   free(edges);
   free(complete);
   return(status);
}

/*
   Return TRUE if a point (xp,yp) is inside the circumcircle made up
   of the points (x1,y1), (x2,y2), (x3,y3)
   The circumcircle centre is returned in (xc,yc) and the radius r
   NOTE: A point on the edge is inside the circumcircle
*/
int CircumCircle(double xp,double yp,
   double x1,double y1,double x2,double y2,double x3,double y3,
   double *xc,double *yc,double *r,double EPSILON)
{
   double m1,m2,mx1,mx2,my1,my2;
   double dx,dy,rsqr,drsqr;

   /* Check for coincident points */
   if (fabs(y1-y2) < EPSILON && fabs(y2-y3) < EPSILON)
       return(0);

   if (fabs(y2-y1) < EPSILON) {
      m2 = - (x3-x2) / (y3-y2);
      mx2 = (x2 + x3) / 2.0;
      my2 = (y2 + y3) / 2.0;
      *xc = (x2 + x1) / 2.0;
      *yc = m2 * (*xc - mx2) + my2;
   } else if (fabs(y3-y2) < EPSILON) {
      m1 = - (x2-x1) / (y2-y1);
      mx1 = (x1 + x2) / 2.0;
      my1 = (y1 + y2) / 2.0;
      *xc = (x3 + x2) / 2.0;
      *yc = m1 * (*xc - mx1) + my1;
   } else {
      m1 = - (x2-x1) / (y2-y1);
      m2 = - (x3-x2) / (y3-y2);
      mx1 = (x1 + x2) / 2.0;
      mx2 = (x2 + x3) / 2.0;
      my1 = (y1 + y2) / 2.0;
      my2 = (y2 + y3) / 2.0;
      *xc = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2);
      *yc = m1 * (*xc - mx1) + my1;
   }

   dx = x2 - *xc;
   dy = y2 - *yc;
   rsqr = dx*dx + dy*dy;
   *r = sqrt(rsqr);

   dx = xp - *xc;
   dy = yp - *yc;
   drsqr = dx*dx + dy*dy;

   return((drsqr <= rsqr) ? 1 : 0);
}


