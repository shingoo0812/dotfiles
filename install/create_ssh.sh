# generate ssh key
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Invoke ssh agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Copy ssh-pub-key
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
