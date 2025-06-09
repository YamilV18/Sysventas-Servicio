
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UsuarioModelo {
  late final String email;
  late final String clave;

  UsuarioModelo({
    required this.email,
    required this.clave,
  });

  UsuarioModelo.login(this.email, this.clave);
  //UsuarioModelo.loginDos(this.email, this.clave):rol="", estado="";

  factory UsuarioModelo.fromJson(Map<String, dynamic> json){
    return UsuarioModelo(
      email : json['email'],
      clave : json['clave'],
      //rol : json['rol'],
      //estado : json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['clave'] = clave;
    //_data['rol'] = rol;
    //_data['estado'] = estado;
    return _data;
  }
}

class UsuarioLogin {
  UsuarioLogin({
    required this.email,
    required this.clave,
  });

  late final String email;
  late final String clave;

  UsuarioLogin.login(this.email, this.clave);

  factory UsuarioLogin.fromJson(Map<String, dynamic> json){
    return UsuarioLogin(
      email: json["email"],
      clave: json["clave"],
    );
  }

  Map<String, dynamic> toJson() => {
    "email": email,
    "clave": clave,
  };

}


class UsuarioResp {
  UsuarioResp({
    required this.idUsuario,
    required this.email,
    //required this.estado,
    required this.token,
  });

  late final int idUsuario;
  late final String email;
  //late final String estado;
  late final String token;

  factory UsuarioResp.fromJson(Map<String, dynamic> json){
    return UsuarioResp(
      idUsuario: json["idUsuario"],
      email: json["email"],
      //estado: json["estado"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "idUsuario": idUsuario,
    "email": email,
    //"estado": estado,
    "token": token,
  };

  @override
  String toString(){
    return "$idUsuario, $email, $token, ";
  }
}