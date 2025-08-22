#!/usr/bin/env python3
"""Simple CLI entrypoint to run the Flask app.

Usage examples:
  python run.py
  HOST=127.0.0.1 PORT=5000 DEBUG=1 python run.py
"""
import os
from app.main import create_app


def main():
    host = os.getenv('HOST', '0.0.0.0')
    port = int(os.getenv('PORT', '8080'))
    debug = os.getenv('DEBUG', 'False').lower() in ('1', 'true', 'yes')

    app = create_app()
    app.run(host=host, port=port, debug=debug)


if __name__ == '__main__':
    main()
