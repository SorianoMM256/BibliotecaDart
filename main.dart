abstract class ItemBiblioteca {
  String titulo;
  int anoPublicacao;
  int quantidadeCopias;
  double custoBase;
  double multaPorDiaAtraso;


  ItemBiblioteca({
    required this.titulo,
    required this.anoPublicacao,
    required this.quantidadeCopias,
    required this.custoBase,
    required this.multaPorDiaAtraso,
  });

  void exibirDetalhes();

  bool get disponivel {
  return quantidadeCopias > 0;
  }

  Emprestimo? emprestar({
    required String nomeUsuario,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
  }) {
  if (!disponivel) {
    print('O item "$titulo" está indisponível.');
    return null;
  }

  quantidadeCopias--;

  Emprestimo emprestimo = Emprestimo(
    item: this,
    nomeUsuario: nomeUsuario,
    dataEmprestimo: dataEmprestimo,
    dataPrevistaDevolucao: dataPrevistaDevolucao,
  );

  print('Empréstimo realizado: $titulo para $nomeUsuario');

  return emprestimo;
  }
  double devolver({
    required Emprestimo emprestimo,
    required DateTime dataDevolucao,
  }) {
  if (emprestimo.foiDevolvido) {
    throw Exception('Este item já foi devolvido.');
  }

  quantidadeCopias++;
  emprestimo.finalizarDevolucao(dataDevolucao);

  return emprestimo.valorTotal;
  }
}

class Livro extends ItemBiblioteca {
  String autor;
  int isbn;

  Livro({
    required String titulo,
    required int anoPublicacao,
    required int quantidadeCopias,
    required this.autor,
    required this.isbn,
  }) : super(
          titulo: titulo,
          anoPublicacao: anoPublicacao,
          quantidadeCopias: quantidadeCopias,
          custoBase: 15.00,
          multaPorDiaAtraso: 2.50,
        );

  @override
  void exibirDetalhes() {
    print('Livro: $titulo');
    print('Autor: $autor');
    print('ISBN: $isbn');
    print('Ano: $anoPublicacao');
    print('Cópias disponíveis: $quantidadeCopias');
    print('Custo base: R\$ $custoBase');
    print('Multa por dia de atraso: R\$ $multaPorDiaAtraso');
  }
}

class Revista extends ItemBiblioteca {
  int numeroEdicao;
  String mesPublicacao;

  Revista({
    required String titulo,
    required int anoPublicacao,
    required int quantidadeCopias,
    required this.numeroEdicao,
    required this.mesPublicacao,
  }) : super(
          titulo: titulo,
          anoPublicacao: anoPublicacao,
          quantidadeCopias: quantidadeCopias,
          custoBase: 5.00,
          multaPorDiaAtraso: 1.00,
        );

  @override
  void exibirDetalhes() {
    print('Revista: $titulo');
    print('Edição: $numeroEdicao');
    print('Mês de publicação: $mesPublicacao');
    print('Ano: $anoPublicacao');
    print('Cópias disponíveis: $quantidadeCopias');
    print('Custo base: R\$ $custoBase');
    print('Multa por dia de atraso: R\$ $multaPorDiaAtraso');
  }
}

void listarEstoque(List<ItemBiblioteca> acervo) {
  print('\nESTOQUE DA BIBLIOTECA\n');

  for (ItemBiblioteca item in acervo) {
    item.exibirDetalhes();
    print('------------------------');
  }
}

class Emprestimo {
  ItemBiblioteca item;
  String nomeUsuario;
  DateTime dataEmprestimo;
  DateTime dataPrevistaDevolucao;
  DateTime? dataDevolucao;

  Emprestimo({
    required this.item,
    required this.nomeUsuario,
    required this.dataEmprestimo,
    required this.dataPrevistaDevolucao,
  });

  bool get foiDevolvido {
    return dataDevolucao != null;
  }

  int get diasAtraso {
  if (dataDevolucao == null) {
    return 0;
  }

  int diferenca = dataDevolucao!.difference(dataPrevistaDevolucao).inDays;

  if (diferenca > 0) {
    return diferenca;
  }

  return 0;
  }

  double get valorTotal {
    return item.custoBase + (diasAtraso * item.multaPorDiaAtraso);
  }

  void finalizarDevolucao(DateTime data) {
    dataDevolucao = data;
  }
}

