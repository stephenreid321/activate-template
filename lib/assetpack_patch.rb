class Sinatra::AssetPack::Package

  def production_path
    app_root = Padrino.mounted_apps.find{ |app| app.name == @assets.app.name }.uri_root
    asset_path = add_cache_buster( @path, *files )
    app_root == '/' ? asset_path : ( app_root + asset_path )
  end

  def to_development_html(options={})
    app_root = Padrino.mounted_apps.find{ |app| app.name == @assets.app.name }.uri_root
    path_prefix = app_root == '/' ? '' : app_root
    paths_and_files.map { |path, file|
        path = add_cache_buster(path_prefix + path, file)  # app.css => app.829378.css
        link_tag(path, options)
    }.join("\n")
  end

end