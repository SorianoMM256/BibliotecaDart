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
}

void main() {
  print('Sistema de Gestão Bibliotecária');
}