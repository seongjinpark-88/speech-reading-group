#!/usr/bin/env bash

stage=0
nj=30
set -e

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.
. ./path.sh
. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.

if [ $stage -le 1 ]; then
	steps/online/nnet3/prepare_online_decoding.sh --mfcc-config conf/mfcc_hires.conf \
		data/lang_chain exp/nnet3/extractor exp/chain/tdnn_7b exp/tdnn_7b_chain_online

	utils/mkgraph.sh --self-loop-scale 1.0 \
		data/lang_pp_test exp/tdnn_7b_chain_online exp/tdnn_7b_chain_online/graph_pp
fi

if [ $stage -le 2 ]; then
	utils/fix_data_dir.sh data/example

	dir="exp/tdnn_7b_chain_online"
	graphdir="exp/tdnn_7b_chain_online/graph_pp"

	nspk=$(wc -l <data/example/spk2utt)

	steps/online/nnet3/decode.sh \
		--acwt 1.0 --post-decode-acwt 10.0 \
		--cmd "run.pl" --nj $nspk --skip_scoring true \
		--beam 16.0 \
		$graphdir data/example ${dir}/decode_example || exit 1
fi