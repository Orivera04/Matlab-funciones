function q=expmap2quat(r)
  q=rotmat2quat(expmap2rotmat(r));
  