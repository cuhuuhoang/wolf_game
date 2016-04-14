  # Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( custom.css)
Rails.application.config.assets.precompile += %w( admin.css admin.js admin.js.coffee)
Rails.application.config.assets.precompile += %w( *.svg *.eot *.woff *.woff2 *.ttf *.otf )
Rails.application.config.assets.precompile += %w( *.jpg *.jpeg *.png *.gif *.tiff )
Rails.application.config.assets.precompile += %w( ckeditor/* )

