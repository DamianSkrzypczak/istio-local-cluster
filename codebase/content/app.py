import time

from flask import Flask, Response, make_response, render_template
import requests

app = Flask(__name__)


@app.route("/api/v1/articles")
def home():
    articles = [
        {
            "id": 1,
            "title": "Starting My Journey with Istio",
            "content": "Embarking on a new adventure with Istio, I'm discovering how this powerful service mesh can manage microservices efficiently. Join me as I explore the basics and share my learning experiences.",
            "date": "2024-01-20",
        },
        {
            "id": 2,
            "title": "Navigating Traffic Management",
            "content": "In this chapter of my Istio journey, I dive into the complexities of traffic management. Understanding how to control and route traffic effectively is crucial in any microservices architecture.",
            "date": "2024-01-22",
        },
        {
            "id": 3,
            "title": "Ensuring Security in Microservices",
            "content": "Security is paramount in my Istio exploration. This part of the journey looks at how Istio strengthens communication between services, ensuring a secure microservices environment.",
            "date": "2024-01-25",
        },
    ]
    return articles

if __name__ == "__main__":
    app.run(debug=True, port=5001)
