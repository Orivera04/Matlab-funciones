function getDecodedText() {
  var myTextString = "";
  for (var i=0;i<myArray.length;i++) {
      myTextString+= String.fromCharCode(myArray[i]);
  }
  return myTextString;
}

function showDecodedText() {
  var result;
  var password = window.prompt("Your password:", "");
  password=password+myIdentNo;
  result=decode(password,myTextChecksum);
  if (result==0) {
    alert("Wrong password !");
  } else {
    tmpwin=window.open();
    tmpwin.document.open(myMineType);
    tmpwin.document.write(getDecodedText());
    tmpwin.document.close();
    result=decode(password,myTextChecksum);
  }
}
-->
</script>
<html>
<head>
<title>EncodedText</title>
<BODY BGCOLOR=#F0F0D0 TEXT=#000000
 LINK=#FF0000 VLINK=#FF0000 ALINK=#FF0000>
</head>
<body>
   <center>
   <br>
   <script language="javascript" type="text/javascript">
     var line="<p><b>"+myTitle+"</b>";
     window.document.write(line);
   </script>
   <br>
   <br>
   <p><a href="some.html" onmouseover="showDecodedText()">
   <img name='secretImg'
    src="data:image;base64,/9j/4AAQSkZJRgABAQEASABIAAD/4QAWRXhpZgAATU0AKgAAAAgAAAAAAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAAwADADASIAAhEBAxEB/8QAHAAAAgICAwAAAAAAAAAAAAAABQYEBwEDAAII/8QAPxAAAQMCAgINCQcFAAAAAAAAAgMEBQABBhIRIhMUITIzQUJicpKi0+IHFSNRUnSClbQWMTU2RUZTYYGy8PL/xAAZAQADAQEBAAAAAAAAAAAAAAAABAYCBQP/xAAlEQABBAIBAQkAAAAAAAAAAAACAAEDBAUGESESIiQyQUJRodH/2gAMAwEAAhEDEQA/APZdCJd+okptdrdOymx3NQz3bJDydzjIuSPNvReknEEltKNxS+HISjJfQnp5jRNQR6xF1qEKDISIqOibry0ssqO+SZkqSg9IW46taUHbYFhTZ4jnGLsuDSeErr/A5HW+GniCj0IqLRZoDpsI+kLjUPlFfnXvXJ2NbzMWswcDa4KDqlygLkkPqK16yhCsKzqztwtFyVkRfpBZQTTvqLh7Q24tG5mHizD7VM9VHhBy4VnMKPlcwqOxLZOcKjVRT/IR6tW5QKFAl3gsWV3Fwz32QEwHTo0kZiI9orUjT8ROSMdOs8kUl52VuenbZlkzN00svBa28zf3ptxf+Ep+/M/qU60ub87teKp3M3pqx8Rlx0/UzDGJN1UdSfmw++Mh/mincVFUxROB+lRHzRXuKw4U53a8VDXRc7teKpSbZb4+U/pk4NWP4S8gtLxx4eV2pEF5mRBO47eU9PlRUTzcBq8Jm5VWfhWXTnIVGRBG6OclEzC55shpqEmQ6ePWEqraUL0e+/3rU5eSbcwWnf1Pn31a1dbWMzayE5hO/QWXjagCNuRRPGd9EOn7+y+pSqC7c5f+vFRLEzRw+jdgbWT2QVUlhzX0ZiTUFS1uzSxInia37bbF0ZJTuKZ2SnbsP4dvRZqmAt3lh06Lk5R+LxUHdOVv5K6OnWJs35VH5mXdVAL7VLlq4VTHpSZd1UDNrmYk9jrojYgWiScrbGWtmqwvJJu4IS9+f/VrUjlAYrejlvANU+lJqdxVh4DiXcLh9COeXSurZRVZS4b3MooShWH+mk6qdNw96hOZWR4Z2Sd6YJBHsr//2Q==">
   </p></a>
   <script language="javascript" type="text/javascript">
     var line="<font size=\"-1\">"+myLegend+"</font>";
     window.document.write(line);
   </script>
   </center>
</body>
</html>
