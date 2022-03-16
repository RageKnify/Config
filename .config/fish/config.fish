starship init fish | source
env _ZO_ECHO=1 zoxide init fish | source
# Ctrl+T file-widget
# Ctrl+R history-widget
# Alt+D cd-widget
fzf_key_bindings

# opam configuration
source /home/jp/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
