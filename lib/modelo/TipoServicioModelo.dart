class TipoServicio {
  TipoServicio({
    required this.idTipo,
    required this.nombre,
    required this.descripcion,
  });

  late final int idTipo;
  late final String nombre;
  late final String descripcion;
  TipoServicio.crear():idTipo=0, nombre="", descripcion="";
  factory TipoServicio.fromJson(Map<String, dynamic> json){
    return TipoServicio(
      idTipo: json["idTipo"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
    );
  }

  Map<String, dynamic> toJson() => {
    "idTipo": idTipo,
    "nombre": nombre,
    "descripcion": descripcion,
  };

}