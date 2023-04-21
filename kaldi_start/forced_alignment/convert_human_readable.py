from pathlib import Path

### Create phone and word dictionary
lang_dir = Path("data/lang_chain")
phone_file = lang_dir / "phones.txt"
words_file = lang_dir / "words.txt"

with phone_file.open("r", encoding="utf-8") as f:
	data = f.readlines()

	phone_dict = {}

	for line in data:
		line = line.rstrip()
		phone, idx = line.split()
		if "_" in phone:
			phone = phone.split("_")[0]
		phone_dict[idx] = phone

with words_file.open("r", encoding="utf-8") as f:
	data = f.readlines()

	word_dict = {}

	for line in data:
		line = line.rstrip()
		word, idx = line.split()
		if word == "<eps>":
			word = "sil"
		word_dict[idx] = word

pron_file = Path("exp/tdnn_7b_chain_online/decode_example/1.prons")

with pron_file.open("r", encoding="utf-8") as inputfh:
	data = inputfh.readlines()

	for line in data:
		line = line.rstrip()
		items = line.split()
		start_time = int(items[1]) * 0.01
		dur = items[2]
		word = items[3]
		phones = items[4:]

		if len(phones) == 1:
			duration = int(dur) * 0.01
			print(round(start_time, 3), round(start_time + duration, 3), word_dict[word], phone_dict[phones[0]])
		else:
			durs = dur.split(",")

			for d, p in zip(durs, phones):
				duration = int(d) * 0.01
				print(round(start_time, 3), round(start_time + duration, 3), word_dict[word], phone_dict[p])
				start_time = start_time + duration