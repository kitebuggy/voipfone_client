class VoipfoneClient::Client
  # Get a list of phones which can be diverted to. Returns a nested array of name and phone number.
  # == Returns:
  #   Nested array of names and phone numbers
  def diverts_list
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?divertsCommon")
    parse_response(request)["divertsCommon"]
  end

  # Add a new number to the list of numbers which can be diverted to. Requires a name
  # and a phone number, which will have spaces stripped from it. May be in international
  # format.
  # == Parameters: 
  #   Name::
  #     String, the name which appears in dropdowns in the web interface
  #
  #   Number::
  #     The number which will be called. Spaces will be stripped. + symbol accepted
  # ==  
  #   true on success, or a failure message (in which case a `VoipfoneAPIError`
  #     will be raised)
  def add_to_diverts_list(name: nil, number: nil)
    if name.nil? || number.nil?
      raise ArgumentError, "You need to include a name and number to add to the diverts list"
    end
    number = number.gsub(" ","")
    parameters = {
      "div-list-name" => name,
      "div-list-num" => number
    }
    request = @browser.post("#{VoipfoneClient::API_POST_URL}?setDivertsList", parameters)
    response = parse_response(request)
    if response == [name, number]
      return true
    else
      raise VoipfoneAPIError, "Although Voipfone returned an OK, the data they stored didn't match what you asked for: #{response}"
    end
  end


  # Divert calls for different circumstances. There are 4 supported situations which can be
  # diverted for, namely:
  #  - all calls (i.e. no calls will reach the pbx / phones - immediate divert)
  #  - when there is a failure in the phone system
  #  - when the phone(s) are busy
  #  - when there's no answer

  # At least one option is required

  # == Parameters:
  #   All::
  #     String, the number to which all calls will be diverted.
  #
  #   Fail::
  #     String, the number to which calls will be diverted in the event of a failure
  #
  #   Busy::
  #     String, the number to which calls will be diverted if the phones are busy
  #
  #   No Answer::
  #     String, the number to which calls will be diverted if there's no answer
  # 
  # == Returns:
  #   true on success, or a failure message (in which case a `VoipfoneAPIError` will be raised)
  def set_diverts(all: nil, fail: nil, busy: nil, no_answer: nil)
    all ||= ""
    fail ||= ""
    busy ||= ""
    no_answer ||= ""
    parameters = {
      "all" => all.gsub(" ",""),
      "chanunavail" => fail.gsub(" ",""),
      "busy" => busy.gsub(" ",""),
      "noanswer" => no_answer.gsub(" ","")
    }
    request = @browser.post("#{VoipfoneClient::API_POST_URL}?divertsMain", parameters)
    response = parse_response(request)
    if response == "ok"
      return true
    else
      raise VoipfoneAPIError, response.first
    end
  end

  # Diverts all calls to the number passed into this method

  # == Parameters:
  #   Number::
  #     String, the number to be diverted to.
  #
  # == Returns:
  #   true on success, or an error message (in which case a `VoipfoneAPIError` will be raised)
  def divert_all_calls(number: nil)
    set_diverts(all: number)
  end

  # Get current diverts
  # == Returns:
  #   A nested set of arrays with divert information for each type of divert currently set
  def get_diverts
    request = @browser.get("#{VoipfoneClient::API_GET_URL}?divertsMain")
    parse_response(request)["divertsMain"]
  end
end