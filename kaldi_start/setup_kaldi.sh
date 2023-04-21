### Clone official Kaldi repository
# git clone https://github.com/kaldi-asr/kaldi.git

### Move to the cloned directory and install Kaldi
cd kaldi/tools

### First, install prerequisites for KALDI
# Check pre-requisite. If there are any prereqs that
# needs to be installed, it will appear hear. 
# The following three packages were not installed in 
# my Mac, but it is possible that you already have 
# those installed. 
# For python2.7, you will need to install it from web
# https://www.python.org/downloads/release/python-2716/
brew install gfortran 
brew install subversion
# Install intel mkl-service
# https://software.intel.com/mkl/choose-download
bash extras/check_dependencies.sh

# Run "make" to install tools/
# It can take few minutes
make -j 4

### Second, we need to install source files
# First, run ./configure in src/
cd ../src
./configure

# And then run "make" to install src
# It can take few minutes
make depend -j 4
make -j 4
