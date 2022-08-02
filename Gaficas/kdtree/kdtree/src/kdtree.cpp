#include "kdtree.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

KDTree::KDTree()
{
  root = (struct _Node *) NULL;
  workArr = (int *) NULL;
  copyPoints = false;
  points = (float *)NULL;
  return;
}				// end of constructor

KDTree::KDTree(float *setpoints, int N, int setndim)
{
  
  KDTree();
  create(setpoints, N, setndim);
  return;
}				// end of constructor


// Note: this is copied almost verbatim from the heapsort 
// wiki page: http://en.wikipedia.org/wiki/Heapsort 
// 11/9/05
int KDTree::heapsort(int dim, int *idx)
{
  unsigned int n = npoints,i=npoints/2,parent,child;
  int t;

  for(;;) {
    if(i>0) {
      i--;
      t = idx[i];
    }
    else {
      n--;
      if(n ==0) return 0;
      t  = idx[n];
      idx[n] = idx[0];
    }
  
    parent = i;
    child = i*2+1;

    while(child < n) {
      if((child +1 < n) &&
	 (points[(idx[child+1])*ndim+dim] > 
	  points[idx[child]*ndim + dim])) {
	child++;
      }
      if(points[idx[child]*ndim+dim] > points[t*ndim+dim]) {
	idx[parent] = idx[child];
	parent = child;
	child = parent*2+1;
      }
      else {
	break;
      }
    }
    idx[parent] = t;
  } // end of for loop
  return 0;
} // end of heapsort

      
  
KDTree::~KDTree()
{
  free_node(root);
  if (workArr)
    delete[]workArr;
  if (copyPoints && points) {
    // Delete the 1-D array of data
    // Delete the pointer to the points
    delete[] points;
  }
  
  return;
}				// end of destructor

int KDTree::serialize_node(void *sroot,struct _Node *root, int offset)
{
  memcpy ((char *)sroot+offset,&root->key,sizeof(float));
  memcpy ((char *)sroot+offset+sizeof(float),&root->pntidx, sizeof(int));
  
  int newoffset = offset + sizeof(float)+sizeof(int);
  // Serialize the left branch of this node
  if(root->pntidx == -1) {
    newoffset = serialize_node(sroot,root->left,newoffset);
    // Serialize the right branch of this node
    newoffset =  serialize_node(sroot,root->right,newoffset);
  }
  return newoffset;
} // end of serialize_node

int KDTree::unserialize_node(void *sroot, int offset, float *points,
                             int ndim, struct _Node **newnode)
{
  // Create and populate the new node
  struct _Node *node = new struct _Node;
  float *key = (float *) ( (char *)sroot+offset);
  int *pntidx = (int *) ( (char *)sroot+offset+sizeof(float));
  node->key = key[0];
  node->pntidx = pntidx[0];
  int newoff = offset + sizeof(float)+sizeof(int);
  
  if(node->pntidx != -1) {
    node->pnt =  points + node->pntidx * ndim;
    node->left = (struct _Node *)0;
    node->right = (struct _Node *)0;
  }
  else {
    node->pnt = (float *)0;
    newoff = unserialize_node(sroot,newoff,points,ndim,&node->left);
    newoff = unserialize_node(sroot,newoff,points,ndim,&node->right);
  }
  newnode[0] = node;
  return newoff;
  
} // end of unserialize_node

int KDTree::get_serialize_length()
{
  return 
      // The data points to be copied
      npoints*ndim*sizeof(float)+
      // The header information (8 bytes only)
      8+
      // The tree has twice as many nodes as points
      (npoints*2*(sizeof(float)+sizeof(int)));
} // end of get_serialize_length


// The "mem" buffer better be at least "get_serialize_length()" long
// or the program will crash
int KDTree::serialize(void *mem)
{
  
  // Serialize the buffer "data"
  unsigned char *data = (unsigned char *)mem;
  
  int *snpoints = (int *) (data);
  int *sndim = (int *) (data+4);
  float *spoints = (float *) (data+8);
  struct _Node *sroot = 
      (struct _Node *) (data+8+npoints*ndim*sizeof(float));
  
  // Serialize the data descriptors
  snpoints[0] = npoints;
  sndim[0] = ndim;
  // Serialize the points
  memcpy(spoints,points,sizeof(float)*npoints*ndim);
  // Serialize the tree
  serialize_node((void *)sroot,root); 
  
  return 0;
} // end of serialize

KDTree *KDTree::unserialize(void *mem)
{
  unsigned char *data = (unsigned char *)mem;
  
  KDTree *kdtree = new KDTree;
  
  int *snpoints = (int *)(data);
  int *sndim = (int *) (data+4);
  
  // Load the data descriptors
  kdtree->copyPoints = false;
  kdtree->npoints = snpoints[0];
  kdtree->ndim = sndim[0];
  kdtree->points = (float *) (data+8);
  
  // Set the data points pointer
  unsigned char *droot = data+8+sizeof(float)*kdtree->ndim*kdtree->npoints;
  
  // Load the tree
  unserialize_node(droot,0,kdtree->points,kdtree->ndim,&kdtree->root);
  
  return kdtree;
} // end of unserialize

