### This example shows how to create prereq files for a single audio file.
### This can be modified to process multiple audio files.
### Seongjin Park (spark002@ets.org)

from pathlib import Path

# audio directory
audio_path = Path("/Users/seongjinpark/research/speech-reading-group/kaldi_start/audio/")

# create a directory that will contain file information
output_path = Path("forced_alignment/data/example")
output_path.mkdir(parents=True, exist_ok=True)

# create wav.scp file
with (output_path / "wav.scp").open("w", encoding="utf-8") as scpfh, \
	 (output_path / "spk2utt").open("w", encoding="utf-8") as spkfh, \
	 (output_path / "utt2spk").open("w", encoding="utf-8") as uttfh:
	for audio_file in audio_path.glob("*.wav"):
		filename = audio_file.stem
		spk, utt = filename.split("_", maxsplit=1)

		wav_scp = " ".join([
			"/usr/local/bin/ffmpeg",
			"-i",
			str(audio_file),
			"-acodec pcm_s16le",
			"-ar 16000",
			"-ac 1",
			"-f wav -|"]
		)

		scpfh.write(f"{filename} {wav_scp}\n")
		uttfh.write(f"{filename} {spk}\n")