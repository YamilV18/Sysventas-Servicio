
import 'package:sysventas/modelo/TipoServicioModelo.dart';

class ServicioResp {
  ServicioResp({
    required this.idServicio,
    required this.nombreServicio,
    required this.descripcion,
    required this.precioBase,
    required this.estado,
    required this.tipo,
  });

  final int idServicio;
  final String? nombreServicio;
  final String? descripcion;
  final double precioBase;
  final String? estado;
  final TipoServicio? tipo;

  factory ServicioResp.fromJson(Map<String, dynamic> json){
    return ServicioResp(
      idServicio: json["idServicio"],
      nombreServicio: json["nombreServicio"],
      descripcion: json["descripcion"],
      precioBase: json["precioBase"],
      estado: json["estado"],
      tipo: json["tipo"] == null ? TipoServicio.crear() : TipoServicio.fromJson(json["tipo"]),
    );
  }

  Map<String, dynamic> toJson() => {
    'idServicio': idServicio,
    'nombreServicio': nombreServicio,
    'descripcion': descripcion,
    'precioBase': precioBase,
    'estado': estado,
    'tipo': tipo?.toJson(),
  };
}
class ServicioCreateDto {
  ServicioCreateDto({
    required this.nombreServicio,
    required this.descripcion,
    required this.precioBase,
    required this.estado,
    required this.tipo,
  });

  late final String? nombreServicio;
  late final String? descripcion;
  late final double precioBase;
  late final String? estado;
  late final int? tipo;

  ServicioCreateDto.unlaunched();

  factory ServicioCreateDto.fromJson(Map<String, dynamic> json){
    return ServicioCreateDto(
      nombreServicio: json["nombreServicio"],
      descripcion: json["descripcion"],
      precioBase: json["precioBase"],
      estado: json["estado"],
      tipo: json["tipo"],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombreServicio': nombreServicio,
    'descripcion': descripcion,
    'precioBase': precioBase,
    'estado': estado,
    'tipo': tipo,
  };
}
class ServicioDto {
  ServicioDto({
    required this.idServicio,
    required this.nombreServicio,
    required this.descripcion,
    required this.precioBase,
    required this.estado,
    required this.tipo,
  });

  late final int? idServicio;
  late final String? nombreServicio;
  late final String? descripcion;
  late final double precioBase;
  late final String? estado;
  late final int? tipo;

  ServicioDto.unlaunched();

  factory ServicioDto.fromJson(Map<String, dynamic> json){
    return ServicioDto(
      idServicio: json["idServicio"],
      nombreServicio: json["nombreServicio"],
      descripcion: json["descripcion"],
      precioBase: json["precioBase"],
      estado: json["estado"],
      tipo: json["tipo"],
    );
  }

  Map<String, dynamic> toJson() => {
    'idServicio': idServicio,
    'nombreServicio': nombreServicio,
    'descripcion': descripcion,
    'precioBase': precioBase,
    'estado': estado,
    'tipo': tipo,
  };
}
