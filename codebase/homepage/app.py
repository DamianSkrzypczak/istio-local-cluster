import time

from flask import Flask, Response, make_response, redirect, render_template
import requests

app = Flask(__name__)


@app.route("/")
def home():
    try:
        articles = requests.get(
            "http://content-service.default.svc.cluster.local/api/v1/articles"
        ).json()
    except requests.ConnectionError:
        articles = []

    try:
        banner()
        background_url = "/static/banner"
    except requests.ConnectionError:
        background_url = None

    response: Response = make_response(
        render_template("index.html", articles=articles, background_url=background_url)
    )
    return response


@app.route("/static/banner")
def banner():
    resp = requests.get("http://images-service.default.svc.cluster.local/" + f"?{time.time()}")
    return Response(resp.content, mimetype=resp.headers['Content-Type'])

if __name__ == "__main__":
    app.run(debug=True)
