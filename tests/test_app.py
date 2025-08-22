import os
from app.main import create_app


def test_home_default_env(monkeypatch):
    # Ensure defaults are used when env vars are not set
    monkeypatch.delenv('BG_COLOR', raising=False)
    monkeypatch.delenv('FONT_COLOR', raising=False)
    monkeypatch.delenv('MESSAGE', raising=False)

    app = create_app()
    client = app.test_client()

    resp = client.get('/')
    assert resp.status_code == 200
    text = resp.get_data(as_text=True)

    # Defaults from the app
    assert '#034a57' in text
    assert '#fafafa' in text
    assert 'Hola Mundo Python' in text


def test_home_with_env(monkeypatch):
    monkeypatch.setenv('BG_COLOR', '#112233')
    monkeypatch.setenv('FONT_COLOR', '#abcdef')
    monkeypatch.setenv('MESSAGE', 'Prueba')

    app = create_app()
    client = app.test_client()

    resp = client.get('/')
    assert resp.status_code == 200
    text = resp.get_data(as_text=True)

    assert '#112233' in text
    assert '#abcdef' in text
    assert 'Prueba' in text
