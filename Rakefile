require 'rubygems'
require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'

Bundler.require

ROOT        = Pathname(File.dirname(__FILE__))
LOGGER      = Logger.new(STDOUT)
BUNDLES     = %w( manifest.json app.css app.js webviewer.js )
BUILD_DIR   = ROOT.join("build")
SOURCE_DIR  = ROOT.join("src")

task :advertise_target do
  ENV['TARGET'] ||= 'development'
  puts "Building #{ENV['TARGET']} release...\n\n"
end

task :compile do
  puts 'Compiling assets'

  sprockets = Sprockets::Environment.new(ROOT) do |env|
    env.logger = LOGGER
  end

  sprockets.context_class.class_eval do
    def config
      config_file = "#{ROOT}/config.json"
      JSON.parse( IO.read(config_file)).fetch(ENV['TARGET']) {|t|
        raise "Cannot find configuration for target - #{t}.\nYou can define it in config.json." 
      } 
    end
  end

  # integrate emblem
  Emblem::Sprockets.integrate sprockets

  sprockets.append_path(SOURCE_DIR.to_s)
  sprockets.append_path(SOURCE_DIR.join('templates').to_s)
  sprockets.append_path(SOURCE_DIR.join('javascripts').to_s)
  sprockets.append_path(SOURCE_DIR.join('stylesheets').to_s)

  target = ENV['TARGET']

  BUNDLES.each do |bundle|
    assets = sprockets.find_asset(bundle)
    prefix, basename = assets.pathname.to_s.split('/')[-2..-1]

    if prefix == 'src'
      prefix = ''
    end

    FileUtils.mkpath BUILD_DIR.join(target, prefix)
    assets.write_to BUILD_DIR.join(target, prefix, bundle)
  end

  puts 'Compiled assets'
end

namespace :build do

  task :default => [:advertise_target, :compile] do
    target = ENV['TARGET']
    # copy other resources
    ['icons', 
      'background.js', 
      'index.html',
      'font'
    ].each do |resource|
      puts "Copying #{SOURCE_DIR}/#{resource} to #{BUILD_DIR}/#{target}/"
      system "cp -r #{SOURCE_DIR}/#{resource} #{BUILD_DIR}/#{target}"
    end

    puts 'Finished builiding package. Please reload Chrome package to reflect the changes.'
  end

  %w(development staging production).each do |target|
    task target do
      ENV['TARGET'] = target
      Rake::Task["build:default"].invoke
    end
  end
end

task :build => "build:default"
