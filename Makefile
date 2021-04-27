VADER_OUTPUT_FILE = vader_out

.PHONY : test
test :
	export VADER_OUTPUT_FILE $(VADER_OUTPUT_FILE)
	nvim -u NONE \
	    -c 'set runtimepath=.,$$VIMRUNTIME,~/.config/nvim/plugged/vader.vim' \
	    -c 'runtime plugin/vader.vim' \
	    -c 'filetype plugin indent on' \
	    -c 'Vader!*' \
	    && echo Success || cat $(VADER_OUTPUT_FILE)
