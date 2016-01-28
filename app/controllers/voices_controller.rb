include Plivo

class VoicesController < ApplicationController
  # Very important, avoid CSRF protection by Twilio
  skip_before_action :verify_authenticity_token

  def receive
    @r = Response.new()
    @r.addSpeak('Hello, we are connect')
    puts @r.to_xml()

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: 'application/xml'
  end

  # http://lvh.me:3000/forward
  def forward
    from_number = params[:From]
    @r = Response.new()
    d = @r.addDial({'callerId' => from_number,
                    'action' => 'https://aircall.herokuapp.com/plivo_answer',
                    'method' => 'POST',
                    'redirect' => 'true'})

    # Call all the app of each user
    UserNumber.all.each do |sip_app|
      forwarding_app = sip_app.sip_endpoint
      d.addUser(forwarding_app)
    end

    puts @r.to_xml()

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: 'application/xml'
  end

  def save_call
    to = params['DialBLegTo']
    from = params['From']
    if !to
      @r = Response.new()
      @r.addSpeak('Please leave a message after the beep')
      @r.addRecord({'action' => 'https://aircall.herokuapp.com/get_recording',
                    'maxLength' => '30'})
      puts @r.to_xml()

      render xml: @r.to_s, content_type: 'application/xml'
    else
      Call.create(number_from: from, number_to: to)
      render nothing: true
    end
  end

  def get_recording
    url_voicemail = params['RecordUrl']
    from = params['From']
    to = params['DialBLegTo']
    Call.create(url_voicemail: url_voicemail, number_from: from, number_to: to)
    render nothing: true
  end

  def hangup
    render nothing: true
  end

  def calls
    @calls = Call.all
  end

end
