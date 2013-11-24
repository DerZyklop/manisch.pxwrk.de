casper.then ->
  casper.test.begin 'SEO check', 1, (test) ->
    test.assertEqual(h1s.length, 1, "one h1")

    test.assertExists('meta[name="description"]', "description is set")
    test.assertExists('meta[name="keywords"]', "keywords are set")
    test.assertExists('meta[name="robots"]', "robots are set")
