import os, sys

found = False

# defaults to what CodeCoverage.cmake was doing:
p = os.path.join(os.path.dirname(sys.executable), '..', 'lib', 'python2.7', 'site-packages'); 
if (os.path.exists(p)):
    sys.stdout.write(p)
    found = True

# locate in sys.path otherwise, which seems to be where to look if installed via pip and (hopefully) packages.
if not found:
    for p in sys.path:
        if (os.path.exists(os.path.join(p, 'lcov_cobertura.py'))):
            found = True
            sys.stdout.write(p)
            break

if not found:
    sys.stdout.write('path to lcov_cobertura.py not found!')
    sys.exit(1)

