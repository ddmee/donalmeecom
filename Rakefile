task default: [:build]

task :build do
    puts "Building site, including search"
    sh("bundle exec jekyll build -d docs")
    sh("cd docs && bundle exec just-the-docs rake search:init")
end

task :serve do
    puts "Serving site"
    sh("bundle exec jekyll serve")
end
