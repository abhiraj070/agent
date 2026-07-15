from html import escape

from twilio.base.exceptions import TwilioRestException
from utils.twilio_client import client
from agent.config.settings import get_settings

def make_call(message: str, to_number: str, from_number: str) -> str:
    """Start the outbound call without waiting for a generated audio file.

    Twilio renders ``Say`` as soon as the callee answers.  Generating an MP3
    first used to put the ElevenLabs request and a local disk write directly
    on the critical path before this request could even reach Twilio.
    """
    _settings = get_settings()
    ngrok_base_url= _settings.NGROK_BASE_URL
    if not ngrok_base_url:
        raise ValueError("NGROK_BASE_URL must be set to the public HTTPS server URL.")

    base_url = ngrok_base_url.rstrip("/")
    recording_action_url = base_url + "/recording_finished"
    recording_status_callback_url = base_url + "/process_recording"
    call_status_callback_url = base_url + "/call-status"
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
    try:
        call = client.calls.create(
            twiml=twiml,
            to=to_number,
            from_=from_number,
            status_callback=call_status_callback_url,
            status_callback_event=["completed","initiated","ringing","answered"],
            status_callback_method="POST"
        )
    except TwilioRestException as e:
        raise e

    return call.sid
