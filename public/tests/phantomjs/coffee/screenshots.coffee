page = require('webpage').create()
page.open 'http://localhost/', ->
    page.render('../screenshots/mobile.png')
    phantom.exit()