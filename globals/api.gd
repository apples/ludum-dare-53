extends Node

# local
#var scheme = "http"
#var domain = "localhost"
#var port = "5006"
#var api_url = "%s://%s:%s" %[scheme, domain, port]

# production
var scheme = "https"
var domain = "ludum-dare-53-api.rareskelly.com/"
var api_url = "%s://%s" %[scheme, domain]

func get_player():
	var endpoint = "player?username=%s" %[Configs.username]
	var response = await send_request(endpoint, HTTPClient.METHOD_GET, "", ["Authorization: Basic %s" %[Configs.user_key]])
	if response.response_code == 200:
		return {
		}
	else:
		return null

func get_api_status():
	const endpoint = "healthcheck"
	var response = await send_request(endpoint)
	if response.response_code == 200:
		return true
	else:
		return false
		
func send_create_player(username):
	const endpoint = "player"
	var response = await send_request(endpoint, HTTPClient.METHOD_POST, {"username": username})
	if response.response_code != 200:
		print(response.body)
		return false
	else:
		Configs.username = username
		Configs.user_key = response.body.Key
		Configs.save()
		return true

func get_healthcheck():
	const endpoint = "healthcheck"
	var response = await send_request(endpoint)
	print(response.body.Status)

func send_request(endpoint, method = HTTPClient.METHOD_GET, body = "", custom_header = ["Content-Type: application/json"]):
	var http_request = HTTPRequest.new()
	http_request.timeout = 10
	self.add_child(http_request)
	http_request.request(api_url.path_join(endpoint), custom_header, method, JSON.stringify(body))
#	response type = [result, response_code, headers, body]
	var response = await http_request.request_completed
	if response[0] == 0:
		var jsonResponse = {
			"response_code": response[1],
			"body": JSON.parse_string(response[3].get_string_from_utf8())
		}
		return jsonResponse
	else:
		var jsonResponse = {
			"response_code": null,
			"body": null
		}
		return jsonResponse

func _on_request_completed(result, response_code, headers, body):
	print(response_code)
#    var json = JSON.parse_string(body.get_string_from_utf8())
#    print(json["name"])


# Called when the node enters the scene tree for the first time.
func _ready():
	print(api_url)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
