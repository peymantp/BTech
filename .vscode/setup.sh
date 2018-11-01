python -mplatform | grep -qi Ubuntu && sudo apt install code -y || sudo dnf install code -y

#list of extentions
declare -a arr=(
	"13xforever.language-x86-64-assembly"
	"austin.code-gnu-global"
	"azaugg.vscode-python-docstring"
	"CoenraadS.bracket-pair-colorizer"
	"DavidAnson.vscode-markdownlint"
	"dbaeumer.jshint"
	"dbaeumer.vscode-eslint"
	"EditorConfig.EditorConfig"
	"eg2.tslint"
	"formulahendry.code-runner"
	"HookyQR.beautify"
	"johnpapa.Angular2"
	"Mikael.Angular-BeastCode"
	"ms-python.python"
	"ms-vscode.cpptools"
	"ms-vscode.csharp"
	"ms-vscode.Go"
	"msjsdiag.debugger-for-chrome"
	"Mukundan.python-docs"
	"PeterJausovec.vscode-docker"
	"tomoki1207.pdf"
)
#iterate and install"
for i in "${arr[@]}"
do
   code --install-extension "$i"
done