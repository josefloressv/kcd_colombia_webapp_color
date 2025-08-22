import os
from flask import render_template
from flask import Flask

def create_app():
    app = Flask(__name__)

    @app.route('/')
    def home():
        bg_color = os.getenv('BG_COLOR', '#034a57')  # Default to #034a57 if not set
        font_color = os.getenv('FONT_COLOR', '#fafafa')  # Default to #fafafa if not set
        message = os.getenv('MESSAGE', 'Hola Mundo Python')  # Default to 'Hola Mundo Python' if not set
        return render_template('index.html', bg_color=bg_color, font_color=font_color, message=message)

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(host='0.0.0.0', port=8080, debug=True)