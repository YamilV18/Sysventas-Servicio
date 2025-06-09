import 'package:dio/dio.dart';
import 'package:sysventas/apis/tipo_servicio_api.dart';
import 'package:sysventas/modelo/TipoServicioModelo.dart';
import 'package:sysventas/util/TokenUtil.dart';

class TipoServicioRepository {
  TipoServicioApi? tipoServicioApi;

  TipoServicioRepository() {
    Dio _dio = Dio();
    _dio.options.headers["Content-Type"] = "application/json";
    tipoServicioApi = TipoServicioApi(_dio);
  }

  Future<List<TipoServicio>> getEntidad() async {
    return await tipoServicioApi!.getTipo(TokenUtil.TOKEN).then((
        value) => value);
  }
}