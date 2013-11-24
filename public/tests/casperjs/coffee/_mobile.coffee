casper.then ->
  casper.test.begin 'Mobile optimized check', 1, (test) ->
    test.assertExists('link[rel="apple-touch-icon"]', "favicon is set")
    test.assertExists('meta[name="viewport"]', "viewport is set")
