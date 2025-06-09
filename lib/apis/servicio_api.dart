import 'package:dio/dio.dart';
import 'package:sysventas/modelo/ServicioModelo.dart';
import 'package:sysventas/util/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sysventas/modelo/MessageModelo.dart';

part 'servicio_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class ServicioApi{
  factory ServicioApi(Dio dio, {String baseUrl})=_ServicioApi;

  static ServicioApi create(){
    final dio=Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ServicioApi(dio);
  }

  @GET("/servicios")
  Future<List<ServicioResp>> getServicio(@Header("Authorization") String token);

  @POST("/servicios")
  Future<Message> crearServicio(@Header("Authorization") String token, @Body() ServicioCreateDto servicio);

  @GET("/servicios/{id}")
  Future<ServicioResp> findServicio(@Header("Authorization") String token, @Path("id") int id);

  @DELETE("/servicios/{id}")
  Future<Message> deleteServicio(@Header("Authorization") String token, @Path("id") int id );

  @PUT("/servicios/{id}")
  Future<ServicioResp> updateServicio(@Header("Authorization") String token, @Path("id") int id, @Body() ServicioDto servicio);
}