// Collapsible nav. The .js class is set in <head> before paint, so the
// collapsed layout is never applied to a page that cannot toggle it.
(function () {
  var toggle = document.querySelector('.nav__toggle');
  var links = document.getElementById('nav-links');
  if (!toggle || !links) return;

  function setOpen(open) {
    toggle.setAttribute('aria-expanded', String(open));
    if (open) {
      links.setAttribute('data-open', '');
    } else {
      links.removeAttribute('data-open');
    }
  }

  toggle.addEventListener('click', function () {
    setOpen(toggle.getAttribute('aria-expanded') !== 'true');
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && toggle.getAttribute('aria-expanded') === 'true') {
      setOpen(false);
      toggle.focus();
    }
  });

  // Following a link inside the panel leaves it open behind the next page in
  // browsers that restore from bfcache.
  links.addEventListener('click', function (e) {
    if (e.target.closest('a')) setOpen(false);
  });

  // Resizing past the breakpoint reveals the links again; the button's state
  // would otherwise disagree with what is on screen.
  var mq = window.matchMedia('(max-width: 600px)');
  var onChange = function (e) { if (!e.matches) setOpen(false); };
  if (mq.addEventListener) mq.addEventListener('change', onChange);
  else mq.addListener(onChange);
})();
