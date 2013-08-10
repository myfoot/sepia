require 'fileutils'

namespace :settings do
  SETTINGS_SRC = 'config/settings.yml.sample'
  SETTINGS_DEST = 'config/settings.yml'

  desc 'copy settings.yml.sample to settings.yml (if not exist)'
  task :init do
    FileUtils.cp(SETTINGS_SRC, SETTINGS_DEST) unless File.exist? SETTINGS_DEST
  end

  desc 'copy settings.yml.sample to settings.yml (force update)'
  task :update do
    FileUtils.cp(SETTINGS_SRC, SETTINGS_DEST)
  end
end
