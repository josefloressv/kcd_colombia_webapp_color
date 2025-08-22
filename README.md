# My Python Web App

This is a simple Python web application that renders a webpage with a background color specified by the environment variable `BG_COLOR`.

## Project Structure

```
my-python-web-app
├── app
│   ├── __init__.py
│   ├── main.py
│   └── templates
│       └── index.html
├── .env
├── requirements.txt
└── README.md
```

## Setup Instructions

# My Python Web App

A small Flask app that renders a webpage whose background, font color, and message are driven by environment variables.

## Project structure

```
kcd_colombia_webapp_color/
├── app/
│   ├── __init__.py
│   ├── main.py       # Flask factory: create_app()
│   └── templates/
│       └── index.html
├── run.py            # CLI entrypoint to run the app
├── dev-requirements.txt
├── app/requirements.txt
├── tests/            # pytest tests
└── README.md
```

## Quickstart (development)

1. Create and activate a virtual environment:

```bash
python3 -m venv .venv
. .venv/bin/activate
```

2. Install runtime dependencies:

```bash
pip install -r app/requirements.txt
```

3. (Optional) Install dev/test dependencies:

```bash
pip install -r dev-requirements.txt
```

4. Run the app using the provided CLI entrypoint:

```bash
python run.py
```

You can override host, port or enable debug mode via environment variables:

```bash
HOST=127.0.0.1 PORT=5000 DEBUG=1 BG_COLOR="#112233" FONT_COLOR="#ffffff" MESSAGE="Hola" python run.py
```

Open http://127.0.0.1:8080 (or the host/port you set) in your browser.

## Testing

Tests are written with `pytest` and live in the `tests/` folder. They exercise the Flask test client and check that the rendered page contains expected values.

To run tests:

```bash
. .venv/bin/activate
pip install -r app/requirements.txt
pip install -r dev-requirements.txt
pytest -q
```

## Environment variables

- `BG_COLOR` — background color (CSS value). Default: `#034a57`
- `FONT_COLOR` — font color (CSS value). Default: `#fafafa`
- `MESSAGE` — heading message. Default: `Hola Mundo Python`

## Docker

Docker Buildx is used in this repo for multi-arch builds. Example usage:

```bash
# Enable Docker Buildx (one time):
docker buildx create --use

# Build the Docker image (multi-arch):
docker buildx build --platform linux/amd64,linux/arm64 -t josefloressv/webapp-color .

# Run the Docker container:
docker run -d -p 8080:8080 --name webapp-color josefloressv/webapp-color

# Run with environment variables:
docker run -e BG_COLOR=black -e FONT_COLOR=yellow -d -p 8080:8080 --name webapp-color josefloressv/webapp-color

# Push the image to the registry:
docker push josefloressv/webapp-color
```

## Notes

- A small CLI entrypoint `run.py` was added to make running the app from the command line straightforward.
- Basic tests were added under `tests/` to cover the default rendering and environment-backed rendering.
