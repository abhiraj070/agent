from main import model

def download_audio(recording_sid)->str:
    segments, info = model.transcribe(f"recordings/{recording_sid}.wav")
    text = ""
    for segment in segments:
        text += segment.text + " "
    print(text)
    return text