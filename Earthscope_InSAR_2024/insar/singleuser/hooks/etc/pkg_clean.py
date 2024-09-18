from pathlib import Path
import shutil

import sys; 
python_ver = f"python{sys.version_info.major}.{sys.version_info.minor}"

pkgs = list(Path(f'./.local/lib/{python_ver}/site-packages/').glob('*'))

togo = ['examples', 'mpldatacursor', 'hide_code', 'nbconvert', 'plumbum' 'qtpy', 'ply',
        'rise', 'jupyter_console', 'pypandoc', 'pandoc', 'qtconsole', 'traitlets', 'pdfkit']

for p in pkgs:
    for name in togo:
        if name in p.name and p.is_dir():
            shutil.rmtree(p)
            break
