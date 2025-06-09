import 'package:dio/dio.dart';
import 'package:sysventas/apis/servicio_api.dart';
import 'package:sysventas/modelo/MessageModelo.dart';
import 'package:sysventas/modelo/ServicioModelo.dart';
import 'package:sysventas/util/TokenUtil.dart';

class ServicioRepository{
  ServicioApi? servicioApi;

  ServicioRepository(){
    Dio _dio=Dio();
    _dio.options.headers["Content-Type"]="application/json";
    servicioApi=ServicioApi(_dio);
  }

  Future<List<ServicioResp>> getEntidad() async{
    return await servicioApi!.getServicio(TokenUtil.TOKEN).then((value)=>value);
  }

  Future<Message> deleteEntidad(int id) async{
    return await servicioApi!.deleteServicio(TokenUtil.TOKEN, id);
  }

  Future<ServicioResp> updateEntidad(int id, ServicioDto servicio) async{
    return await servicioApi!.updateServicio(TokenUtil.TOKEN, id, servicio);
  }

  Future<Message> createEntidad(ServicioCreateDto servicio) async{
    return await servicioApi!.crearServicio(TokenUtil.TOKEN, servicio);
  }

}