#!/usr/bin/env bash

stage=0
nj=1
set -e

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.
. ./path.sh
. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.

# steps/get_prons.sh --cmd run.pl --lmwt 10 \
# 	data/example data/lang_chain exp/tdnn_7b_chain_online/decode_example

dir=exp/tdnn_7b_chain_online/decode_example
model=$dir/../final.mdl
lang=data/lang_chain

# steps/get_ctm.sh --cmd run.pl --use-segments false \
# 	data/example $lang $dir

nspk=$(wc -l <data/example/spk2utt)

# $cmd JOB=1:$nspk $dir/log/nbest_to_prons.JOB.log \
#     lattice-1best --lm-scale=$lmwt "ark:gunzip -c $dir/lat.JOB.gz|" ark:- \| \
#     $align_words_cmd \| \
#     nbest-to-prons $mdl ark:- "|gzip -c >$dir/prons.JOB.gz" || exit 1;

$train_cmd $dir/log/nbest_to_prons.log \
	lattice-1best --acoustic-scale=0.1 "ark:gunzip -c $dir/lat.1.gz|" ark:- \| \
	lattice-align-words $lang/phones/word_boundary.int $model ark:- ark:- \| \
	nbest-to-prons --print-lengths-per-phone $model ark:- $dir/1.prons