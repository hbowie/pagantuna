var pfilename = new Array();
var pix = 0;
pfilename[pix] = "software-is-different.html";
pix++;
pfilename[pix] = "the-documentation-dilemma.html";
pix++;
pfilename[pix] = "art-as-apple-strategy.html";
pix++;
pfilename[pix] = "why-is-software-documentation-so-hard.html";
pix++;
pfilename[pix] = "purpose-driven-documentation.html";
pix++;
pfilename[pix] = "the-progress-polarity.html";
pix++;
pfilename[pix] = "the-4-d-lifecycle.html";
pix++;
pfilename[pix] = "to-cots-or-not-that-is-the-question.html";
pix++;
pfilename[pix] = "customer-communication.html";
pix++;
pfilename[pix] = "the-process-prescription-polarity.html";
pix++;
pfilename[pix] = "12-secrets-to-application-development-nirvana.html";
pix++;
pfilename[pix] = "the-requirements-problem.html";
pix++;
pfilename[pix] = "take-the-agile-train.html";
pix++;
pfilename[pix] = "the-watery-ketchup-stops-here.html";
pix++;
pfilename[pix] = "an-agile-acid-test.html";
pix++;
pfilename[pix] = "process-projects-and-customers-the-unholy-trinity.html";
pix++;
pfilename[pix] = "broken-field-running.html";
pix++;
pfilename[pix] = "getting-metrics-right.html";
pix++;
pfilename[pix] = "developmental-levels.html";
pix++;
pfilename[pix] = "model-mania.html";
pix++;
pfilename[pix] = "service-overload.html";
pix++;
pfilename[pix] = "the-dreyfus-model-of-skill-acquisition.html";
pix++;
pfilename[pix] = "process-qa.html";
pix++;
pfilename[pix] = "manage-different.html";
pix++;
pfilename[pix] = "schembechler-bacon-and-leadership.html";
pix++;
pfilename[pix] = "what-does-it-mean-to-be-world-class-it.html";
pix++;
pfilename[pix] = "ten-reasons-to-ditch-your-word-documents.html";
pix++;
pfilename[pix] = "types-of-web-sites.html";
pix++;
pfilename[pix] = "cell-phones-and-sheet-metal.html";
pix++;
pfilename[pix] = "anatomy-of-a-web-site.html";
pix++;
pfilename[pix] = "thinking-differently-about-perfectionism.html";
pix++;
pfilename[pix] = "taming-the-e-mail-monster.html";
pix++;
pfilename[pix] = "successful-business-strategies-as-recently-demonstrated-by-apple.html";
pix++;
pfilename[pix] = "the-power-of-diverse-teams.html";
pix++;
pfilename[pix] = "proposal-for-an-alternative-to-facebook.html";
pix++;
pfilename[pix] = "adaptive-startup-for-the-mac.html";
pix++;
pfilename[pix] = "tech-titans-compete.html";
pix++;
pfilename[pix] = "the-apple-checklist.html";
pix++;
pfilename[pix] = "thoughts-on-the-microsoft-surface.html";
pix++;
pfilename[pix] = "ux-and-it.html";
pix++;
pfilename[pix] = "reflections-on-postels-law.html";
pix++;
pfilename[pix] = "fighting-organizational-friction.html";
pix++;
pfilename[pix] = "the-inconvenient-truths-of-software-development.html";
pix++;
pfilename[pix] = "this-thinking-business.html";
pix++;
pfilename[pix] = "the-four-essential-attributes-of-any-organization.html";
pix++;
pfilename[pix] = "the-primary-functions-of-management.html";
pix++;
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
