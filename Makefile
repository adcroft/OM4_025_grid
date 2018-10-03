# Makefile to create supergrid.nc and interpolated_topog.nc
# To use:
#   module load python
#   setenv PYTHONPATH $cwd/MIDAS
#
# then
#   make all

SHELL=tcsh -f

all: ocean_hgrid.nc
	md5sum -c md5sums.txt

showenv:
	env
	-set
	-module list
	which python
	-python --version

# Grids
supergrid.nc: mercator_supergrid.nc ncap_supergrid.nc antarctic_spherical_supergrid.nc scap_supergrid.nc local
	unlimit stacksize; setenv PYTHONPATH ./local/lib/python; python merge_grids.py

mercator_supergrid.nc ncap_supergrid.nc antarctic_spherical_supergrid.nc scap_supergrid.nc: local
	unlimit stacksize; setenv PYTHONPATH ./local/lib/python; python create_grids.py
#
# Sets char tile='tile1'
ocean_hgrid.nc: supergrid.nc
	ncks -h -d ny,80, -d nyp,80, supergrid.nc ocean_hgrid.nc
	./changeChar.py ocean_hgrid.nc tile tile1

MIDAS:
	git clone https://github.com/mjharriso/MIDAS.git
	(cd MIDAS; git checkout a067a11693d97d7993c2c6522e118490666eeae0)

local: MIDAS 
	-rm -rf $</build/*
	mkdir -p $@
	cd $<; make -f Makefile_GFDL INSTALL_PATH=../local
	touch $@


%.cdl: %.nc
	ncdump $< | egrep -v 'code_version|history' > $@

md5sums.txt: ocean_hgrid.nc antarctic_spherical_supergrid.nc mercator_supergrid.nc ncap_supergrid.nc scap_supergrid.nc supergrid.nc
	echo Grids > $@
	md5sum *supergrid.nc ocean_hgrid.nc >> $@

clean:
	rm -rf MIDAS local *.nc
