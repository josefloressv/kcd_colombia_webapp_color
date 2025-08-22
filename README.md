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

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd my-python-web-app
   ```

2. **Create a virtual environment** (optional but recommended):
   ```
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies**:
   ```
   pip install -r app/requirements.txt
   ```

4. **Set the environment variable**:
   Create a `.env` file in the root directory and add the following line:
   ```
   BG_COLOR=your_color_here
   FONT_COLOR=your_font_color_here
   ```
   Replace `your_color_here` and `your_font_color_here` with a valid CSS color value (e.g., `#ff5733`, `blue`, `rgba(255, 255, 255, 0.5)`).

5. **Run the application**:
   ```bash
   python app/main.py
   ```

6. **Access the application**:
   Open your web browser and go to `http://127.0.0.1:8080`.

## Usage

The application will render a simple webpage with the background color set according to the `BG_COLOR` environment variable  and the font color set according to the `FONT_COLOR` environment variable. If the variables are not set, the default background and font colors will be used.

## Docker
Docker Buildx is a CLI plugin that extends the Docker command with the full support of the features provided by Moby BuildKit builder toolkit.

```bash
# Enable Docker Buildx:
docker buildx create --use

# Build the Docker image using Buildx: Note
docker buildx build --platform linux/amd64,linux/arm64 -t josefloressv/webapp-color .

# Run the Docker container:
docker run -d -p 8080:8080 --name webapp-color josefloressv/webapp-color

# Run with variables
docker run -e BG_COLOR=black -e FONT_COLOR=yellow -d -p 8080:8080 --name webapp-color josefloressv/webapp-color

# Push the new version
docker push josefloressv/webapp-color
```