from flask import jsonify
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
import requests

BASE_URL = 'http://127.0.0.1:5000'

@pytest.fixture
def api():
    return requests.Session()

@pytest.fixture(scope="module")
def driver():
    driver = webdriver.Chrome()  # Make sure you have the ChromeDriver installed
    yield driver
    driver.quit()

def test_tem_banana(driver):
    driver.get('http://127.0.0.1:5000/produtos')
    response_body = driver.find_element(By.TAG_NAME, "body").text
    assert 'banana' in response_body

def test_get_produtos(api):
    response = api.get(f'{BASE_URL}/produtos')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_produtos_by_page(api):
    response = api.get(f'{BASE_URL}/produtos/page?page=1&per_page=2')
    assert response.status_code == 200
    json_data = response.json()
    assert 'produtos' in json_data
    assert 'paging' in json_data

def test_get_produto_by_id(api):
    response = api.get(f'{BASE_URL}/produtos/1')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_produto_by_descricao(api):
    response = api.get(f'{BASE_URL}/produtos/teste')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_produto_by_custo(api):
    response = api.get(f'{BASE_URL}/produtos/12.34')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_produto_by_preco_venda(api):
    response = api.get(f'{BASE_URL}/produtos/venda/45.67')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_ofertas_by_product_id(api):
    response = api.get(f'{BASE_URL}/oferta/list/1')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_lojas(api):
    response = api.get(f'{BASE_URL}/lojas')
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_get_oferta_by_id(api):
    response = api.get(f'{BASE_URL}/oferta/1')
    assert response.status_code == 200
    assert isinstance(response.json(), list)