// This function creates a KD tree with the given
// points, array, and length
int KDTree::create(float *setpoints, int setnpoints, int setndim,
		   bool setCopy)
{
  ndim = setndim;
  npoints = setnpoints;
  typedef int *intptr;

  // Copy the points from the original array, if necessary
  copyPoints = setCopy;
  if (copyPoints) {
    if(points) delete[] points;
    points = new float[ndim*npoints];
    memcpy(points,setpoints,sizeof(float)*ndim*npoints);
  }
  // If we are not copying, just set the pointer
  else
    points = setpoints;


  // Allocate some arrays;
  if (workArr)
    delete[]workArr;
  workArr = new int[npoints];

  // Create the "sortidx" array by 
  // sorting the range tree points on each dimension
  int **sortidx = new intptr[ndim];
  for (int i = 0; i < ndim; i++) {
    // Initialize the sortidx array for this
    // dimension
    sortidx[i] = new int[npoints];

    // Initialize the "tmp" array for the sort
    int *tmp = new int[npoints];
    for (int j = 0; j < npoints; j++)
      tmp[j] = j;

    // Sort the points on dimension i, putting
    // indexes in array "tmp"
    heapsort(i,tmp);

    // sortidx is actually the inverse of the 
    // index sorts
    for (int j = 0; j < npoints; j++)
      sortidx[i][tmp[j]] = j;

    delete[] tmp;
  }

  // Create an initial list of points that references 
  // all the points
  int *pidx = new int[npoints];
  for (int i = 0; i < npoints; i++)
    pidx[i] = i;

  // Build a KD Tree
  root = build_kdtree(sortidx,	// array of sort values
		      0,	// The current dimension
		      pidx, npoints);	// The list of points
  
  
  // Delete the sort index
  for (int i = 0; i < ndim; i++)
    delete[]sortidx[i];
  delete[] sortidx;

  // Delete the initial list of points
  delete[] pidx;

  if(workArr) {
    delete[] workArr;
    workArr = (int *)NULL;
  }
  
  return 0;
}				// end of create      

// This function frees the tree
void KDTree::free_node(struct _Node *n)
{
  if (!n)
    return;
  if (n->left)
    free_node(n->left);
  if (n->right)
    free_node(n->right);
  delete n;
  return;
}				// end of free_node

// This function build a node of the kdtree with the
// points indexed by pidx with length "len"
// sortidx is a pre-computed array using the quicksort 
// algorithm above
struct _Node *KDTree::build_kdtree(int **sortidx, int dim,
                                   int *pidx, int len)
{
  struct _Node *node;
  
  
  node = new struct _Node;
  if (len == 1) {
    node->left = (struct _Node *) 0;
    node->right = (struct _Node *) 0;
    node->pnt = points + pidx[0]*ndim;
    node->pntidx = pidx[0];
    node->key = 0;
    return node;
  }
  
  
  // If not, we must make a node
  // Find the pivot (index of median point of available
  // points on current dimension).
  // Use the previously calculated sort index
  // to make this a process linear in N
  // This gets a little confusing, but it works.
  // Sortidx:: sortidx[dim][idx] = val 
  // idx = the index to the point
  // val = the order in the array
  int pivot = -1;
  int *parray = workArr;

  // Setting parray to -1 indicates we are not using 
  // the point
  for (int i = 0; i < npoints; i++)
    parray[i] = -1;
  // Populate "parray" with the points that we
  // are using, indexed in the order the occur
  // on the current dimension
  for (int i = 0; i < len; i++)
    parray[sortidx[dim][pidx[i]]] = pidx[i];
  int cnt = 0;
  int lcnt = 0, rcnt = 0;
  int *larray = new int[len / 2 + 5];
  int *rarray = new int[len / 2 + 5];

  // The middle valid value of parray is the pivot,
  // the left go to a node on the left, the right
  // go to a node on the right.
  for (int i = 0; i < npoints; i++) {
    if (parray[i] == -1)
      continue;
    if (cnt == len / 2) {
      pivot = parray[i];
      rarray[rcnt++] = parray[i];
    } else if (cnt > len / 2)
      rarray[rcnt++] = parray[i];
      else
        larray[lcnt++] = parray[i];
      cnt++;
  }

  // Create the node
  node->pnt = (float *) 0;
  node->pntidx = -1;
  node->key = points[pivot*ndim+dim];
  // Create nodes to the left
  node->left = build_kdtree(sortidx, (dim + 1) % ndim, larray, lcnt);
  delete[]larray;
  // Create nodes to the right
  node->right = build_kdtree(sortidx, (dim + 1) % ndim, rarray, rcnt);
  delete[]rarray;

  return node;
}				// end of build_kdtree


