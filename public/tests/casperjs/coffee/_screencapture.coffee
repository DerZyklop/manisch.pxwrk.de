casper.then ->

  casper.viewport 320, 480, ->
    @wait 1000, ->
      this.captureSelector('screenshots/iphone_480x320.png', 'body')

      casper.viewport 1024, 768, ->
        this.captureSelector('screenshots/ipad_1024x768.png', 'body')

      casper.viewport 1280, 800, ->
        this.captureSelector('screenshots/macbook13_1280x800.png', 'body')

      casper.viewport 1440, 900, ->
        this.captureSelector('screenshots/macbook15_1440x900.png', 'body')




      casper.viewport 1280, 800, ->
        this.captureSelector('screenshots/macbook15_1280x800.png', 'body')
