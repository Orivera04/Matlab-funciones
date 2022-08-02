function R=quat2rotmat(q)
  
  R=expmap2rotmat(quat2expmap(q));
  