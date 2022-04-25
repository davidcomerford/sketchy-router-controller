import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    body = '''
<!DOCTYPE html>
<html>

<body>
    <title>Sketchy Router Controller</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: #eceffc;
        }

        h1 {
            margin: 0 0 15px 0;
        }

        .btn {
            padding: 8px 10px;
            border-radius: 0;
            overflow: hidden;
            width: 30%;
            margin: 10px 0 9px 0;
            background-color: #2f3032;
            border: 1px solid hsl(214, 79%, 65%);
            color: hsl(214, 79%, 65%);
            transition-duration: 0.4s;
        }

        .btn:hover {
            background-color: hsl(214, 79%, 65%);
            color: white;
        }

        .status_field {
            --input-default-border-color: white;
            --input-border-bottom-color: transparent;
        }

        .login-form {
            align-items: center;
            padding: 50px 40px;
            color: white;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 10px;
            box-shadow:
                0 0.4px 0.4px rgba(128, 128, 128, 0.109),
                0 1px 1px rgba(128, 128, 128, 0.155),
                0 2.1px 2.1px rgba(128, 128, 128, 0.195),
                0 4.4px 4.4px rgba(128, 128, 128, 0.241),
                0 12px 12px rgba(128, 128, 128, 0.35);
        }
    </style>

    <div class="login-form" action="javascript:void(0);">
        <h1>Sketchy Router Controller</h1>

        <button class="btn" onclick="getInstanceState()">Get State</button>
        <button class="btn btn-primary btn-ghost" onclick="changeInstanceState(\'start\')">Start</button>
        <button class="btn btn-primary btn-ghost" onclick="changeInstanceState(\'stop\')">Stop</button>

        <div class="status_field">
            Instance state: <span id="status"> unknown </span>
        </div>
    </div>

    <script>
        var api_base_url = "https://bqvi3yd737.execute-api.eu-west-1.amazonaws.com/prod/"

        function updateStatus(message) {
            document.getElementById("status").innerHTML = message;
        }

        function getInstanceState() {
            url = new URL(api_base_url + "status")
            url.searchParams.append("anti-spider", true)
            fetch(url)
                .then(response => response.text())
                .then(data => {
                    const parser = new DOMParser();
                    const xml = parser.parseFromString(data, "application/xml");
                    instance_state = xml.getElementsByTagName("instanceState")[0].getElementsByTagName("name")[0]
                        .childNodes[0].nodeValue
                    updateStatus(instance_state)
                })
                .catch(console.error)
        }

        function changeInstanceState(new_state) {
            fetch(url + new_state)
                .then(response => response.text())
                .then(data => {
                    const parser = new DOMParser();
                    const xml = parser.parseFromString(data, "application/xml");
                    instance_state = xml.getElementsByTagName("currentState")[0].getElementsByTagName("name")[0]
                        .childNodes[0].nodeValue
                    updateStatus(instance_state)
                })
                .catch(console.error)
        }
    </script>
</body>

</html>
    '''
    return {
        "statusCode": 200,
        "isBase64Encoded": False,
        "headers": {
            "Access-Control-Allow-Origin": "'*'",
            "Access-Control-Allow-Methods": "GET",
            "Content-Type": "text/html; charset=utf-8"
        },
        "body": body
    }


if __name__ == "__main__":
    event = []
    context = []
    print(lambda_handler(event, context))
