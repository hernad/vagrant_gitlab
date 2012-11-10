cur_dir = Dir.pwd

file_cache_path cur_dir
cookbook_path   cur_dir + "/cookbooks"
role_path       cur_dir + "/roles"

#name "my gitlab"
#description "Gitlab Server"
#run_list(
#    "recipe[gitlab]"
#)
