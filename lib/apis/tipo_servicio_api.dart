import 'package:sysventas/modelo/TipoServicioModelo.dart';
import 'package:sysventas/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'tipo_servicio_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class TipoServicioApi{
  factory TipoServicioApi(Dio dio, {String baseUrl})=_TipoServicioApi;

  static TipoServicioApi create(){
    final dio=Dio();
    dio.interceptors.add(PrettyDioLogger());
    return TipoServicioApi(dio);
  }

  @GET("/tipos")
  Future<List<TipoServicio>> getTipo(@Header("Authorization") String token);

}