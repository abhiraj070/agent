from pathlib import Path

def download_audio(recording_sid)->str:
    from main import model

    recordings_dir = Path("recordings")
    if recording_sid.startswith("CA"):
        raise ValueError(f"Expected a recording SID, but got a call SID: {recording_sid}")

    recording_file = recordings_dir / f"{recording_sid}.wav"
    if not recording_file.exists():
        raise FileNotFoundError(f"Recording file does not exist yet: {recording_file}")

    segments, info = model.transcribe(str(recording_file))
    text = ""
    for segment in segments:
        text += segment.text + " "
    transcript_file = recordings_dir / f"{recording_sid}.txt"
    transcript_file.write_text(text.strip())
    print(text)
    return text