// This function operates a search on a node for points within
// the specified range.
// It assumes the current node is at a depth corresponding to 
// dimension "dim"
int KDTree::operate_search(struct _Node *node, Range * range, int dim,
			   void *(*opFunction) (int))
{
  if (!node)
    return 0;

  // If this is a leaf node, check to see if the 
  // data is in range.  If so, operate on it.
  if (node->pnt) {
    // Return if not in range
    for (int i = 0; i < ndim; i++) {
      if (node->pnt[i] < range[i][0] || node->pnt[i] > range[i][1])
	return 0;
    }
    opFunction(node->pntidx);
    return 0;
  }
  // Search left, if necessary
  if (node->key >= range[dim][0])
    operate_search(node->left, range, (dim + 1) % ndim, opFunction);
  // Search right,if necessary
  if (node->key <= range[dim][1])
    operate_search(node->right, range, (dim + 1) % ndim, opFunction);
  return 0;
}				// end of operate_search

// This is the public function that will call the
// function "opFunction" on all points in the array
// within "range"
int KDTree::operate_on_range(Range * range, void *(*opFunction) (int))
{
  operate_search(root, range, 0, opFunction);
  return 0;
}				// end of operate_on_points


int KDTree::closest_point(float *pnt, int &idx, bool approx)
{
  int dim = 0;

  // First, iterate along the path to the point, 
  // and find the one associated with this point
  // on the line
  struct _Node *n = root;
  idx = -1;
  for (;;) {
    // Is this a leaf node
    if (n->pnt) {
      idx = n->pntidx;
      break;
    }
    if (n->key > pnt[dim])
      n = n->left;
    else
      n = n->right;
    dim = (dim + 1) % ndim;
  }
  // Are we getting an approximate value?
  if(approx == true) return 0;

  //float ndist = distance(pnt, points[idx]);
  float ndistsq = distsq(pnt,points+idx*ndim);

  // Search for possible other nearest neighbors
  // by examining adjoining nodes whos children may
  // be closer
  n = root;
  dim = 0;
  check_border_distance(root, 0, pnt, ndistsq, idx);


  return 0;
}				// end of closest_point

int KDTree::check_border_distance(struct _Node *node, int dim,
				  float *pnt, float &cdistsq, int &idx)
{
  // Are we at a closer leaf node?  
  // If so, check the distance
  if (node->pnt) {
    float dsq = distsq(pnt, node->pnt);
    if (dsq < cdistsq) {
      cdistsq = dsq;
      idx = node->pntidx;
    }
    return 0;
  }

  // The distance squared along the current dimension between the
  // point and the key
  float ndistsq = 
    (node->key - pnt[dim])*(node->key - pnt[dim]);

  // If the distance squared from the key to the current value is 
  // greater than the nearest distance, we need only look
  // in one direction.
  if (ndistsq > cdistsq) {
    if (node->key > pnt[dim])
      check_border_distance(node->left, (dim + 1) % ndim, pnt, cdistsq, idx);
    else
      check_border_distance(node->right, (dim + 1) % ndim, pnt, cdistsq, idx);
  }
  // If the distance from the key to the current value is 
  // less than the nearest distance, we still need to look
  // in both directions.
  else {
    check_border_distance(node->left, (dim + 1) % ndim, pnt, cdistsq, idx);
    check_border_distance(node->right, (dim + 1) % ndim, pnt, cdistsq, idx);
  }
  return 0;
}				// end of check_child_distance


inline float KDTree::distsq(float *pnt1, float *pnt2)
{
  float d = 0.0;
  for (int i = 0; i < ndim; i++)
    d += (pnt1[i] - pnt2[i]) * (pnt1[i] - pnt2[i]);
  return d;
}				// end if distsq

float KDTree::distance(float *pnt1, float *pnt2)
{
  return sqrt(distsq(pnt1, pnt2));
}				// end of distance



#ifdef _TEST_

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/time.h>

double gettime()
{
  struct timeval tv;
  gettimeofday(&tv,NULL);
  return tv.tv_sec + tv.tv_usec/1.0E6;

}

int main(int argc, char *argv[])
{
  int npoints = 15000;
  int ndim = 3;
  double t1,t2;
 
  float *data = new float[npoints*ndim];
  for(int i=0;i<npoints*ndim;i++) {
    data[i] = (float)(rand())/(float)(RAND_MAX);
    data[i] = i;
  }
  
  t1 = gettime();
  KDTree *tree = new KDTree;
  tree->create(data,npoints,ndim);
  t2 = gettime();
  printf("tree creation: %g sec\n",(t2-t1));

  float pref[3];
  pref[0] = pref[1] = pref[2] = 0.5;

  int idx = 0;

  float pnts[1000][3];
  for(int i=0;i<1000;i++) 
    for(int j=0;j<3;j++)
       pnts[i][j] = (float)rand()/(float)RAND_MAX;



  t1 = gettime();
  for(int i=0;i<1000;i++) {
    tree->closest_point(pnts[i],idx);
  }  
  t2 = gettime();
  printf("finding a point: %g sec\n",(t2-t1)/1000.0f);

  delete tree;
  delete[] data;
    
  return 0;
}				// end of main
#endif
