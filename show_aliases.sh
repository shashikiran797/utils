cat ~/.zshrc | grep alias | awk '{ sub(/alias /,"");sub(/=/, "\t"); print }' | grep --color=always "^.*\t"