python -mplatform | grep -qi Ubuntu && sudo apt install code -y || sudo dnf install code -y

#list of extentions
declare -a arr=("christian-kohler.npm-intellisense"
	"christian-kohler.path-intellisense"
	"DavidAnson.vscode-markdownlint"
	"DotJoshJohnson.xml"
	"eamodio.gitlens"
	"eg2.vscode-npm-script"
	"fknop.vscode-npm"
	"guillaumedoutriaux.name-that-color"
	"hyesun.py-paste-indent"
	"leizongmin.node-module-intellisense"
	"maddouri.cmake-tools-helper"
	"magicstack.MagicPython"
	"ms-python.python"
	"ms-vscode.cpptools"
	"ms-vscode.PowerShell"
	"pmneo.tsimporter"
	"twxs.cmake"
	"vector-of-bool.cmake-tools"
	"tomoki1207.pdf")

#iterate and install
for i in "${arr[@]}"
do
   code --install-extension "$i"
done