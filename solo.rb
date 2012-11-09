file_cache_path "."
cookbook_path   [ "cookbooks", "site-cookbooks"]
role_path       "roles"

name "my gitlab"
description "Gitlab Server"
run_list(
    "recipe[gitlab]"
)
