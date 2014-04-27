class VoipfoneClient::Client
  # Send an sms from your account.
  # @param to [String] the phone number to send the SMS to, as a string. Spaces will be stripped; + symbol allowed.
  # @param from [String] the phone number to send the SMS from, as a string. Spaces will be stripped; + symbol allowed.
  # @param message [String] the message to send. The first 160 characters only will be sent.
  def send_sms(to:to, from:from, message:message)
    if to.nil? || from.nil? || message.nil?
      raise ArgumentError, "You need to include 'to' and 'from' numbers and a message to send an SMS"
    end
    to = to.gsub(" ","")
    from = from.gsub(" ","")
    parameters = {
      "sms-send-to" => to,
      "sms-send-from" => from,
      "sms-message" => message
    }
    request = @browser.post("#{VoipfoneClient::API_POST_URL}?smsSend", parameters)
    response = parse_response(request)
    if response == "ok"
      return true
    else
      raise VoipfoneAPIError, response
    end
  end
end