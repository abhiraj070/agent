def make_call(message, client, to_number, from_number):
    twiml = f"""
        <Response>
            <Say voice="alice">
                {message}
            </Say>
            <Record
                maxLength="60"
                action="https://your-server.com/process_recording"/>
        </Response>
        """
    call = client.calls.create(
        twiml=twiml,
        to=to_number,
        from_=from_number,
    )
    print("Call initiated!")
    return call.sid