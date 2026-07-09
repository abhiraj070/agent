from pathlib import Path

from twilio.rest.insights.v3 import query


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
    # TODO: create a resold dict of from_user_number, name, to_user_number, name, message.
    # resul={query_user:}
    # TODO: send this test to WhatsApp/UI.
    print(text)
    return text
