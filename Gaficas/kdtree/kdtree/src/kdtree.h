#ifndef _KDTREE_H_
#define _KDTREE_H_

struct _Node {
  float key;
  float *pnt;
  int pntidx;
  struct _Node *left;
  struct _Node *right;
};


typedef float *Range;
typedef int IRange[2];

class KDTree {
public:
  KDTree(float *setpoints, int N, int setndim);
  KDTree();

   virtual ~ KDTree();

  int create(float *setpoints, int setnpoints, int setndim,
	     bool setCopy = false);
  int ndim;
  int npoints;
  float *points;

  struct _Node *root;

  // Search for the nearest neighbor to pnt and 
  // return its index
  int closest_point(float *pnt, int &idx, bool approx=false);

  int operate_on_range(Range *range, void *(*opFunction) (int));

  // Return distance or distance squared 
  // between points
  inline float distsq(float *pnt1, float *pnt2);
  inline float distance(float *pnt1, float *pnt2);

  // The following functions allow all the information in the class
  // to be serialized and unserialized.  This is convenient, for example,
  // for writing the tree to a disk or to a MATLAB variable
  int serialize(void *mem);
  int get_serialize_length();
  static KDTree *unserialize(void *mem);
 
protected:

  // Do we copy the points or not
  // if we do, this is where they go
   bool copyPoints;

  int check_border_distance(struct _Node *node, int dim,
			    float *pnt, float &dist, int &idx);

  int operate_search(struct _Node *node, Range * range, int dim,
		     void *(*opFunction) (int));

  int heapsort(int dim, int *idx);

  struct _Node *build_kdtree(int **sortidx, int dim, int *pidx, int len);
  void free_node(struct _Node *);
  
  int *workArr;

  
  // Protected functions for serialization
  static int unserialize_node(void *sroot, int offset, float *points,
                              int ndim, struct _Node **node);
  int serialize_node(void *loc, struct _Node *node, int offset=0);
  
   
  
};

#endif
