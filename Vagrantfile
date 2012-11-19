host_ip = '192.168.3.14'
rvm_ruby="ruby-1.9.3-p327"

envars = %{GMAIL_PASSWORD GMAIL_USER MYSQL_ROOT_PWD MYSQL_PWD OS_SERVER_NAME OS_DNS_DOMAIN}
envars = envars.split(" ")

envars_defined = true
envars.each { |e| ENV[e].nil? ? envars_defined = false : nil }

if not envars_defined
   puts "morate definisati OS envars #{envars.join(' ') }"
   require 'pp'
   pp ENV
   exit 1
end

gitlab_repos = ENV["GITLAB_REPOS"]
if gitlab_repos.nil?
  gitlab_repos = "git://github.com/hernad/gitlabhq.git"
end

gitlab_version = ENV["GITLAB_VERSION"]
if gitlab_version.nil?
  gitlab_version = "master"
end


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

    if ENV['GMAIL_PASSWORD'].nil? or ENV['GMAIL_USER'].nil?
       puts "morate definisati GMAIL_PASSWORD = #{ENV['GMAIL_PASSWORD']} i GMAIL_USER = #{ENV['GMAIL_USER']} environment varijable koje ce koristiti postfix !"
       exit 1
    end
    chef.json = {
     :rvm => {
        :rubies => [ rvm_ruby ],
        :default_ruby => '1.9.3',
        :group_users => ["vagrant", "www-data"],
        :global_gems => [
          { :name => 'bundler'},
          { :name => 'rake'},
          { :name => 'sshkey'},
          { :name => 'chef'}
        ],
        :gems => {
           rvm_ruby => [ { :name   => 'unicorn-rails' } ]
        },

      },
      :postfix => {
           "mail_relay_networks" => host_ip + "/32",
           "mail_type" => "client", #ako hocemo da bude relayhost onda je on mail type
           "mydomain" => "test.out.ba",
           "myorigin" => "test.out.ba",
           "smtp_use_tls" => "yes",
           "relayhost" => "[smtp.gmail.com]:587",
           "smtp_tls_cafile" => "/etc/ssl/certs/ca-certificates.crt",
           "smtp_sasl_security_options" => "",
           "smtp_sasl_auth_enable" => "yes",
           "smtp_sasl_user_name" => ENV['GMAIL_USER'],
           "smtp_sasl_passwd" => ENV['GMAIL_PASSWORD']
      },
      
  
      :mysql => { "server_root_password" => ENV['MYSQL_ROOT_PWD'] },
      :gitlab => {
        "site" => ENV['OS_SERVER_NAME'],
        "https"  => true,
        "project_limit" => "20",
        "email" => ENV['GMAIL_USER'],
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
        "git_revision" => gitlab_version,
        "git_repository" => gitlab_repos,
        "app_home" => "/opt/gitlab",
        "ruby" => rvm_ruby,
        "rvm_gemset" => "gitlab",
         "db" => {
           "rails_adapter" => "mysql2", #ruby 1.9 expects mysql2
           "db_name" => "gitlab_production",
           "db_name_test" => "gitlab_test",
           "db_name_development" => "gitlab_development",
           "db_user" => "gitlab",
           "db_pass" => ENV['MYSQL_PWD'],
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
