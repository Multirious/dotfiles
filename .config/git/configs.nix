{ ... }:
{
  config = /* git-config */ ''
    [init]
    	defaultBranch = main
    [core]
    	editor = hx
    	autocrlf = input
    	safecrlf = false
    [user]
    	name = Multirious
    	email = multirious@outlook.com
    	signingkey = /home/peach/.ssh/id_ed25519.pub
    [pull]
    	rebase = true
    [gpg]
    	format = ssh
  '';
}
