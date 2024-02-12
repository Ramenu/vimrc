#!/bin/bash

nvim_data_dir="${HOME}/.local/share/nvim"
[[ ${XDG_DATA_HOME} ]] && nvim_data_dir="${XDG_DATA_HOME}/nvim"

if [[ -d "${nvim_data_dir}" ]]; then
	echo "error: please delete the '${nvim_data_dir}' before installation can proceed"
else
	mkdir -p "${nvim_data_dir}"
fi


sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s $(pwd)/plugged "${nvim_data_dir}/plugged"
echo 'success: installation complete'
