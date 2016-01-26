include Plivo

class VoicesController < ApplicationController

  def receive
    @r = Response.new()
    @r.addSpeak("Hello, you just received your first call")
    puts @r.to_xml()

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: "application/xml"
  end

  # http://lvh.me:3000/forward
  def forward
    from_number = params[:From]
    @r = Response.new()
    # Call all the app of each user
    #User.all do |user|

    #end
    forwarding_mobile_app = 'sip:MobileApp160126152504@phone.plivo.com'
    #forwarding_tablet_app = 'sip:@phone.plivo.com'
    #forwarding_desktop_app = 'sip:@phone.plivo.com'

    # The phone number to be used as the caller id.
    # It can be set to the from_number or any custom number.
    d = @r.addDial({'callerId' => from_number})
    d.addUser(forwarding_mobile_app)

    puts @r.to_xml()

    # Render XML element to talk wit Plivo API
    render xml: @r.to_s, content_type: "application/xml"
  end


end
