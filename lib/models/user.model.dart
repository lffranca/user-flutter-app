class User {
  int id;
  String nome;
  String sobrenome;
  String username;
  String datacriacao;

  User({this.id, this.nome, this.sobrenome, this.username, this.datacriacao});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    sobrenome = json['sobrenome'];
    username = json['username'];
    datacriacao = json['datacriacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['sobrenome'] = this.sobrenome;
    data['username'] = this.username;
    data['datacriacao'] = this.datacriacao;
    return data;
  }
}