void main() {
  List<ItemBiblioteca> acervo = [
    Livro(
      titulo: 'Dom Casmurro',
      anoPublicacao: 1899,
      quantidadeCopias: 3,
      autor: 'Machado de Assis',
      isbn: 1001,
    ),
    Livro(
      titulo: 'O Cortiço',
      anoPublicacao: 1890,
      quantidadeCopias: 2,
      autor: 'Aluísio Azevedo',
      isbn: 1002,
    ),
    Livro(
      titulo: 'Capitães da Areia',
      anoPublicacao: 1937,
      quantidadeCopias: 2,
      autor: 'Jorge Amado',
      isbn: 1003,
    ),
    Revista(
      titulo: 'Ciência Hoje',
      anoPublicacao: 2024,
      quantidadeCopias: 5,
      numeroEdicao: 120,
      mesPublicacao: 'Março',
    ),
    Revista(
      titulo: 'Superinteressante',
      anoPublicacao: 2023,
      quantidadeCopias: 4,
      numeroEdicao: 450,
      mesPublicacao: 'Agosto',
    ),
    Revista(
      titulo: 'Mundo Estranho',
      anoPublicacao: 2022,
      quantidadeCopias: 3,
      numeroEdicao: 88,
      mesPublicacao: 'Novembro',
    ),
  ];

  List<Emprestimo> emprestimos = [];

  listarEstoque(acervo);

  print('\nEMPRÉSTIMOS\n');

  Emprestimo? e1 = acervo[0].emprestar(
    nomeUsuario: 'Ana',
    dataEmprestimo: DateTime(2026, 5, 1),
    dataPrevistaDevolucao: DateTime(2026, 5, 8),
  );

  Emprestimo? e2 = acervo[1].emprestar(
    nomeUsuario: 'Bruno',
    dataEmprestimo: DateTime(2026, 5, 2),
    dataPrevistaDevolucao: DateTime(2026, 5, 9),
  );

  Emprestimo? e3 = acervo[2].emprestar(
    nomeUsuario: 'Carla',
    dataEmprestimo: DateTime(2026, 5, 3),
    dataPrevistaDevolucao: DateTime(2026, 5, 10),
  );

  Emprestimo? e4 = acervo[3].emprestar(
    nomeUsuario: 'Diego',
    dataEmprestimo: DateTime(2026, 5, 4),
    dataPrevistaDevolucao: DateTime(2026, 5, 11),
  );

  Emprestimo? e5 = acervo[4].emprestar(
    nomeUsuario: 'Eduarda',
    dataEmprestimo: DateTime(2026, 5, 5),
    dataPrevistaDevolucao: DateTime(2026, 5, 12),
  );

  Emprestimo? e6 = acervo[5].emprestar(
    nomeUsuario: 'Felipe',
    dataEmprestimo: DateTime(2026, 5, 6),
    dataPrevistaDevolucao: DateTime(2026, 5, 13),
  );

  if (e1 != null) emprestimos.add(e1);
  if (e2 != null) emprestimos.add(e2);
  if (e3 != null) emprestimos.add(e3);
  if (e4 != null) emprestimos.add(e4);
  if (e5 != null) emprestimos.add(e5);
  if (e6 != null) emprestimos.add(e6);

  listarEstoque(acervo);

  print('\nDEVOLUÇÕES\n');

  List<DateTime> datasDevolucao = [
    DateTime(2026, 5, 8),  // sem atraso
    DateTime(2026, 5, 11), // 2 dias de atraso
    DateTime(2026, 5, 15), // 5 dias de atraso
    DateTime(2026, 5, 11), // sem atraso
    DateTime(2026, 5, 14), // 2 dias de atraso
    DateTime(2026, 5, 20), // 7 dias de atraso
  ];

  for (int i = 0; i < emprestimos.length; i++) {
    Emprestimo emprestimo = emprestimos[i];

    double valorPago = emprestimo.item.devolver(
      emprestimo: emprestimo,
      dataDevolucao: datasDevolucao[i],
    );

    print('Item devolvido: ${emprestimo.item.titulo}');
    print('Usuário: ${emprestimo.nomeUsuario}');
    print('Dias de atraso: ${emprestimo.diasAtraso}');
    print('Valor pago: R\$ $valorPago');
    print('------------------------');
  }

  listarEstoque(acervo);
}