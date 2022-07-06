all: build run

build:
	docker build -f dockerfile -t geos639:latest .

run:
	bash build_start_geos639_container.sh 2>&1 | tee log

clean:
	rm -rf home/.ipython home/.jupyter home/.condarc \
			home/.cache home/.conda home/.bash_history \
			home/.bashrc home/.local/share home/.ipynb_checkpoints \
			home/.local/bin home/.local/lib home/.local/etc \
			home/.local/envs/unavco home/.local/envs/.conda_envs_dir_test \
			home/.config home/work home/.local/ARIA-tools home/.local/MintPy \
			home/.local/PyAPS home/ARIA-tools-docs home/.bash_profile home/.viminfo

restart: clean all