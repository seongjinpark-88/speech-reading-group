# First, create example directory under kaldi/egs
mkdir ./forced_alignment

# Go into the directory and prepare necessary files
cd forced_alignment
cp ../kaldi/egs/wsj/s5/*.sh ./
ln -s ../kaldi/egs//wsj/s5/local ./
ln -s ../kaldi/egs//wsj/s5/steps ./
ln -s ../kaldi/egs//wsj/s5/utils ./
ln -s ../kaldi/egs//wsj/s5/conf ./

# Download pre-trained ASpIRE model
wget https://kaldi-asr.org/models/1/0001_aspire_chain_model.tar.gz
tar xfv 0001_aspire_chain_model.tar.gz