VADER_OUTPUT_FILE = vader_output

.PHONY : test
test :
	export VADER_OUTPUT_FILE $(VADER_OUTPUT_FILE)
	rm -f $(VADER_OUTPUT_FILE)
	nvim -u NONE \
	    -c 'set runtimepath=.,./after,$$VIMRUNTIME,~/.config/nvim/plugged/vader.vim' \
	    -c 'runtime plugin/erlgoto.vim' \
	    -c 'runtime plugin/vader.vim' \
	    -c 'filetype plugin indent on' \
	    -c 'Vader! tests/*' \
	    && echo Success || cat $(VADER_OUTPUT_FILE)
