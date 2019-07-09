<?output "../web/js/posts_navigate.js"?>
var pfilename = new Array();
var pix = 0;
<?nextrec?>
pfilename[pix] = "=$title&f$=.html";
pix++;
<?loop?>
var pmax = pix;

var now = new Date();
var seed = now.getTime() % 0xffffffff;

function rand(n) {
  seed = (0x015a4e35 * seed) % 0x7fffffff;
  return (seed >> 16) % n;
}

function setPostContent(n) {
  var thisURL = document.URL;
  var postIx = thisURL.indexOf("/posts/");
  var tagsIx = thisURL.indexOf("/tags/");
  var wisdomIx = thisURL.indexOf("/wisdom/");
  var authorsIx = thisURL.indexOf("/authors/");
  var aboutIx = thisURL.indexOf("/about/");
  var page = pfilename[n];
  if (authorsIx > 0 || tagsIx > 0) {
    page = "../../posts/" + page;
  }
  else
  if (wisdomIx < 0 && postIx < 0 && aboutIx < 0) {
    page = "posts/" + page;
  } else {
    page = "../posts/" + page;
  }
  window.location.replace(page);
}

function randomPost() {
  rq = rand(pmax);
  if (rq < 0) {
    rq = 0;
  }
  if (rq >= pmax) {
    rq = pmax - 1;
  }
  setPostContent (rq);
}

function firstPost() {
  var pix = 0;
  setPostContent(pix);
}

function lastPost() {
  var pix = pmax - 1;
  setPostContent(pix);
}

function nextPost() {
  bumpPostIx(1);
}

function priorPost() {
  bumpPostIx(-1);
}

function bumpPostIx(inc) {
  var thisURL = document.URL;
  var lastSlash = thisURL.lastIndexOf("/");
  var thisPage = thisURL.substr(lastSlash + 1);
  var pix = 0;
  var found = false;
  while (pix < pmax && (! found)) {
    var page = pfilename[pix];
    if (thisPage == page) {
      found = true;
    } else {
      pix++;
    }
  }
  if (found) {
    pix = pix + inc;
    if (pix >= pmax) {
      pix = 0;
    }
    if (pix < 0) {
      pix = pmax - 1;
    }
    setPostContent(pix);
  } else {
    setPostContent(0);
  }
}
