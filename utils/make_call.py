from html import escape

def make_call(message: str, client, to_number: str, from_number: str, public_base_url: str, respond_to:str | None=None):
    if not public_base_url:
        raise ValueError("PUBLIC_BASE_URL must be set to your public HTTPS server URL.")

    base_url = public_base_url.rstrip("/")
    recording_action_url = base_url + "/recording_finished"
    recording_status_callback_url = base_url + "/process_recording"
    twiml = f"""
        <Response>
            <Say voice="alice">
                {escape(message)}
            </Say>
            <Say>
                Please leave your message after the beep.
                Press 0 when you are finished.
            </Say>
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
    # TODO: create a seperate table for call logs. from->to. update "to" everytime, if from is already present. store the numbers with their names.you can use call.sid for unique call. rec req will contain so search wil be easy
    print("Call initiated!")
    return call.sid
