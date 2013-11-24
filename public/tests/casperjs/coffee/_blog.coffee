casper.then ->
  casper.test.begin 'Blog check', 1, (test) ->
    test.assertExists('link[type="application/rss+xml"][rel="alternate"]', "favicon is set")
