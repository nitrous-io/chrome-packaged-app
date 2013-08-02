require 'rubygems'
require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'

Bundler.require

ROOT        = Pathname(File.dirname(__FILE__))
LOGGER      = Logger.new(STDOUT)
BUNDLES     = %w( app.css app.js )
BUILD_DIR   = ROOT.join("build")
SOURCE_DIR  = ROOT.join("src")

task :compile do
  sprockets = Sprockets::Environment.new(ROOT) do |env|
    env.logger = LOGGER
  end

  sprockets.append_path(SOURCE_DIR.join('javascripts').to_s)
  sprockets.append_path(SOURCE_DIR.join('stylesheets').to_s)

  BUNDLES.each do |bundle|
    assets = sprockets.find_asset(bundle)
    prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
    FileUtils.mkpath BUILD_DIR.join(prefix)

    assets.write_to(BUILD_DIR.join(prefix, bundle))
  end
end

task :build do
  # compile assets
  puts 'Compiling assets'
  Rake::Task["compile"].invoke
  puts 'Compiled assets'

  # copy other resources
  puts 'Copying rest of the resources'
  ['manifest.json', 'icons', 'background.js', 'index.html'].each do |resource|
    system "cp -r #{SOURCE_DIR}/#{resource} #{BUILD_DIR}/#{resource}"
  end

  puts 'Finished builiding package. Please reload Chrome package to reflect the changes.'
end
