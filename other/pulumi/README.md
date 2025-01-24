
Install Pulumi:
curl -fsSL https://get.pulumi.com | sh

Install k0s in cluster mode:
curl -sSLf http://get.k0s.sh | sudo sh

sudo mkdir -p /etc/k0s

sudo tee /etc/k0s/k0s.yaml <<< "$(sudo k0s config create)"

brew install k0sproject/tap/k0sctl

ssh-keygen -t rsa -b 4096 -f ~/.ssh/k0s_key
ssh-copy-id -i ~/.ssh/k0s_key.pub user@server_address

k0sctl init > k0sctl.yaml
add 3 extra workers and change the ip address

sudo k0sctl apply --config k0sctl.yaml
