function r=rotmat2expmap(R)
  r=quat2expmap(rotmat2quat(R));
 
  