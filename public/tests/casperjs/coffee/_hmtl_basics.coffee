exports = casper.then ->

  casper.test.begin 'HTML-Basics check', 1, (test) ->
    test.assertExists('title', "head>title exists")
    test.assertExists('meta[charset="UTF-8"]', "charset is utf-8")
    test.assertExists('link[rel="shortcut icon"]', "favicon exists")
