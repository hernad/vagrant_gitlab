Vagrant::Config.run do |config|
  config.vm.box = "precise32-b2"
  #config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :hostonly, '192.168.3.14'
  #config.vm.boot_mode = :gui

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks']

    chef.add_recipe('build-essential')
    chef.add_recipe('rvm::system')


    #chef.add_recipe('database::mysql')

    chef.add_recipe('mysql::client')
    chef.add_recipe('mysql::ruby')
    #chef.add_recipe('mysql::server')


    chef.add_recipe('postgresql::client')
    chef.add_recipe('postgresql::ruby')


    chef.add_recipe('gitlab::default')
    chef.add_recipe('gitlab::nginx')
    chef.add_recipe('gitlab::database')

    chef.json = {
     :rvm => {
        :rubies => [ "1.9.3-p286" ],
        :default_ruby => '1.9.3',
        :group_users => ["vagrant", "www-data"],
        :global_gems => [
          { :name => 'bundler'},
          { :name => 'rake'},
          { :name => 'chef'}
        ],
        :gems => {
           'ruby-1.9.3-p286' => [
                    { :name   => 'unicorn-rails' }
                   ]
        },

      },

      :mysql => { "server_root_password" => "rootpwd" },

      :gitlab => {
        "user" => "www-data",
        "group" => "www-data",
        "home" => "/var/www",
        "git_revision" => "master",
        "git_repository" => "git://github.com/hernad/gitlabhq.git",
        "app_home" => "/opt/gitlab",
        "app_server_name" => "gitlab.test.out.ba",
        "ruby" => "ruby-1.9.3-p286",
        "rvm_gemset" => "gitlab",
        "gitolite" => {
            "user" => "git",
            "group" => "git",
            "git_home" => "/var/git",
            "app_home" => "/var/git/gitolite",
            "umask" => "0007",
            "url" => "git://github.com/sitaramc/gitolite.git"
         },
         "unicorn_conf" => {
            "pid" => "/tmp/pids/unicorn.pid",
            "sock" => "/tmp/sockets/unicorn.sock",
            "error_log" => "unicorn.error.log",
            "access_log" => "unicorn.access.log"
         },
         "db" => {
           "rails_adapter" => "mysql2", #ruby 1.9 expects mysql2
           "db_name" => "gitlab_production",
           "db_name_test" => "gitlab_test",
           "db_name_development" => "gitlab_development",
           "db_user" => "gitlab",
           "db_pass" => "pwd",
           "db_host" => "localhost",
           "load_sql_file" => nil
         }
      }
    }
  end
end
