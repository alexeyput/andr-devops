from flask import Flask, render_template
import socket
import platform

page_title = "Homework #2. Python3 + Flask application"

app = Flask(__name__)

@app.route('/')
@app.route('/index')
def index():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    operation_system = platform.system()
    os_release = platform.release()

    return render_template( 'index.html',
                            host = hostname,
                            ip_address = ip_address,
                            operation_system = operation_system,
                            os_release = os_release,
                            page_title = page_title)

if __name__ == '__main__':
    app.run(debug=True)