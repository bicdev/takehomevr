from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
from flask_cors import CORS

app = Flask(__name__)
app.config['MYSQL_HOST'] = 'localhost' #'172.17.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'bicdev@mysql@112024'
app.config['MYSQL_DB'] = 'takehome'
app.config['JSON_AS_ASCII'] = False
CORS(app)

mysql = MySQL(app)

@app.route('/produtos', methods=['GET'])
def get_produtos():
    cur = mysql.connection.cursor()
    cur.execute('''SELECT * FROM Produtos''')
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/produtos/page', methods=['GET'])
def get_produtos_by_page():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    offset = (page - 1) * per_page


    cur = mysql.connection.cursor()
    cur.execute('''SELECT * FROM Produtos LIMIT %s OFFSET %s''', (per_page, offset))
    data = cur.fetchall()
    cur.execute('''select count(id) from Produtos''');
    total_raw = cur.fetchall()
    total_readable = jsonify(total_raw).get_json()[0][0]
    cur.close()

    return jsonify({
        'produtos': [jsonify(data).get_json()],
        'paging': {
            'page':page,
            'per_page': per_page,
            'offset': offset,
            'total': total_readable,
            'total_pages': total_readable // per_page
        }
        })

def query(sql, parameters, commit=False):
    with mysql.connection.cursor() as cur:
        rows_affected = cur.execute(sql, (parameters, ))
        data = cur.fetchall()
        if commit:
            mysql.connection.commit()
    return data, rows_affected        
   
@app.route('/produtos/<int:id>', methods=['GET'])
def get_produto_by_id(id:int):
    parameters = f'{id}'
    sql = "SELECT * FROM Produtos WHERE id = %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

@app.route('/produtos/<string:descricao>', methods=['GET'])
def get_produto_by_descricao(descricao:str):
    parameters = f'%{descricao}%'
    sql = "SELECT * FROM Produtos WHERE descricao LIKE %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

@app.route('/produtos/<float:custo>', methods=['GET'])
def get_produto_by_custo(custo:float):
    parameters = f'{custo}'
    sql = "SELECT * FROM Produtos WHERE custo = %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

@app.route('/produtos/venda/<float:venda>', methods=['GET'])
def get_produto_by_preco_venda(venda:float):
    parameters = f'{venda}'
    sql = "select Produtos.id, descricao, custo from Produtos left join ProdutoLoja on Produtos.id = ProdutoLoja.idProduto where ProdutoLoja.preco_venda = %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

# ROUTELESS
def delete_dependencies(id_produto:int) -> int:
    parameters = f'{id_produto}'
    sql = "DELETE FROM ProdutoLoja where idProduto = %s"
    _, rows =  query(sql, parameters)
    return rows

@app.route('/produtos/<int:id>', methods=['DELETE'])
def delete_produto_by_id(id:int):
    dependency_rows = delete_dependencies(id)

    parameters = f'{id}'
    sql = "DELETE FROM Produtos WHERE id = %s"
    _, rows = query(sql, parameters, commit=True)
    return jsonify(f"dependency deleted: {dependency_rows}, rows deleted: {rows}")

@app.route('/produtos', methods=['POST'])
def create_produto():
    descricao = request.json['descricao']
    custo = request.json['custo']
    
    with mysql.connection.cursor() as cur:
        rows = cur.execute('''INSERT INTO Produtos (descricao, custo) VALUES (%s, %s)''', (descricao, custo))
        mysql.connection.commit()
        cur.execute("select id from Produtos where descricao = %s and custo = %s order by id desc limit 1", (descricao, custo))
        new_id = jsonify(cur.fetchall()).get_json()[0][0]

    return jsonify(f"{new_id}"), 201

@app.route('/lojas', methods=['POST'])
def create_loja():
    descricao = request.json['descricao']
    
    with mysql.connection.cursor() as cur:
        rows = cur.execute('''INSERT INTO Lojas (descricao) VALUES (%s)''', (descricao, ))
        mysql.connection.commit()
        cur.execute("SELECT LAST_INSERT_ID()")
        new_id = cur.fetchone()[0]

    return jsonify(f"{new_id}"), 201

@app.route('/produtos/<int:id>', methods=['PUT'])
def update_produto(id:int):
    descricao = request.json['descricao']
    custo = request.json['custo']
    
    with mysql.connection.cursor() as cur:
        rows = cur.execute('''UPDATE Produtos SET descricao = %s, custo = %s WHERE id = %s''', (descricao, custo, id))
        mysql.connection.commit()
    return jsonify(f"{rows} rows updated")

@app.route('/oferta/list/<int:id>', methods=['GET'])
def get_ofertas_by_product_id(id:int):
    parameters = id
    sql = "select ProdutoLoja.idProduto, ProdutoLoja.id, Lojas.descricao, Lojas.id, ProdutoLoja.preco_venda from ProdutoLoja left join Lojas on ProdutoLoja.idLoja = Lojas.id where idProduto = %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

@app.route('/oferta/<int:id_oferta>', methods=['PUT'])
def update_oferta(id_oferta:int):
    preco_venda = request.json['preco_venda']
    
    with mysql.connection.cursor() as cur:
        rows = cur.execute('''UPDATE ProdutoLoja SET preco_venda = %s WHERE id = %s''', (preco_venda, id_oferta))
        mysql.connection.commit()
    return jsonify(f"{rows} rows updated")

@app.route('/oferta', methods=['POST'])
def create_oferta():
    id_produto = request.json['id_produto']
    id_loja = request.json['id_loja']
    preco_venda = request.json['preco_venda']
    
    ofertas = get_ofertas_by_product_id(id_produto).get_json()
    for oferta in ofertas:
        if str(oferta[3]) == id_loja:
            return jsonify("Não é permitido mais que um preço de venda para a mesma loja"), 422
        
    with mysql.connection.cursor() as cur:
        rows = cur.execute('''INSERT INTO ProdutoLoja(idProduto, idLoja, preco_venda) VALUES (%s, %s, %s)''', (id_produto, id_loja, preco_venda))
        mysql.connection.commit()
    return jsonify(f"{rows} rows created"), 201

@app.route('/lojas', methods=['GET'])
def get_lojas():
    with mysql.connection.cursor() as cur:
        cur.execute('''SELECT * FROM Lojas''')
        data = cur.fetchall()
    return jsonify(data)

@app.route('/oferta/<int:id>', methods=['GET'])
def get_oferta_by_id(id:int):
    parameters = f'{id}'
    sql = "SELECT * FROM ProdutoLoja WHERE id = %s"
    data, rows =  query(sql, parameters)
    return jsonify(data)

@app.route('/oferta/<int:id>', methods=['DELETE'])
def delete_oferta_by_id(id:int):
    parameters = f'{id}'
    sql = "DELETE FROM ProdutoLoja WHERE id = %s"
    _, rows = query(sql, parameters, commit=True)
    return jsonify(f"rows deleted: {rows}")

# EXTRACT RUNNER LATER\
if __name__ == '__main__':
    app.run(debug=True, port=5000)
    