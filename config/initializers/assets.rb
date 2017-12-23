# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
# Bootstrap uses depend_on_asset in _glyphicons.scss which does not respect $icon-font-path.
# Thus the font directory of bootstrap has to be added to the asset search paths.
# https://github.com/twbs/bootstrap-sass/issues/592#issuecomment-46108968
Rails.application.config.assets.paths << Rails.root.join('node_modules', 'bootstrap-sass', 'assets', 'fonts', 'bootstrap')

# Bootstrap sass files, installed by npm
Rails.application.config.assets.paths << Rails.root.join('node_modules', 'bootstrap-sass', 'assets', 'stylesheets')
