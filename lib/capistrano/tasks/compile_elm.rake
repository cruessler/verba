namespace :deploy do
  desc "Compile Elm modules"
  task :compile_elm do
    on roles(:all) do
      within release_path do
        execute :npm, :run, :build
      end
    end
  end
end
