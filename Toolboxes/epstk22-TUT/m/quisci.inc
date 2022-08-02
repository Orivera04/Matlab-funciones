
// QUISCI cipher, written by Stefan Mueller 2001
function decode(key,checksum) {
  var i, j, t;
  var k;
  var qs;
  var s=[];

  // init 
  qs=0;
  t=key.length;
  for (i=0; i < 256; i++) {
    s[i]=i^key.charCodeAt(i % key.length);
    t=t^s[i];
    qs+=t;
  }
  qs=qs-((qs>>8)<<8);
  if (checksum == qs) {
    // loop
    i=s[255]; j=0;
    for (k=0; k < myArray.length; k++) {
      i+=s[j];
      i=i-((i>>8)<<8);
      if (i==0) {
        i=255^s[j];
	s[j]=t;
        myArray[k]^=i;
      } else {
        t=i^s[j];
        s[j]=i;j=i;
        myArray[k]^=t;
      }
    }
    return 1;
  } else {
    return 0;
  }
}

