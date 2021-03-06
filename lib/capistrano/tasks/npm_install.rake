namespace :deploy do
  desc "Install asset dependencies"
  task :install_assets do
    on roles(:all) do
      within release_path do
        execute :npm, :install
      end
    end
  end

  before :compile_assets, :install_assets
  before :compile_assets, :compile_elm
end
