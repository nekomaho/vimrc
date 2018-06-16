require "yaml"

class ConfigSettings
  attr_reader :dotfiles_dir,:src,:app,:vim_clone_path,:qfixhowm_path

  def initialize(input_config_file=nil)
    @input_config_file = input_config_file
    @home = "#{ENV["HOME"]}"
    @dotfiles_dir = "#{@home}/#{config[:DOTFILE_PATH]}"
    @src = "#{@home}/src"
    @app = "#{@home}/app"
    @vim_clone_path = "#{@src}/vim"
    @qfixhowm_path = "#{@home}/.qfixhowm"
  end

  def zshrc_home_path
    "#{@home}/.zshrc"
  end

  def zshrc_path
    "#{@dotfiles_dir}/.zshrc"
  end

  def zsh_install_path
    config[:ZSH_INSTALL_PATH]
  end

  def vimrc_home_path
    "#{@home}/.vimrc"
  end

  def vimrc_path
    "#{@dotfiles_dir}/.vimrc"
  end

  def vim_install_path
    config[:VIM_INSTALL_PATH]
  end

  private

  def config_file
    @config_file ||= @input_config_file || "config.yml"
  end

  def config
    @config ||= YAML.load_file(config_file).map{ |k,v| [k.to_sym, v] }.to_h
  end
end

