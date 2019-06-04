class SyncModel {
  SyncModel({this.atual = 0, this.total = 0}) {
    this.atual == this.total ? this.completado = true : this.completado = false;
  }

  int atual;
  int total;
  bool completado;
}
