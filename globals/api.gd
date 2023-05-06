extends Node

# local
#var scheme = "http"
#var domain = "localhost"
#var port = "5006"
#var api_url = "%s://%s:%s" %[scheme, domain, port]

# production
var scheme = "https"
var domain = "ludum-dare-53-api.rareskelly.com/"
var api_url = "%s://%s" % [scheme, domain]

func _ready():
	print("Api loaded: ", { api_url = api_url })

func get_player():
	var endpoint = "player?username=%s" %[Configs.username]
	var response = await _send_request(endpoint, HTTPClient.METHOD_GET, "", ["Authorization: Basic %s" %[Configs.user_key]])
	print(response)
	if response.response_code == 200:
		print("Got 200 OK")
		return true
	else:
		print("Got %s" % response.response_code)
		return false

func get_api_status() -> bool:
	const endpoint = "healthcheck"
	var response = await _send_request(endpoint)
	return response.response_code == 200
		
func send_create_player(username: String) -> bool:
	const endpoint = "player"
	var response = await _send_request(endpoint, HTTPClient.METHOD_POST, JSON.stringify({"UserName": username}))
	if response.response_code != 200:
		print(response.body)
		return false
	else:
		Configs.username = username
		Configs.user_key = response.body.Key
		Configs.save()
		return true

# Example usage
#var success = await Api.send_interactions("Main", 2, [
#	{
#		"InteractionType": "PlaceStructure",
#		"Content": JSON.stringify({
#			"StructureType": "RefuelStation",
#			"X": 23.45,
#			"Y": 67.89,
#			"Uses": 5
#		})
#	},
#	{
#		"InteractionType": "UseStructure",
#		"Content": JSON.stringify({
#			"StructureType": "RefuelStation",
#			"X": 23.45,
#			"Y": 67.89,
#			"Use": -1
#		})
#	}
#])
func send_interactions(level: String, cycle: int, interactions: Array):
	const endpoint = "interactions/{level}/{cycle}"
	var response = await _send_request(
		endpoint.format({"level": level, "cycle": cycle}),
		HTTPClient.METHOD_POST,
		JSON.stringify({"Interactions": interactions}),
		["Authorization: Basic %s" %[Configs.user_key], "Content-Type: application/json"])
	
	return response.response_code == 200

# Example Usage
#var interactions = await Api.get_interactions("Main", 2)
# Example return value
#[
#    {
#        "InteractionID": 1,
#        "UserName": "xxAtrain223",
#        "InteractionType": "PlaceStructure",
#        "Content": {
#            "Structure": "RefuelStation",
#            "X": 12.34,
#            "Y": 56.78
#        }
#    },
#    {
#        "InteractionID": 3,
#        "UserName": "Test1",
#        "InteractionType": "PlaceStructure",
#        "Content": {
#            "Structure": "RefuelStation",
#            "X": 43.21,
#            "Y": 87.65
#        }
#    }
#]
func get_interactions(level: String, cycle: int, count: int) -> Array:
	const endpoint = "interactions/{level}/{cycle}?count={count}"
	var response = await _send_request(
		endpoint.format({"level": level, "cycle": cycle, "count": count}),
		HTTPClient.METHOD_GET,
		"",
		["Authorization: Basic %s" % [Configs.user_key]])
	
	if response.response_code == 200:
		var interactions = response.body.Interactions
		for interaction in interactions:
			var content = JSON.parse_string(interaction.Content)
			interaction.Content = content
		return interactions
	else:
		return []

func _send_request(endpoint, method = HTTPClient.METHOD_GET, body = "", custom_header = ["Content-Type: application/json"]):
	print({ endpoint = endpoint, method = method, body = body, })
	if Configs.offline_mode:
		return _mock_send_request(endpoint, method, body, custom_header)
	
	var http_request = HTTPRequest.new()
	http_request.timeout = 10
	self.add_child(http_request)
	http_request.request(api_url.path_join(endpoint), custom_header, method, body)

	# response type = [result, response_code, headers, body]
	var response = await http_request.request_completed
	print("send_request response: ", response)
	if response[0] == 0:
		var responseBodyString = response[3].get_string_from_utf8()
		var responseBody = null
		if responseBodyString != null && responseBodyString.is_empty() == false:
			responseBody = JSON.parse_string(responseBodyString)
			
		return {
			"response_code": response[1],
			"body": responseBody
		}
	else:
		return {
			"response_code": null,
			"body": null
		}

func _mock_send_request(endpoint: String, method, body, custom_header):
	print("    (mocked)")
	var endpoint_split := endpoint.split("?")
	var endpoint_path := endpoint_split[0]
	var path_split := endpoint_path.split("/")
	var endpoint_name := path_split[0]
	var path_params := path_split.slice(1)
	var params := {}
	var ok := func (response = null):
		return {
			response_code = 200,
			body = response,
		}
	
	if endpoint_split.size() > 1:
		for p in endpoint_split[1].split("&"):
			var kv = p.split("=")
			params[kv[0]] = kv[1]
	
	match [method, endpoint_name.to_lower(), path_params]:
		[HTTPClient.METHOD_GET, "healthcheck", _]:
			return ok.call()
		[HTTPClient.METHOD_GET, "player", _]:
			return ok.call({ UserName = params.username })
		[HTTPClient.METHOD_POST, "player", _]:
			return ok.call({ Key = "_" })
		[HTTPClient.METHOD_GET, "interactions", _]:
			return ok.call({ Interactions = [] })
		[HTTPClient.METHOD_POST, "interactions", _]:
			return ok.call()
