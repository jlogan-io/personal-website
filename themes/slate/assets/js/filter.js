// Filter the post list in place. The pills are real links to the category
// archives, so this is an enhancement: without it they still navigate.
(function () {
  var pills = document.querySelectorAll('.filter');
  var rows = document.querySelectorAll('.post-row');
  if (!pills.length || !rows.length) return;

  function apply(key) {
    rows.forEach(function (row) {
      row.hidden = !(key === 'all' || row.dataset.category === key);
    });
    pills.forEach(function (p) {
      p.setAttribute('aria-current', String(p.dataset.filter === key));
    });
    // Keep the last visible row from carrying a rule into open space.
    var visible = Array.prototype.filter.call(rows, function (r) { return !r.hidden; });
    Array.prototype.forEach.call(rows, function (r) { r.style.borderBottomWidth = ''; });
    if (visible.length) visible[visible.length - 1].style.borderBottomWidth = '0';
  }

  Array.prototype.forEach.call(pills, function (pill) {
    pill.addEventListener('click', function (e) {
      e.preventDefault();
      apply(pill.dataset.filter);
      // Reflect the choice in the URL without navigating, so the view is
      // shareable and Back returns to the previous filter.
      var url = pill.dataset.filter === 'all'
        ? location.pathname
        : location.pathname + '?category=' + pill.dataset.filter;
      history.pushState({ filter: pill.dataset.filter }, '', url);
    });
  });

  window.addEventListener('popstate', function () {
    apply(new URLSearchParams(location.search).get('category') || 'all');
  });

  apply(new URLSearchParams(location.search).get('category') || 'all');
})();
