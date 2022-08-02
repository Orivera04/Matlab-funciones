
// RC4 cipher, written by Ronald L. Rivest 1987
function decode(key,checksum) {
  var i, j, t;
  var k;
  var qs;
  var s=[];

  // init 
  for (i=0; i < 256; i++) {
    s[i]=i;
  }
  j=0;
  for (i=0; i<256; i++) {
    j+=s[i]+key.charCodeAt(i % key.length);
    j=j-((j>>8)<<8);
    t=s[i]; s[i]=s[j]; s[j]=t;
  }
  qs=0;
  t=key.length;
  for (i=0; i<256; i++) {
    t=t^s[i];
    qs+=t;
  }
  qs=qs-((qs>>8)<<8);
  if (checksum == qs) {
    // loop
    i=0; j=0;
    for (k=0; k < myArray.length; k++) {
      i++;
      i=i-((i>>8)<<8);
      j+=s[i];
      j=j-((j>>8)<<8);
      t=s[i]; s[i]=s[j]; s[j]=t;
      t=s[i]+s[j];
      t=t-((t>>8)<<8);
      myArray[k]^=s[t];
    }
    return 1;
  } else {
    return 0;
  }
}

