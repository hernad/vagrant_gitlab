name "gitlab"
description "gitlab server"

run_list "recipe[build-essential]", "recipe[rvm::system]", "recipe[mysql::client]", "recipe[mysql::ruby]", "recipe[postgresql::client]", "recipe[postgresql:ruby]"
#env_run_lists "prod" => ["recipe[apache2]"], "staging" => ["recipe[apache2::staging]"], "_default" => []
#default_attributes "apache2" => { "listen_ports" => [ "80", "443" ] }
#override_attributes "apache2" => { "max_children" => "50" }   

if ENV['GMAIL_PASSWORD'].nil? or ENV['GMAIL_USER'].nil?
    puts "morate definisati GMAIL_PASSWORD = #{ENV['GMAIL_PASSWORD']} i GMAIL_USER = #{ENV['GMAIL_USER']} environment varijable koje ce koristiti postfix !"
    exit 1
end

override_attributes(
      :rvm => {
        :rubies => [ "1.9.3-p286" ],
        :default_ruby => '1.9.3',
        :group_users => ["vagrant", "www-data"],
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
      :mysql => { "server_root_password" => "rootpwd" },
      :gitlab => {
        "site" => "gitlab.test.out.ba",
        "https"  => true,
        "project_limit" => "20",
        "email" => "bakir.husremovic@bring.out.ba", 
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
)
