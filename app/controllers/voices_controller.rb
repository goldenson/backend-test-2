include Plivo

class VoicesController < ApplicationController
  # Very important
  skip_before_action :verify_authenticity_token

  def receive
    @r = Response.new()
    @r.addSpeak('Hello, you just received your first call')
    puts @r.to_xml()

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: 'application/xml'
  end

  # http://lvh.me:3000/forward
  def forward
    from_number = params[:From]
    @r = Response.new()
    d = @r.addDial({'callerId' => from_number,
                    'action' => 'http://f396f33c.ngrok.io/plivo_answer',
                    'method' => 'POST',
                    'redirect' => 'true'})

    # Call all the app of each user
    UserNumber.all.each do |sip_app|
      forwarding_app = sip_app.sip_endpoint
      d.addUser(forwarding_app)
    end

    puts @r.to_xml()

    #Call.new(url_voicemail: 'efwevfw', number_from: from_number, number_to: forwarding_mobile_app).save

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: 'application/xml'
  end

  def save_call
    to = params['DialBLegTo']
    from = params['From']
    # Let a message here
    if !to
      @r = Response.new()
      @r.addSpeak('Please leave a message after the beep')
      @r.addRecord({'action' => 'http://f396f33c.ngrok.io/get_recording',
                    'maxLength' => '30'})
      puts @r.to_xml()

      render xml: @r.to_s, content_type: 'application/xml'
    else
      c = Call.new(number_from: from, number_to: to)
      c.save
      render nothing: true
    end
  end

  def get_recording
    url_voicemail = params['RecordUrl']
    from = params['From']
    to = params['DialBLegTo']
    c = Call.new(url_voicemail: url_voicemail, number_from: from, number_to: to)
    c.save

    render nothing: true
  end

end
