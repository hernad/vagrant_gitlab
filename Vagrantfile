host_ip = '192.168.3.14'

Vagrant::Config.run do |config|
  config.vm.box = "precise32-b2"
  #config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :hostonly, host_ip 
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
           'ruby-1.9.3-p286' => [ { :name   => 'unicorn-rails' } ]
        },

      },
      :mysql => { "server_root_password" => "rootpwd" },
      :gitlab => {
        "site" => "gitlab.test.out.ba",
        "https"  => true,
        "project_limit" => "20",
        "email" => "noreply@gitlab.test.out.ba",
        "postfix" => {
             "mail_relay_networks" => host_ip + "/32",
             "mail_type" => "master",
             "mydomain" => "test.out.ba",
             "myorigin" => "test.out.ba",
             "relayhost" => "[zimbra.bring.out.ba]",
              "smtp_use_tls" => "no"
        }, 
        "use_ldap" => false,
            #host: '_your_ldap_server'
            #base: '_the_base_where_you_search_for_users'
            #port: 636
            #uid: 'sAMAccountName'
            #method: 'ssl' / plain
            #bind_dn: '_the_full_dn_of_the_user_you_will_bind_with'
            #password: '_the_password_of_the_bind_user'
        "git_max_size" => 5242880,  #5 megabytes,
        "user" => "www-data",
        "group" => "www-data",
        "home" => "/var/www",
        "git_revision" => "master",
        "git_repository" => "git://github.com/hernad/gitlabhq.git",
        "app_home" => "/opt/gitlab",
        "ruby" => "ruby-1.9.3-p286",
        "rvm_gemset" => "gitlab",
        "gitolite" => {
            "user" => "git",
            "group" => "git",
            "git_home" => "/home/git",
            "gitolite_home" => "/home/git/gitolite",
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

#~/.netrc
#machine gitlab.test.out.ba
#login bakir@bring.out.ba
#password mypwd
