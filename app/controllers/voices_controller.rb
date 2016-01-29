include Plivo

class VoicesController < ApplicationController
  # Very important, avoid CSRF protection
  # https://www.twilio.com/blog/2014/02/twilio-on-rails-integrating-twilio-with-your-rails-4-app.html
  skip_before_action :verify_authenticity_token

  # GET http://lvh.me:3000/receive
  def receive
    @xml_response = Response.new()
    @xml_response.addSpeak('Hello, we are connected')
    render_plivo_xml(@xml_response)
  end

  # GET http://lvh.me:3000/forward
  def forward
    from_number = params[:From]
    @xml_response = Response.new()
    dial = @xml_response.addDial({'callerId' => from_number,
                    'action' => 'https://aircall.herokuapp.com/save_call',
                    'method' => 'POST',
                    'redirect' => 'true'})

    # Call all the apps of each user
    UserNumber.all.each do |sip_app|
      forwarding_app = sip_app.sip_endpoint
      dial.addUser('sip:' + forwarding_app)
    end

    render_plivo_xml(@xml_response)
  end

  # POST http://lvh.me:3000/save_call
  def save_call
    to = params['DialBLegTo']
    from = params['From']
    if !to
      @xml_response = Response.new()
      @xml_response.addSpeak('Please leave a message after the beep')
      @xml_response.addRecord({'action' => 'https://aircall.herokuapp.com/get_recording',
                               'maxLength' => '30'})
      render_plivo_xml(@xml_response)
    else
      Call.create(number_from: from, number_to: to)
      render nothing: true
    end
  end

  # POST http://lvh.me:3000/get_recording
  def get_recording
    url_voicemail = params['RecordUrl']
    from = params['From']
    to = params['DialBLegTo']
    Call.create(url_voicemail: url_voicemail, number_from: from, number_to: to)
    render nothing: true
  end

  # GET http://lvh.me:3000/hangup
  def hangup
    render nothing: true
  end

  # GET
  def index
    @calls = Call.all
  end

  private

  # Render XML element to talk wit Plivo API
  def render_plivo_xml(xml)
    puts xml.to_xml()
    render xml: xml.to_s, content_type: 'application/xml'
  end

end
