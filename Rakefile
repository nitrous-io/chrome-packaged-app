require 'rubygems'
require 'bundler'
require 'logger'
require 'fileutils'
require 'json'

Bundler.require

ROOT_DIR    = File.expand_path(File.dirname(__FILE__))
LOGGER      = Logger.new(STDOUT)
BUNDLES     = %w( manifest.json app.css app.js )
BUILD_DIR   = "build"
SOURCE_DIR  = "src/"
VENDOR_DIR  = "vendor/"

task :advertise_target do
  ENV['TARGET'] ||= 'development'
  puts "Building #{ENV['TARGET']} release...\n\n"
end

task :compile do
  puts 'Compiling assets'

  sprockets = Sprockets::Environment.new(ROOT_DIR) do |env|
    env.cache = Sprockets::Cache::FileStore.new('tmp/sprockets')
    env.logger = LOGGER
  end

  sprockets.context_class.class_eval do
    def config
      config_file = File.join(ROOT_DIR, 'config.json')
      JSON.parse(IO.read(config_file)).fetch(ENV['TARGET']) do |t|
        raise "Cannot find configuration for target - #{t}.\nYou can define it in config.json."
      end
    end
  end

  # integrate emblem
  Emblem::Sprockets.integrate sprockets

  sprockets.append_path File.join(ROOT_DIR, SOURCE_DIR)
  sprockets.append_path File.join(ROOT_DIR, SOURCE_DIR, 'javascripts')
  sprockets.append_path File.join(ROOT_DIR, SOURCE_DIR, 'templates')
  sprockets.append_path File.join(ROOT_DIR, SOURCE_DIR, 'stylesheets')

  # use ember and handlebars from gems
  sprockets.append_path Ember::Source.bundled_path_for('')
  sprockets.append_path File.dirname(Handlebars::Source.bundled_path)

  sprockets.append_path File.join(ROOT_DIR, VENDOR_DIR)

  target = ENV['TARGET']

  BUNDLES.each do |bundle|
    asset = sprockets.find_asset(bundle)
    prefix = asset.pathname.to_s.split('/')[-2]

    if prefix == 'src'
      prefix = ''
    end

    FileUtils.mkpath File.join(BUILD_DIR, target, prefix)
    asset.write_to File.join(BUILD_DIR, target, prefix, bundle)
  end

  puts 'Compiled assets'
end

task :build => [:advertise_target, :compile] do
  target = ENV['TARGET']
  # copy other resources
  ['icons',
   'background.js',
   'index.html',
   'webfonts'
  ].each do |resource|
    cmd = "cp -r #{File.join SOURCE_DIR, resource} #{File.join BUILD_DIR, target}"
    puts cmd
    system cmd
  end

  # copy font-awesome fonts
  cmd = "cp -r vendor/font-awesome/font #{File.join BUILD_DIR, target}"
  puts cmd
  system cmd

  puts 'Finished building package. Please reload Chrome package to reflect the changes.'
end

%w(development staging production).each do |target|
  desc "build for #{target}"
  task target do
    ENV['TARGET'] = target
    Rake::Task["build"].invoke
  end
end

task :default => :build
