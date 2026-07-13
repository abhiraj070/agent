from html import escape

def make_call(message: str, client, to_number: str, from_number: str, ngrok_base_url: str) -> str:
    """Start the outbound call without waiting for a generated audio file.

    Twilio renders ``Say`` as soon as the callee answers.  Generating an MP3
    first used to put the ElevenLabs request and a local disk write directly
    on the critical path before this request could even reach Twilio.
    """
    if not ngrok_base_url:
        raise ValueError("NGROK_BASE_URL must be set to the public HTTPS server URL.")

    base_url = ngrok_base_url.rstrip("/")
    recording_action_url = base_url + "/recording_finished"
    recording_status_callback_url = base_url + "/process_recording"
    twiml = f"""
        <Response>
            <Say voice="alice">{escape(message)}</Say>
            <Record
                maxLength="60"
                method="POST"
                timeout="5"
                finishOnKey="5"
                action="{recording_action_url}"
                recordingStatusCallback="{recording_status_callback_url}"
                recordingStatusCallbackMethod="POST"
                recordingStatusCallbackEvent="completed"/>
        </Response>
        """
    call = client.calls.create(
        twiml=twiml,
        to=to_number,
        from_=from_number,
    )
    print("Call initiated!")
    return call.sid
