// See http://brunch.io for documentation.
exports.config = {
  files: {
    javascripts: {joinTo: {'javascripts/brunch.js': /^app/}}
  },

  conventions: {
    assets: /^app\/assets\/images/
  },

  paths: {
    public: 'public/assets',
    watched: ['app/assets/javascripts/elm.js', 'app/assets/elm']
  },

  plugins: {
    elmBrunch: {
      mainModules:
        ['app/assets/elm/Question.elm'],
      outputFolder: 'app/assets/javascripts',
      outputFile: 'elm.js'
    }
  },
  notifications: false
};
