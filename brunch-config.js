// See http://brunch.io for documentation.
exports.config = {
  files: {
    javascripts: {joinTo: 'javascripts/brunch.js'}
  },

  conventions: {
    assets: /^app\/assets\/images/
  },

  paths: {
    public: 'public/assets',
    watched: ['app/assets/javascripts', 'app/assets/elm']
  },

  plugins: {
    elmBrunch: {
      mainModules:
        ['app/assets/elm/Question.elm'],
      outputFolder: 'public/assets/javascripts',
      outputFile: 'elm.js'
    }
  },

  modules: {
    autoRequire: {
      "javascripts/brunch.js": [
        "assets/javascripts/application.js"
      ]
    }
  },

  npm: {
    enabled: true,
    globals: {
      $: 'jquery',
      jQuery: 'jquery'
    }
  },

  notifications: false
};
