name "gitlab"
description "gitlab server"

run_list "recipe[build-essential]", "recipe[rvm::system]", 
         "recipe[mysql::client]", "recipe[mysql::ruby]", 
         "recipe[postgresql::client]", "recipe[postgresql::ruby]",
         "recipe[gitlab::default]", "recipe[gitlab::nginx]", "recipe[gitlab::database]"

#env_run_lists "prod" => ["recipe[apache2]"], "staging" => ["recipe[apache2::staging]"], "_default" => []
#default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }
#override_attributes "apache2" => { "max_children" => "50" }   

envars = %{GMAIL_PASSWORD GMAIL_USER MYSQL_ROOT_PWD MYSQL_PWD}
envars = envars.split(" ")

envars_defined = true
envars.each { |e| ENV[e].nil? ? envars_defined = false : nil }

if not envars_defined
   puts "morate definisati OS envars #{envars.join(' ') }"
   require 'pp'
   pp ENV
   exit 1
end

override_attributes(
      :rvm => {
        :rubies => [ "1.9.3-p286" ],
        :default_ruby => '1.9.3',
        :group_users => ["www-data"],
        :global_gems => [
          { :name => 'bundler'},
          { :name => 'rake'},
          { :name => 'sshkey'},
          { :name => 'chef'}
        ],
        :gems => {
           'ruby-1.9.3-p286' => [ { :name   => 'unicorn-rails' } ]
        },
      },
      :postfix => {
           "mail_relay_networks" => "127.0.0.1/8",
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
        "git_max_size" => 5242880,  #5 megabytes,
        "user" => "www-data",
        "group" => "www-data",
        "home" => "/var/www",
        "git_revision" => "master",
        "git_repository" => "git://github.com/hernad/gitlabhq.git",
        "app_home" => "/opt/gitlab",
        "ruby" => "ruby-1.9.3-p286",
        "rvm_gemset" => "gitlab",
         "db" => {
           "rails_adapter" => "mysql2", #ruby 1.9 expects mysql2
           "db_name" => "gitlab",
           "db_name_test" => "gitlab_test",
           "db_name_development" => "gitlab_development",
           "db_user" => "gitlab",
           "db_pass" => ENV['MYSQL_PWD'],
           "db_host" => "localhost",
           "load_sql_file" => nil
         }
      }
)
